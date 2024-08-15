cmake_minimum_required(VERSION 3.20)

project(MinpackBuilderInstaller)

include(cmake/Utilities.cmake)
include(cmake/GenerateProjectConfigWxi.cmake)

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

parse_compiler_settings_from_json("${PROJECT_SETTINGS}")
append_blank_line_on_project_config_wxi()
end_project_config_wxi()