function(__get_compiler_setting json_content element_index json_field json_filed_expected_type out_value)
    string(JSON _json_field_var
        ERROR_VARIABLE _json_field_var_err
        TYPE "${json_content}" "${element_index}" "${json_field}")

    if (_json_field_var_err)
        message(FATAL_ERROR "${_json_field_var_err}")
    endif()

    if (NOT "${_json_field_var}" STREQUAL "${json_filed_expected_type}")
        message(FATAL_ERROR "${json_filed_expected_type} expected, but got ${_json_field_var}")
    endif()

    string(JSON _json_field_value
        ERROR_VARIABLE _json_field_value_err
        GET "${json_content}" "${element_index}" "${json_field}")

    if (_json_field_value_err)
        message(FATAL_ERROR "${_json_field_value_err}")
    endif()

    set(${out_value} "${_json_field_value}" PARENT_SCOPE)
endfunction()

function(__write_compiler_config_wxi compiler_id compiler_name compiler_version compiler_hostarch)
    
    set(__guids_for_compiler_properties
        "EnvironmentVariable"
        "EnvironmentVariableOnPath"
        "CMakePrefixPath"
        "Registry"
        "VersionRegistry"
        "HostArchRegistry"
        "RegistryInstallDir")
    
    append_blank_line_on_project_config_wxi()
    append_comment_on_project_config_wxi("start of ${compiler_id} settings")
    append_define_on_project_config_wxi("${compiler_id}CompilerName" "${compiler_name}")
    append_define_on_project_config_wxi("${compiler_id}Version" "${compiler_version}")
    append_define_on_project_config_wxi("${compiler_id}HostArch" "${compiler_hostarch}")
    foreach(__guid_for_prop ${__guids_for_compiler_properties})
        append_define_guid_on_project_config_wxi("${compiler_id}${__guid_for_prop}Guid")
    endforeach()

    string(TOUPPER "${compiler_id}" compiler_id_upper)
    append_define_on_project_config_wxi("${compiler_id}ChoiceProperty" "${compiler_id_upper}")
    append_define_on_project_config_wxi("${compiler_id}ChoicePropertyDefaultValue" "${compiler_id}")
    append_define_on_project_config_wxi("${compiler_id}ChoicePropertyRegistryRoot" "HKLM")
    append_define_on_project_config_wxi("${compiler_id}ChoicePropertyRegistryKey" [[Software\$(Manufacturer)\$(PackageName)]])
    append_define_on_project_config_wxi("${compiler_id}ChoicePropertyRegistryName" "ActiveCompiler")
    append_define_guid_on_project_config_wxi("${compiler_id}ChoicePropertyRegistryGuid")

    append_comment_on_project_config_wxi("end of ${compiler_id} settings")
    
endfunction()

function(parse_compiler_settings_from_json json_file compiler_ids)
    file(READ "${json_file}" json_file_content)

    string(JSON _json_field_var
        ERROR_VARIABLE _json_field_var_err
        TYPE "${json_file_content}")
    
    if (_json_field_var_err)
        message(FATAL_ERROR "${_json_field_var_err}")
    endif()
    
    if (NOT "${_json_field_var}" STREQUAL "ARRAY")
        message(FATAL_ERROR "ARRAY expected, but got ${_json_field_var}")
    endif()

    string(JSON _data_length
        ERROR_VARIABLE _data_length_err
        LENGTH "${json_file_content}")
    
    if (_data_length_err)
        message(FATAL_ERROR "${_data_length_err}")
    endif()

    set(_compiler_ids "")
    
    set(_index "0")
    while("${_index}" LESS "${_data_length}")
        string(JSON _json_array_el_type
            ERROR_VARIABLE _json_array_el_type_err
            TYPE "${json_file_content}" "${_index}")
        
        if (_json_array_el_type_err)
            message(FATAL_ERROR "${_json_array_el_type_err}")
        endif()

        if (NOT "${_json_array_el_type}" STREQUAL "OBJECT")
            message(FATAL_ERROR "OBJECT expected, but got ${_json_array_el_type}")
        endif()

        __get_compiler_setting("${json_file_content}" "${_index}" "CompilerId" "STRING" compiler_id)
        __get_compiler_setting("${json_file_content}" "${_index}" "CompilerName" "STRING" compiler_name)
        __get_compiler_setting("${json_file_content}" "${_index}" "Version" "STRING" compiler_version)
        __get_compiler_setting("${json_file_content}" "${_index}" "HostArch" "STRING" compiler_hostarch)

        __write_compiler_config_wxi("${compiler_id}" "${compiler_name}" "${compiler_version}" "${compiler_hostarch}")

        configure_file(
            templates/CompilerChoiceProperty.wxs.in
            "${CMAKE_BINARY_DIR}/wixtoolset-v5/${compiler_id}ChoiceProperty.wxs"
            @ONLY
            NEWLINE_STYLE WIN32)

        if ("${_index}" STREQUAL "0")
            configure_file(
                templates/DefaultCompilerChoiceProperty.wxs.in
                "${CMAKE_BINARY_DIR}/wixtoolset-v5/DefaultCompilerChoiceProperty.wxs"
                @ONLY
                NEWLINE_STYLE WIN32)
        endif()

        list(APPEND _compiler_ids "${compiler_id}")

        MATH(EXPR _index "${_index} + 1")
    endwhile()

    append_blank_line_on_project_config_wxi()
    append_comment_on_project_config_wxi("start of extra settings")
    append_define_on_project_config_wxi("CompilerChoices" "${_compiler_ids}")
    append_comment_on_project_config_wxi("end of extra settings")

    set(${compiler_ids} "${_compiler_ids}" PARENT_SCOPE)
endfunction()