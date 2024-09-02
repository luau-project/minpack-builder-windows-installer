
function(__harvest_dir_core directory out_file wix_path_var relative_to depth components_id)
    file(GLOB dir_glob ${directory}/*)

    math(EXPR __next_depth "${depth} + 1" OUTPUT_FORMAT DECIMAL)
    get_tabs_indentation(${__next_depth} __dir_indentation)

    math(EXPR __next_next_depth "${__next_depth} + 1" OUTPUT_FORMAT DECIMAL)
    get_tabs_indentation(${__next_next_depth} __component_indentation)

    set(__components_id "")

    foreach(__path ${dir_glob})
        cmake_path(RELATIVE_PATH __path BASE_DIRECTORY ${relative_to} OUTPUT_VARIABLE __part)
        string(REPLACE "/" "\\" __windows_like_path ${__part})
        get_guid(__raw_guid)
        string(REPLACE "-" "" __guid ${__raw_guid})

        if (IS_DIRECTORY ${__path})
            set(__dir_id "directory${__guid}")
            get_filename_component(__dirname ${__path} NAME)

            file_append_line(${out_file} "${__dir_indentation}<Directory Id=\"${__dir_id}\" Name=\"${__dirname}\">")
            __harvest_dir_core(${__path} ${out_file} ${wix_path_var} ${relative_to} ${__next_depth} __components_id_subdir)
            file_append_line(${out_file} "${__dir_indentation}</Directory>")

            list(APPEND __components_id "${__components_id_subdir}")
        else()
            get_guid(__component_raw_guid)
            string(REPLACE "-" "" __component_guid ${__component_raw_guid})

            set(__component_id "component${__component_guid}")

            list(APPEND __components_id ${__component_id})

            set(__file_id "file${__guid}")
            file_append_line(${out_file} "${__dir_indentation}<Component Id=\"${__component_id}\" Guid=\"{${__component_raw_guid}}\">")
            file_append_line(${out_file} "${__component_indentation}<File Id=\"${__file_id}\" KeyPath=\"yes\" Source=\"\$(${wix_path_var})\\${__windows_like_path}\"/>")
            file_append_line(${out_file} "${__dir_indentation}</Component>")
        endif()
    endforeach()

    set(${components_id} "${__components_id}" PARENT_SCOPE)

endfunction()

function(harvest_directory directory out_file wix_includes wix_path_var directory_ref_id component_group)
    set(__given_dir "${directory}")

    if (NOT IS_DIRECTORY ${__given_dir})
        message(FATAL_ERROR "The path is not a directory: ${__given_dir}")
    endif()

    get_filename_component(__given_dir_abspath ${__given_dir} ABSOLUTE)

    set(__target_file "${out_file}")

    if (EXISTS ${__target_file})
        file(REMOVE ${__target_file})
    endif()

    get_tabs_indentation(1 includes_indentation)
    get_tabs_indentation(1 fragments_indentation)
    get_tabs_indentation(2 cg_indentation)
    get_tabs_indentation(2 dir_ref_id_indentation)
    get_tabs_indentation(3 components_indentation)

    file_append_line(${__target_file} "<?xml version=\"1.0\" encoding=\"utf-8\" ?>")
    file_append_line(${__target_file} "<Wix xmlns=\"http://wixtoolset.org/schemas/v4/wxs\">")

    file_append_line(${__target_file} "")
    file_append_line(${__target_file} "${includes_indentation}<!-- Load definitions -->")
    foreach(inc ${wix_includes})
        file_append_line(${__target_file} "${includes_indentation}<?include ${inc} ?>")
    endforeach()
    file_append_line(${__target_file} "")

    file_append_line(${__target_file} "${fragments_indentation}<Fragment>")
    file_append_line(${__target_file} "${dir_ref_id_indentation}<DirectoryRef Id=\"${directory_ref_id}\">")
    __harvest_dir_core("${directory}" ${__target_file} "${wix_path_var}" "${__given_dir_abspath}" "2" components_id)
    file_append_line(${__target_file} "${dir_ref_id_indentation}</DirectoryRef>")
    file_append_line(${__target_file} "${fragments_indentation}</Fragment>")

    file_append_line(${__target_file} "")
    file_append_line(${__target_file} "${fragments_indentation}<Fragment>")
    file_append_line(${__target_file} "${cg_indentation}<ComponentGroup Id=\"${component_group}\">")
    foreach(__id ${components_id})
        file_append_line(${__target_file} "${components_indentation}<ComponentRef Id=\"${__id}\"/>")
    endforeach()
    file_append_line(${__target_file} "${cg_indentation}</ComponentGroup>")
    file_append_line(${__target_file} "${fragments_indentation}</Fragment>")
    file_append_line(${__target_file} "")

    file_append_line(${__target_file} "</Wix>")

endfunction()
