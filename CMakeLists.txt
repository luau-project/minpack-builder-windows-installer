cmake_minimum_required(VERSION 3.20)

project(MinpackBuilderInstaller
    VERSION "1.0.0")

if (NOT DEFINED PROJECT_SETTINGS)
    message(FATAL_ERROR "Parameter \"PROJECT_SETTINGS\" not defined. You must supply a json configuration file as cmake parameter: \"-DPROJECT_SETTINGS=path/to/config.json\".")
endif()

if (NOT DEFINED MINPACK_BUILDER_VERSION)
    message(FATAL_ERROR "Parameter \"MINPACK_BUILDER_VERSION\" not defined. You must supply the version of Minpack Builder as cmake parameter: \"-DMINPACK_BUILDER_VERSION=X.Y.Z\" where X, Y and Z are numbers on range 0 - 255.")
endif()

if ("${MINPACK_BUILDER_VERSION}" MATCHES "^([0-9]+)\\.([0-9]+)\\.([0-9]+)\$")
    if ((${CMAKE_MATCH_1} LESS "0" OR ${CMAKE_MATCH_1} GREATER "255") OR (${CMAKE_MATCH_2} LESS "0" OR ${CMAKE_MATCH_2} GREATER "255") OR (${CMAKE_MATCH_3} LESS "0" OR ${CMAKE_MATCH_3} GREATER "255"))
        message(FATAL_ERROR "Parameter \"MINPACK_BUILDER_VERSION\" must match the format X.Y.Z where X, Y and Z are numbers on range 0 - 255.")
    endif()
else()
    message(FATAL_ERROR "Parameter \"MINPACK_BUILDER_VERSION\" must match the format X.Y.Z where X, Y and Z are numbers on range 0 - 255.")
endif()

