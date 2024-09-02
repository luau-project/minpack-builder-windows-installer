function(begin_project_config_wxi)
    set(__target_dir "${WIXTOOLSET_MSI_PROJECT_DIR}")

    if (IS_DIRECTORY ${__target_dir})
        file(REMOVE_RECURSE ${__target_dir})
    endif()

    file(MAKE_DIRECTORY ${__target_dir})

    set(__target_file "${__target_dir}/${WIXTOOLSET_MSI_PROJECT_INCLUDE_FILE_NAME}")

    if (EXISTS ${__target_file})
        file(REMOVE ${__target_file})
    endif()

    file_append_line(${__target_file} "<?xml version=\"1.0\" encoding=\"utf-8\" ?>")
    file_append_line(${__target_file} "<Include>")
endfunction()

function(append_lines_on_project_config_wxi lines)
    set(__target_dir "${WIXTOOLSET_MSI_PROJECT_DIR}")
    set(__target_file "${__target_dir}/${WIXTOOLSET_MSI_PROJECT_INCLUDE_FILE_NAME}")

    if (NOT EXISTS ${__target_file})
        message(FATAL_ERROR "File \"${__target_file}\" not found")
    endif()

    foreach(line_content "${lines}")
        file_append_line(${__target_file} "${line_content}")
    endforeach()
endfunction()

function(append_define_on_project_config_wxi define_name define_value)
    get_tabs_indentation(1 content_indentation)
    append_lines_on_project_config_wxi("${content_indentation}<?define ${define_name}=\"${define_value}\" ?>")
endfunction()

function(append_define_guid_on_project_config_wxi define_name)
    get_guid(__prop_raw_guid)
    append_define_on_project_config_wxi("${define_name}" "{${__prop_raw_guid}}")
endfunction()

function(append_blank_line_on_project_config_wxi)
    get_tabs_indentation(1 content_indentation)
    append_lines_on_project_config_wxi("${content_indentation}")
endfunction()

function(append_comment_on_project_config_wxi comment_value)
    get_tabs_indentation(1 content_indentation)
    append_lines_on_project_config_wxi("${content_indentation}<!-- ${comment_value} -->")
endfunction()

function(end_project_config_wxi)
    append_lines_on_project_config_wxi("</Include>")
endfunction()
