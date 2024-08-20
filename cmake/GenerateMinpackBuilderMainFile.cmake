function(__begin_minpack_builder_main_file_wxs)
    set(__target_dir "${WIXTOOLSET_PROJECT_DIR}")

    file(MAKE_DIRECTORY ${__target_dir})

    set(__target_file "${__target_dir}/${WIXTOOLSET_PROJECT_MAIN_FILE_NAME}")

    if (EXISTS ${__target_file})
        file(REMOVE ${__target_file})
    endif()

    file_append_line(${__target_file} "<?xml version=\"1.0\" encoding=\"utf-8\" ?>")
    file_append_line(${__target_file} "<Wix xmlns=\"http://wixtoolset.org/schemas/v4/wxs\">")
endfunction()

function(__append_lines_on_minpack_builder_main_file_wxs lines)
    set(__target_dir "${WIXTOOLSET_PROJECT_DIR}")
    set(__target_file "${__target_dir}/${WIXTOOLSET_PROJECT_MAIN_FILE_NAME}")

    if (NOT EXISTS ${__target_file})
        message(FATAL_ERROR "File \"${__target_file}\" not found")
    endif()

    foreach(line_content "${lines}")
        file_append_line(${__target_file} "${line_content}")
    endforeach()
endfunction()

function(__append_indented_lines_on_minpack_builder_main_file_wxs indent_level lines)
    get_tabs_indentation("${indent_level}" content_indentation)
    foreach (line_content ${lines})
        __append_lines_on_minpack_builder_main_file_wxs("${content_indentation}${line_content}")
    endforeach()
endfunction()

function(__append_blank_line_on_minpack_builder_main_file_wxs indent_level)
    get_tabs_indentation("${indent_level}" content_indentation)
    __append_lines_on_minpack_builder_main_file_wxs("${content_indentation}")
endfunction()

function(__append_comment_on_minpack_builder_main_file_wxs indent_level comment_value)
    get_tabs_indentation("${indent_level}" content_indentation)
    __append_lines_on_minpack_builder_main_file_wxs("${content_indentation}<!-- ${comment_value} -->")
endfunction()

function(__end_minpack_builder_main_file_wxs)
    __append_lines_on_minpack_builder_main_file_wxs("</Wix>")
endfunction()

