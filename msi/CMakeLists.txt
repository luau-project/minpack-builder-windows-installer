cmake_minimum_required(VERSION 3.20)

project(MinpackBuilderMsi
    VERSION "0.0.1")

if (NOT DEFINED PROJECT_SETTINGS)
    message(FATAL_ERROR "Parameter \"PROJECT_SETTINGS\" not defined. You must supply a json configuration file as cmake parameter: \"-DPROJECT_SETTINGS=path/to/config.json\".")
endif()

set(PROJECT_SETTINGS "${CMAKE_CURRENT_SOURCE_DIR}/project-settings.json" CACHE PATH "Path to the JSON configuration file.")

if (NOT DEFINED MINPACK_BUILDER_VERSION)
    message(FATAL_ERROR "Parameter \"MINPACK_BUILDER_VERSION\" not defined. You must supply the version of Minpack Builder as cmake parameter: \"-DMINPACK_BUILDER_VERSION=X.Y.Z\" where X, Y and Z are numbers on range 0 - 255.")
endif()

if ("${MINPACK_BUILDER_VERSION}" MATCHES "^([0-9]+)\\.([0-9]+)\\.([0-9]+)\$")
    if ((${CMAKE_MATCH_1} LESS "0" OR ${CMAKE_MATCH_1} GREATER "255") OR (${CMAKE_MATCH_2} LESS "0" OR ${CMAKE_MATCH_2} GREATER "255") OR (${CMAKE_MATCH_3} LESS "0" OR ${CMAKE_MATCH_3} GREATER "65535"))
        message(FATAL_ERROR "Parameter \"MINPACK_BUILDER_VERSION\" must match the format X.Y.Z where X and Y are numbers on range 0 - 255, and Z is on range 0 - 65535.")
    endif()
else()
    message(FATAL_ERROR "Parameter \"MINPACK_BUILDER_VERSION\" must match the format X.Y.Z where X and Y are numbers on range 0 - 255, and Z is on range 0 - 65535.")
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

set(WIXTOOLSET_MSI_NAME_WE "${PROJECT_NAME}-${PROJECT_VERSION}-${__culture_lower}")
set(WIXTOOLSET_MSI_NAME "${WIXTOOLSET_MSI_NAME_WE}.msi")
set(WIXTOOLSET_MSI_PROJECT_DIR "${CMAKE_CURRENT_BINARY_DIR}/msi-wixtoolset-v5")
set(WIXTOOLSET_MSI_PROJECT_ARCHIVES_DIR "${CMAKE_CURRENT_BINARY_DIR}/msi-archives-wixtoolset")
set(WIXTOOLSET_MSI_PROJECT_INCLUDE_FILE_NAME "MinpackBuilder.wxi")
set(WIXTOOLSET_MSI_PROJECT_MAIN_FILE_NAME "MinpackBuilder.wxs")
set(WIXTOOLSET_MSI_PROJECT_VERSION_FILE_NAME "msi-version.txt")
set(WIXTOOLSET_BA_PROJECT_SETTINGS_FILE_NAME "bootstrapper-application-project-settings.json")
set(WIXTOOLSET_MSI_PROJECT_BAT_FILE_NAME "msi.bat")
set(WIXTOOLSET_MSI_PROJECT_MINPACK_BUILDER_REPOSITORY_URL "https://github.com/luau-project/minpack-builder")
set(WIXTOOLSET_MSI_PROJECT_MINPACK_BUILDER_DIALOG_FILE_NAME "MinpackBuilderDialog.wxs")
set(WIXTOOLSET_MSI_PROJECT_MINPACK_BUILDER_CUSTOMIZE_DIALOG_FILE_NAME "MinpackBuilderCustomizeDialog.wxs")
set(WIXTOOLSET_MSI_PROJECT_MINPACK_BUILDER_LICENSE_RTF_FILE_NAME "LICENSE.rtf")
set(WIXTOOLSET_MSI_PROJECT_MINPACK_BUILDER_LICENSE_PDF_FILE_NAME "LICENSE.pdf")

include(cmake/Utilities.cmake)
include(cmake/GenerateProjectConfigWxi.cmake)
include(cmake/GenerateMinpackBuilderLicenses.cmake)
include(cmake/GenerateMinpackBuilderCustomizeDialogWxs.cmake)
include(cmake/GenerateMinpackBuilderMainFile.cmake)

include(cmake/HarvestDirectory.cmake)
include(cmake/GenerateBootstrapperApplicationProjectSettings.cmake)
include(cmake/ParseCompilerSettings.cmake)
include(cmake/GenerateMsiBat.cmake)
include(cmake/GenerateArchives.cmake)

get_LCID_from_culture("${__culture_lower}" __MinpackBuilderLCID)
get_guid(WIXTOOLSET_MSI_PROJECT_UPGRADE_CODE_RAW)

set(WIXTOOLSET_MSI_PROJECT_UPGRADE_CODE "{${WIXTOOLSET_MSI_PROJECT_UPGRADE_CODE_RAW}}")
set(WIXTOOLSET_MSI_PROJECT_MANUFACTURER "Luau Project")
set(WIXTOOLSET_MSI_PROJECT_PRODUCT_NAME "Minpack Builder")
set(WIXTOOLSET_MSI_PROJECT_LANGUAGE "${__MinpackBuilderLCID}")
set(WIXTOOLSET_MSI_PROJECT_CULTURE "${__culture_lower}")
set(WIXTOOLSET_MSI_PROJECT_VERSION "${PROJECT_VERSION}")
set(WIXTOOLSET_MSI_PROJECT_PACKAGE_NAME "${WIXTOOLSET_MSI_PROJECT_PRODUCT_NAME} ${MINPACK_BUILDER_VERSION}")
set(WIXTOOLSET_MSI_PROJECT_REGISTRY_ROOT "HKLM")
set(WIXTOOLSET_MSI_PROJECT_REGISTRY_KEY "Software\\${WIXTOOLSET_MSI_PROJECT_MANUFACTURER}\\${WIXTOOLSET_MSI_PROJECT_PRODUCT_NAME}")
set(WIXTOOLSET_MSI_PROJECT_ACTIVE_COMPILER_ID_REGISTRY_KEY "Software\\${WIXTOOLSET_MSI_PROJECT_MANUFACTURER}\\${WIXTOOLSET_MSI_PROJECT_PRODUCT_NAME}\\ActiveCompiler\\Id")
set(WIXTOOLSET_MSI_PROJECT_ACTIVE_COMPILER_CHOICE_PROPERTY "ACTIVECOMPILER")