set(MINPACK_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Directory of the source code of Minpack.")

if (NOT EXISTS "${MINPACK_SOURCES}/disclaimer")
    message(FATAL_ERROR "The license file of the Minpack project was not found. Please, set the proper directory for the source code of Minpack as \"-DMINPACK_SOURCES=path/to/minpack\"")
endif()

set(MINPACK_BUILDER_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Directory of the source code of Minpack Builder.")

if (NOT EXISTS "${MINPACK_BUILDER_SOURCES}/LICENSE.md")
    message(FATAL_ERROR "The license file of the Minpack Builder project was not found. Please, set the proper directory for the source code of Minpack Builder project as \"-DMINPACK_BUILDER_SOURCES=path/to/minpack-builder\"")
endif()

set(INSTALLER_CULTURE "en-us" CACHE STRING "Culture of the installer.")

string(TOLOWER "${INSTALLER_CULTURE}" __culture_lower)

set(WIXTOOLSET_PROJECT_DIR "${CMAKE_BINARY_DIR}/wixtoolset-v5")
set(WIXTOOLSET_PROJECT_INCLUDE_FILE_NAME "MinpackBuilder.wxi")
set(WIXTOOLSET_PROJECT_MAIN_FILE_NAME "MinpackBuilder.wxs")
set(WIXTOOLSET_PROJECT_MINPACK_BUILDER_REPOSITORY_URL "https://github.com/luau-project/minpack-builder")
set(WIXTOOLSET_PROJECT_MINPACK_BUILDER_DIALOG_FILE_NAME "MinpackBuilderDialog.wxs")
set(WIXTOOLSET_PROJECT_MINPACK_BUILDER_CUSTOMIZE_DIALOG_FILE_NAME "MinpackBuilderCustomizeDialog.wxs")
set(WIXTOOLSET_PROJECT_MINPACK_BUILDER_LICENSE_RTF_FILE_NAME "LICENSE.rtf")
set(WIXTOOLSET_PROJECT_MINPACK_BUILDER_LICENSE_PDF_FILE_NAME "LICENSE.pdf")

include(cmake/Utilities.cmake)
include(cmake/GenerateProjectConfigWxi.cmake)
include(cmake/GenerateMinpackBuilderLicenses.cmake)
include(cmake/GenerateMinpackBuilderCustomizeDialogWxs.cmake)
include(cmake/GenerateMinpackBuilderMainFile.cmake)

include(cmake/HarvestDirectory.cmake)
include(cmake/ParseCompilerSettings.cmake)

get_LCID_from_culture("${__culture_lower}" __MinpackBuilderLCID)

begin_project_config_wxi()
append_blank_line_on_project_config_wxi()
append_comment_on_project_config_wxi("start of project settings")
append_define_guid_on_project_config_wxi("UpgradeCode")
append_define_on_project_config_wxi("Manufacturer" "Luau Project")
append_define_on_project_config_wxi("PackageName" "Minpack Builder")
append_define_on_project_config_wxi("MinpackBuilderLanguage" "${__MinpackBuilderLCID}")
append_define_on_project_config_wxi("MinpackBuilderVersion" "${MINPACK_BUILDER_VERSION}")
append_define_on_project_config_wxi("MinpackBuilderInstallerVersion" "${PROJECT_VERSION}")
append_define_on_project_config_wxi("MinpackBuilderRegistryRoot" "HKLM")
append_define_on_project_config_wxi("MinpackBuilderRegistryKey" [[Software\$(Manufacturer)\$(PackageName)]])

get_filename_component(__minpack_sources_dir_name "${MINPACK_SOURCES}" NAME)
append_define_on_project_config_wxi("MinpackSourceCodeDirectory" "minpack-source-code\\${__minpack_sources_dir_name}")

get_filename_component(__minpack_builder_sources_dir_name "${MINPACK_BUILDER_SOURCES}" NAME)
append_define_on_project_config_wxi("MinpackBuilderSourceCodeDirectory" "minpack-builder-source-code\\${__minpack_builder_sources_dir_name}")

append_define_on_project_config_wxi("LicenseRTF" "LICENSE.rtf")
append_define_on_project_config_wxi("LicensePDF" "LICENSE.pdf")

append_define_on_project_config_wxi("ActiveCompilerRegistryKey" "\$(MinpackBuilderRegistryKey)\\ActiveCompiler")
append_define_on_project_config_wxi("InstalledCompilersRegistryKey" "\$(MinpackBuilderRegistryKey)\\InstalledCompilers")
append_define_on_project_config_wxi("ActiveCompilerChoiceProperty" "ACTIVECOMPILER")
append_comment_on_project_config_wxi("end of project settings")

parse_compiler_settings_from_json("${PROJECT_SETTINGS}" compiler_ids)
append_blank_line_on_project_config_wxi()
end_project_config_wxi()

file(COPY
    "wixtoolset-dialogs/WixUI_${__culture_lower}.wxl"
    DESTINATION
    "${WIXTOOLSET_PROJECT_DIR}")

write_minpack_builder_customize_dialog_wxs("${compiler_ids}")

configure_file(
    wixtoolset-dialogs/MinpackBuilderDialog.wxs
    "${WIXTOOLSET_PROJECT_DIR}/${WIXTOOLSET_PROJECT_MINPACK_BUILDER_DIALOG_FILE_NAME}"
    NEWLINE_STYLE WIN32)

write_minpack_builder_main_file_wxs("${compiler_ids}")

write_minpack_builder_license_rtf()
write_minpack_builder_license_pdf()

set(__wix_build_cmd
    "wix" "build" "-nologo" "-arch" "x64" "-ext" "WixToolset.UI.wixext")

file(GLOB __wix_source_files
    RELATIVE "${WIXTOOLSET_PROJECT_DIR}"
    "${WIXTOOLSET_PROJECT_DIR}/*.wxs")

file(GLOB __wix_localization_files
    RELATIVE "${WIXTOOLSET_PROJECT_DIR}"
    "${WIXTOOLSET_PROJECT_DIR}/*.wxl")

foreach(wix_wxs "${__wix_source_files}")
    list(APPEND __wix_build_cmd ${wix_wxs})
endforeach()

foreach(wix_wxl "${__wix_localization_files}")
    list(APPEND __wix_build_cmd ${wix_wxl})
endforeach()

list(APPEND __wix_build_cmd "-out")
list(APPEND __wix_build_cmd "MinpackBuilderInstaller-${__culture_lower}.msi")

list(JOIN __wix_build_cmd " " __wix_build_cmd)

file(WRITE "${WIXTOOLSET_PROJECT_DIR}/msi.bat" "${__wix_build_cmd}")