function(write_minpack_builder_main_file_wxs compiler_ids)
    __begin_minpack_builder_main_file_wxs()
    __append_blank_line_on_minpack_builder_main_file_wxs(1)
    __append_comment_on_minpack_builder_main_file_wxs(1 "Load project definitions")
    __append_indented_lines_on_minpack_builder_main_file_wxs(1 "<?include ${WIXTOOLSET_PROJECT_INCLUDE_FILE_NAME}?>")
    __append_blank_line_on_minpack_builder_main_file_wxs(1)
    __append_indented_lines_on_minpack_builder_main_file_wxs(1 "<Package Name=\"\$(PackageName)\" Version=\"\$(MinpackBuilderInstallerVersion)\" Manufacturer=\"\$(Manufacturer)\" UpgradeCode=\"\$(UpgradeCode)\">")
    __append_blank_line_on_minpack_builder_main_file_wxs(2)
    __append_comment_on_minpack_builder_main_file_wxs(2 "Reference properties for each compiler")
    foreach(compiler_id ${compiler_ids})
        __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<PropertyRef Id=\"\$(${compiler_id}ChoiceProperty)\" />")
    endforeach()
    __append_blank_line_on_minpack_builder_main_file_wxs(2)
    __append_comment_on_minpack_builder_main_file_wxs(2 "Installation directories for the project")
    __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<StandardDirectory Id=\"ProgramFiles6432Folder\">")
    __append_indented_lines_on_minpack_builder_main_file_wxs(3 "<Directory Name=\"\$(Manufacturer)\">")
    __append_indented_lines_on_minpack_builder_main_file_wxs(4 "<Directory Id=\"INSTALLFOLDER\" Name=\"\$(PackageName)\">")

    # Minpack source code
    __append_blank_line_on_minpack_builder_main_file_wxs(5)
    __append_comment_on_minpack_builder_main_file_wxs(5 "start of Source code")
    __append_indented_lines_on_minpack_builder_main_file_wxs(5 "<Directory Name=\"Source code\">")
    __append_blank_line_on_minpack_builder_main_file_wxs(6)
    __append_comment_on_minpack_builder_main_file_wxs(6 "Minpack")
    __append_indented_lines_on_minpack_builder_main_file_wxs(6 "<Directory Id=\"MinpackSourceCodeDir\" Name=\"Minpack\" />")

    get_filename_component(__minpack_sources_dir_name "${MINPACK_SOURCES}" NAME)
    set(__minpack_sources_dir "${WIXTOOLSET_PROJECT_DIR}/minpack-source-code/${__minpack_sources_dir_name}")

    if (IS_DIRECTORY "${__minpack_sources_dir}/minpack-source-code")
        file(REMOVE_RECURSE "${__minpack_sources_dir}/minpack-source-code")
    endif()

    file(COPY "${MINPACK_SOURCES}" DESTINATION "${WIXTOOLSET_PROJECT_DIR}/minpack-source-code")

    if (NOT EXISTS "${__minpack_sources_dir}")
        message(FATAL_ERROR "Minpack source code directory not found.")
    endif()

    harvest_directory(
        "${__minpack_sources_dir}"
        "${WIXTOOLSET_PROJECT_DIR}/MinpackSourceCode.wxs"
        "MinpackBuilder.wxi"
        "MinpackSourceCodeDirectory"
        "MinpackSourceCodeDir"
        "MinpackSourceCodeComponentGroup")

    # Minpack Builder source code
    __append_blank_line_on_minpack_builder_main_file_wxs(6)
    __append_comment_on_minpack_builder_main_file_wxs(6 "Minpack Builder")
    __append_indented_lines_on_minpack_builder_main_file_wxs(6 "<Directory Name=\"Minpack Builder\">")
    __append_indented_lines_on_minpack_builder_main_file_wxs(7 "<Directory Id=\"MinpackBuilderSourceCodeDir\" Name=\"\$(MinpackBuilderVersion)\"/>")
    __append_indented_lines_on_minpack_builder_main_file_wxs(6 "</Directory>")
    __append_blank_line_on_minpack_builder_main_file_wxs(6)
    __append_indented_lines_on_minpack_builder_main_file_wxs(5 "</Directory>")
    __append_comment_on_minpack_builder_main_file_wxs(5 "end of Source code")
        
    get_filename_component(__minpack_builder_sources_dir_name "${MINPACK_BUILDER_SOURCES}" NAME)
    set(__minpack_builder_sources_dir "${WIXTOOLSET_PROJECT_DIR}/minpack-builder-source-code/${__minpack_builder_sources_dir_name}")

    if (IS_DIRECTORY "${__minpack_builder_sources_dir}/minpack-builder-source-code")
        file(REMOVE_RECURSE "${__minpack_builder_sources_dir}/minpack-builder-source-code")
    endif()

    file(COPY "${MINPACK_BUILDER_SOURCES}" DESTINATION "${WIXTOOLSET_PROJECT_DIR}/minpack-builder-source-code")

    if (NOT EXISTS "${__minpack_builder_sources_dir}")
        message(FATAL_ERROR "MinpackBuilder source code directory not found.")
    endif()

    harvest_directory(
        "${__minpack_builder_sources_dir}"
        "${WIXTOOLSET_PROJECT_DIR}/MinpackBuilderSourceCode.wxs"
        "MinpackBuilder.wxi"
        "MinpackBuilderSourceCodeDirectory"
        "MinpackBuilderSourceCodeDir"
        "MinpackBuilderSourceCodeComponentGroup")

    __append_blank_line_on_minpack_builder_main_file_wxs(5)
    __append_comment_on_minpack_builder_main_file_wxs(5 "start of Binaries")
    __append_indented_lines_on_minpack_builder_main_file_wxs(5 "<Directory Name=\"Binaries\">")

    foreach(compiler_id ${compiler_ids})
        __append_blank_line_on_minpack_builder_main_file_wxs(6)
        __append_comment_on_minpack_builder_main_file_wxs(6 "Installation directory for ${compiler_id}")
        __append_indented_lines_on_minpack_builder_main_file_wxs(6 "<Directory Name=\"\$(${compiler_id}CompilerName)\">")
        __append_indented_lines_on_minpack_builder_main_file_wxs(7 "<Directory Name=\"\$(${compiler_id}Version)\">")
        __append_indented_lines_on_minpack_builder_main_file_wxs(8 "<Directory Id=\"${compiler_id}InstallDir\" Name=\"\$(${compiler_id}HostArch)\" />")
        __append_indented_lines_on_minpack_builder_main_file_wxs(7 "</Directory>")
        __append_indented_lines_on_minpack_builder_main_file_wxs(6 "</Directory>")
    endforeach()

    __append_blank_line_on_minpack_builder_main_file_wxs(6)
    __append_indented_lines_on_minpack_builder_main_file_wxs(5 "</Directory>")
    __append_comment_on_minpack_builder_main_file_wxs(5 "end of Binaries")

    __append_blank_line_on_minpack_builder_main_file_wxs(5)
    __append_indented_lines_on_minpack_builder_main_file_wxs(4 "</Directory>")
    __append_indented_lines_on_minpack_builder_main_file_wxs(3 "</Directory>")
    __append_indented_lines_on_minpack_builder_main_file_wxs(2 "</StandardDirectory>")
    
    __append_blank_line_on_minpack_builder_main_file_wxs(2)
    __append_comment_on_minpack_builder_main_file_wxs(2 "Feature for the license")
    __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<Feature Id=\"MinpackBuilderLicenseFeature\" Title=\"Minpack Builder License\" Level=\"1\">")
    __append_indented_lines_on_minpack_builder_main_file_wxs(3 "<Component>")
    __append_indented_lines_on_minpack_builder_main_file_wxs(4 "<File Source=\"$(LicensePDF)\" />")
    __append_indented_lines_on_minpack_builder_main_file_wxs(3 "</Component>")
    __append_indented_lines_on_minpack_builder_main_file_wxs(2 "</Feature>")
    
    __append_blank_line_on_minpack_builder_main_file_wxs(2)
    __append_comment_on_minpack_builder_main_file_wxs(2 "Feature for Minpack source code")
    __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<Feature Id=\"MinpackSourceCodeFeature\" Title=\"Minpack source code\" Level=\"1\">")
    __append_indented_lines_on_minpack_builder_main_file_wxs(3 "<ComponentGroupRef Id=\"MinpackSourceCodeComponentGroup\" />")
    __append_indented_lines_on_minpack_builder_main_file_wxs(2 "</Feature>")
    
    __append_blank_line_on_minpack_builder_main_file_wxs(2)
    __append_comment_on_minpack_builder_main_file_wxs(2 "Feature for Minpack Builder source code")
    __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<Feature Id=\"MinpackBuilderSourceCodeFeature\" Title=\"Minpack Builder source code\" Level=\"1\">")
    __append_indented_lines_on_minpack_builder_main_file_wxs(3 "<ComponentGroupRef Id=\"MinpackBuilderSourceCodeComponentGroup\" />")
    __append_indented_lines_on_minpack_builder_main_file_wxs(2 "</Feature>")

    foreach(compiler_id ${compiler_ids})
        get_filename_component(__compiler_binaries_dir_name "${${compiler_id}_BINARIES_DIR}" NAME)
        set(__compiler_binaries_dir "${WIXTOOLSET_PROJECT_DIR}/binaries/${compiler_id}/${__compiler_binaries_dir_name}")

        if (IS_DIRECTORY "${__compiler_binaries_dir}/${__compiler_binaries_dir_name}")
            file(REMOVE_RECURSE "${__compiler_binaries_dir}/${__compiler_binaries_dir_name}")
        endif()

        file(COPY "${${compiler_id}_BINARIES_DIR}" DESTINATION "${WIXTOOLSET_PROJECT_DIR}/binaries/${compiler_id}")

        if (NOT EXISTS "${__compiler_binaries_dir}")
            message(FATAL_ERROR "MinpackBuilder source code directory not found.")
        endif()

        harvest_directory(
            "${__compiler_binaries_dir}"
            "${WIXTOOLSET_PROJECT_DIR}/${compiler_id}Binaries.wxs"
            "MinpackBuilder.wxi"
            "${compiler_id}BinariesDir"
            "${compiler_id}InstallDir"
            "${compiler_id}BinariesComponentGroup")

        __append_blank_line_on_minpack_builder_main_file_wxs(2)
        __append_comment_on_minpack_builder_main_file_wxs(2 "Feature to install the binaries for compiler ${compiler_id}")
        __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<Feature Id=\"${compiler_id}BinariesFeature\" Title=\"Binaries for the compiler \$(${compiler_id}DisplayText)\" Level=\"1\">")
        __append_indented_lines_on_minpack_builder_main_file_wxs(3 "<ComponentGroupRef Id=\"${compiler_id}BinariesComponentGroup\" />")
        __append_indented_lines_on_minpack_builder_main_file_wxs(2 "</Feature>")

        configure_file(templates/CompilerEnvironmentVariables.wxs.in
            "${WIXTOOLSET_PROJECT_DIR}/${compiler_id}EnvironmentVariables.wxs"
            @ONLY
            NEWLINE_STYLE WIN32)
    endforeach()

    foreach(compiler_id ${compiler_ids})
        __append_blank_line_on_minpack_builder_main_file_wxs(2)
        __append_comment_on_minpack_builder_main_file_wxs(2 "Reference removable features for compiler ${compiler_id}")
        __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<FeatureRef Id=\"${compiler_id}ChoiceOnReg\" />")
        __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<FeatureRef Id=\"${compiler_id}EnvVars\" />")
        __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<FeatureRef Id=\"${compiler_id}InstalledCompilers\" />")

        configure_file(templates/CompilerInstalledCompilers.wxs.in
            "${WIXTOOLSET_PROJECT_DIR}/InstalledCompilersOn${compiler_id}Selection.wxs"
            @ONLY
            NEWLINE_STYLE WIN32)
    endforeach()

    __append_blank_line_on_minpack_builder_main_file_wxs(2)
    __append_comment_on_minpack_builder_main_file_wxs(2 "Wix variable for the license")
    __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<WixVariable Id=\"WixUILicenseRtf\" Value=\"\$(LicenseRTF)\" />")
    __append_blank_line_on_minpack_builder_main_file_wxs(2)
    __append_comment_on_minpack_builder_main_file_wxs(2 "Reference the dialog")
    __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<UIRef Id=\"MinpackBuilderDialog\" />")
    __append_blank_line_on_minpack_builder_main_file_wxs(2)
    __append_comment_on_minpack_builder_main_file_wxs(2 "Reference the custom action for each compiler")
    foreach(compiler_id ${compiler_ids})
        __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<CustomActionRef Id=\"SaveChoice.${compiler_id}\" />")
    endforeach()
    __append_blank_line_on_minpack_builder_main_file_wxs(2)
    __append_comment_on_minpack_builder_main_file_wxs(2 "Reference the property for the active compiler")
    __append_indented_lines_on_minpack_builder_main_file_wxs(2 "<PropertyRef Id=\"\$(ActiveCompilerChoiceProperty)\" />")
    __append_blank_line_on_minpack_builder_main_file_wxs(2)
    __append_indented_lines_on_minpack_builder_main_file_wxs(1 "</Package>")
    __append_blank_line_on_minpack_builder_main_file_wxs(1)
    __end_minpack_builder_main_file_wxs()
endfunction()