begin_project_config_wxi()
append_blank_line_on_project_config_wxi()
append_comment_on_project_config_wxi("start of project settings")
append_define_on_project_config_wxi("UpgradeCode" "${WIXTOOLSET_MSI_PROJECT_UPGRADE_CODE}")
append_define_on_project_config_wxi("Manufacturer" "${WIXTOOLSET_MSI_PROJECT_MANUFACTURER}")
append_define_on_project_config_wxi("ProductName" "${WIXTOOLSET_MSI_PROJECT_PRODUCT_NAME}")
append_define_on_project_config_wxi("MinpackBuilderLanguage" "${WIXTOOLSET_MSI_PROJECT_LANGUAGE}")
append_define_on_project_config_wxi("MinpackBuilderVersion" "${MINPACK_BUILDER_VERSION}")
append_define_on_project_config_wxi("MinpackBuilderMsiVersion" "${WIXTOOLSET_MSI_PROJECT_VERSION}")
append_define_on_project_config_wxi("PackageName" "${WIXTOOLSET_MSI_PROJECT_PACKAGE_NAME}")
append_define_on_project_config_wxi("MinpackBuilderRegistryRoot" "${WIXTOOLSET_MSI_PROJECT_REGISTRY_ROOT}")
append_define_on_project_config_wxi("MinpackBuilderRegistryKey" "${WIXTOOLSET_MSI_PROJECT_REGISTRY_KEY}")

get_filename_component(__minpack_sources_dir_name "${MINPACK_SOURCES}" NAME)
append_define_on_project_config_wxi("MinpackSourceCodeDirectory" "minpack-source-code\\${__minpack_sources_dir_name}")

get_filename_component(__minpack_builder_sources_dir_name "${MINPACK_BUILDER_SOURCES}" NAME)
append_define_on_project_config_wxi("MinpackBuilderSourceCodeDirectory" "minpack-builder-source-code\\${__minpack_builder_sources_dir_name}")

append_define_on_project_config_wxi("LicenseRTF" "LICENSE.rtf")
append_define_on_project_config_wxi("LicensePDF" "LICENSE.pdf")

append_define_on_project_config_wxi("ActiveCompilerRegistryKey" "\$(MinpackBuilderRegistryKey)\\ActiveCompiler")
append_define_on_project_config_wxi("InstalledCompilersRegistryKey" "\$(MinpackBuilderRegistryKey)\\InstalledCompilers")
append_define_on_project_config_wxi("ActiveCompilerChoiceProperty" "${WIXTOOLSET_MSI_PROJECT_ACTIVE_COMPILER_CHOICE_PROPERTY}")
append_comment_on_project_config_wxi("end of project settings")

parse_compiler_settings_from_json("${PROJECT_SETTINGS}" compiler_ids ba_compilers_json)
append_blank_line_on_project_config_wxi()
end_project_config_wxi()

write_ba_project_settings(
    "${WIXTOOLSET_MSI_PROJECT_UPGRADE_CODE}"
    "${WIXTOOLSET_MSI_PROJECT_MANUFACTURER}"
    "${WIXTOOLSET_MSI_PROJECT_PRODUCT_NAME}"
    "${WIXTOOLSET_MSI_PROJECT_LANGUAGE}"
    "${WIXTOOLSET_MSI_PROJECT_CULTURE}"
    "${WIXTOOLSET_MSI_PROJECT_VERSION}"
    "${WIXTOOLSET_MSI_PROJECT_PACKAGE_NAME}"
    "${WIXTOOLSET_MSI_PROJECT_REGISTRY_ROOT}"
    "${WIXTOOLSET_MSI_PROJECT_REGISTRY_KEY}"
    "${WIXTOOLSET_MSI_PROJECT_ACTIVE_COMPILER_ID_REGISTRY_KEY}"
    "${WIXTOOLSET_MSI_PROJECT_ACTIVE_COMPILER_CHOICE_PROPERTY}"
    "${ba_compilers_json}"
)

file(COPY
    "localization/WixUI_${WIXTOOLSET_MSI_PROJECT_CULTURE}.wxl"
    DESTINATION
    "${WIXTOOLSET_MSI_PROJECT_DIR}")

write_minpack_builder_customize_dialog_wxs("${compiler_ids}")

configure_file(
    templates/MinpackBuilderDialog.wxs.in
    "${WIXTOOLSET_MSI_PROJECT_DIR}/${WIXTOOLSET_MSI_PROJECT_MINPACK_BUILDER_DIALOG_FILE_NAME}"
    NEWLINE_STYLE WIN32)

write_minpack_builder_main_file_wxs("${compiler_ids}")

write_minpack_builder_license_rtf()
write_minpack_builder_license_pdf()

write_msi_bat()

# Creating archives (.zip and .tar.gz) for the generated WixToolset project.
# Also, storing hashes (SHA256 and MD5) for the archives.
write_archives()