cmake_minimum_required(VERSION 3.20)

project(MinpackBuilderInstaller)

if (NOT DEFINED PROJECT_SETTINGS)
    message(FATAL_ERROR "Parameter \"PROJECT_SETTINGS\" not defined. You must supply a json configuration file as cmake parameter: \"-DPROJECT_SETTINGS=path/to/config.json\".")
endif()

include(cmake/Utilities.cmake)
include(cmake/GenerateProjectConfigWxi.cmake)
include(cmake/GenerateMinpackBuilderCustomizeDialogWxs.cmake)

include(cmake/HarvestDirectory.cmake)
include(cmake/ParseCompilerSettings.cmake)

begin_project_config_wxi()
append_blank_line_on_project_config_wxi()
append_comment_on_project_config_wxi("start of project settings")
append_define_guid_on_project_config_wxi("UpgradeCode")
append_define_on_project_config_wxi("Manufacturer" "Luau Project")
append_define_on_project_config_wxi("PackageName" "Minpack Builder")
append_define_on_project_config_wxi("MinpackBuilderVersion" "1.1.0")
append_define_on_project_config_wxi("MinpackBuilderInstallerVersion" "1.0.0")
append_define_on_project_config_wxi("LicenseRTF" "LICENSE.rtf")
append_define_on_project_config_wxi("LicensePDF" "LICENSE.pdf")
append_comment_on_project_config_wxi("end of project settings")

parse_compiler_settings_from_json("${PROJECT_SETTINGS}" compiler_ids)
append_blank_line_on_project_config_wxi()
end_project_config_wxi()

write_minpack_builder_customize_dialog_wxs("${compiler_ids}")
configure_file(
    wixtoolset-dialogs/minpack-builder-dialog.wxs
    "${CMAKE_BINARY_DIR}/wixtoolset-v5/minpack-builder-dialog.wxs"
    NEWLINE_STYLE WIN32)