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

function(__write_compiler_config_wxi compiler_id compiler_index compiler_name compiler_version compiler_hostarch compiler_displayText)
    
    set(__guids_for_compiler_properties
        "EnvironmentVariable"
        "EnvironmentVariableOnPath"
        "CMakePrefixPath"
        "UpgradeCodeRegistry"
        "ListOfInstalledCompilersRegistry"
        "NumberOfInstalledCompilersRegistry"
        "MinpackBuilderSourceCodeDirRegistry"
        "MinpackSourceCodeDirRegistry"
        "MinpackBuilderInstallDirRegistry"
        "MinpackBuilderVersionRegistry"
        "MinpackBuilderMsiVersionRegistry"
        "IndexRegistry"
        "NameRegistry"
        "VersionRegistry"
        "HostArchRegistry"
        "DisplayTextRegistry"
        "FeaturesToRemoveRegistry"
        "InstallDirRegistry")
    
    append_blank_line_on_project_config_wxi()
    append_comment_on_project_config_wxi("start of ${compiler_id} settings")
    append_define_on_project_config_wxi("${compiler_id}CompilerName" "${compiler_name}")
    append_define_on_project_config_wxi("${compiler_id}Index" "${compiler_index}")
    append_define_on_project_config_wxi("${compiler_id}Version" "${compiler_version}")
    append_define_on_project_config_wxi("${compiler_id}HostArch" "${compiler_hostarch}")
    append_define_on_project_config_wxi("${compiler_id}DisplayText" "${compiler_displayText}")

    if (NOT DEFINED "${compiler_id}_BINARIES_DIR")
        message(FATAL_ERROR "Parameter \"${compiler_id}_BINARIES_DIR\" not defined. You must supply a directory for the binaries of ${compiler_id} as a cmake parameter: \"-D${compiler_id}_BINARIES_DIR=path/to/binaries\"")
    endif()

    get_filename_component(__compiler_binaries_dir_name "${${compiler_id}_BINARIES_DIR}" NAME)
    append_define_on_project_config_wxi("${compiler_id}BinariesDir" "binaries\\${compiler_id}\\${__compiler_binaries_dir_name}")

    foreach(__guid_for_prop ${__guids_for_compiler_properties})
        append_define_guid_on_project_config_wxi("${compiler_id}${__guid_for_prop}Guid")
    endforeach()

    string(TOUPPER "${compiler_id}" compiler_id_upper)
    append_define_on_project_config_wxi("${compiler_id}ChoiceProperty" "${compiler_id_upper}")
    append_define_on_project_config_wxi("${compiler_id}ChoicePropertyDefaultValue" "${compiler_id}")
    append_define_guid_on_project_config_wxi("${compiler_id}ChoicePropertyRegistryGuid")

    append_comment_on_project_config_wxi("end of ${compiler_id} settings")
    
endfunction()

function(__write_installed_compiler_config_wxi compiler_ids out_compiler_featuresToRemove)
    
    set(__guids_for_compiler_properties
        "IdRegistry"
        "IndexRegistry"
        "NameRegistry"
        "VersionRegistry"
        "HostArchRegistry"
        "DisplayTextRegistry"
        "FeaturesToRemoveRegistry"
        "InstallDirRegistry")
    
    list(LENGTH compiler_ids number_of_compilers)

    set(_compiler_features_to_remove "")

    foreach(compiler_id ${compiler_ids})

        set(features_from_other_compilers_to_be_removed "")

        set(c_index_other "0")
        while("${c_index_other}" LESS "${number_of_compilers}")

            list(GET compiler_ids "${c_index_other}" c_id_other)

            if ("${compiler_id}" STREQUAL "${c_id_other}")
                # do nothing
            else()
                list(APPEND features_from_other_compilers_to_be_removed "${c_id_other}Feature")
            endif()

            foreach(__guid_for_prop ${__guids_for_compiler_properties})
                append_define_guid_on_project_config_wxi("${c_id_other}${__guid_for_prop}On${compiler_id}Guid")
            endforeach()

            configure_file(
                templates/ListOfInstalledCompilersOnWindowsRegistry.wxs.in
                "${WIXTOOLSET_MSI_PROJECT_DIR}/${c_id_other}InstalledCompilerOn${compiler_id}Selection.wxs"
                @ONLY
                NEWLINE_STYLE WIN32)

            MATH(EXPR c_index_other "${c_index_other} + 1")
        endwhile()

        list(JOIN features_from_other_compilers_to_be_removed "," current_compiler_features_to_remove)

        append_define_on_project_config_wxi("${compiler_id}FeaturesToRemove" "${current_compiler_features_to_remove}")

        list(APPEND _compiler_features_to_remove "${current_compiler_features_to_remove}")

    endforeach()

    set(${out_compiler_featuresToRemove} "${_compiler_features_to_remove}" PARENT_SCOPE)

endfunction()

function(parse_compiler_settings_from_json json_file compiler_ids out_ba_compilers_json)
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

    set(list_of_compiler_id "")
    set(list_of_compiler_name "")
    set(list_of_compiler_version "")
    set(list_of_compiler_hostArch "")
    set(list_of_compiler_index "")
    set(list_of_compiler_displayText "")

    set(_compiler_ids_upper "")
    set(_compiler_combined_props_upper "")

    set(_out_ba_compilers_json "[]")
    
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

        if (NOT ("${compiler_id}" MATCHES "^[a-zA-Z]+\$"))
            message(FATAL_ERROR "Invalid compiler id on entry ${_index}. Only alphabetic characters a-z or A-Z are allowed.")
        endif()

        string(TOUPPER "${compiler_id}" compiler_id_upper)
        if ("${compiler_id_upper}" IN_LIST _compiler_ids_upper)
            message(FATAL_ERROR "Compiler id is case-insensitive. An entry for \"${compiler_id}\" is already defined. Please, choose a different compiler id for the compiler at index ${_index} on file \"${json_file}\".")
        else()
            list(APPEND list_of_compiler_id "${compiler_id}")
            list(APPEND _compiler_ids_upper "${compiler_id_upper}")
        endif()
        
        __get_compiler_setting("${json_file_content}" "${_index}" "CompilerName" "STRING" compiler_name)
        __get_compiler_setting("${json_file_content}" "${_index}" "Version" "STRING" compiler_version)
        __get_compiler_setting("${json_file_content}" "${_index}" "HostArch" "STRING" compiler_hostarch)
        
        string(TOUPPER "${compiler_name}-${compiler_version}-${compiler_hostarch}" combined_prop_upper)
        if ("${combined_prop_upper}" IN_LIST _compiler_combined_props_upper)
            message(FATAL_ERROR "An case-insensitive entry containing the same name (\"${compiler_name}\"), version (${compiler_version}) and host arch (${compiler_hostarch}) is already defined. Please, choose different compiler settings at index ${_index} on file \"${json_file}\".")
        else()
            list(APPEND _compiler_combined_props_upper "${combined_prop_upper}")
        endif()

        set(_compiler_displayText_for_wxi "\$(${compiler_id}CompilerName) \$(${compiler_id}Version) \$(${compiler_id}HostArch)")
        set(_compiler_displayText_for_ba "${compiler_name} ${compiler_version} ${compiler_hostarch}")

        __write_compiler_config_wxi("${compiler_id}" "${_index}" "${compiler_name}" "${compiler_version}" "${compiler_hostarch}" "${_compiler_displayText_for_wxi}")

        configure_file(
            templates/CompilerChoiceProperty.wxs.in
            "${WIXTOOLSET_MSI_PROJECT_DIR}/${compiler_id}ChoiceProperty.wxs"
            @ONLY
            NEWLINE_STYLE WIN32)

        if ("${_index}" STREQUAL "0")
            configure_file(
                templates/ActiveCompilerChoiceProperty.wxs.in
                "${WIXTOOLSET_MSI_PROJECT_DIR}/ActiveCompilerChoiceProperty.wxs"
                @ONLY
                NEWLINE_STYLE WIN32)
        endif()

        list(APPEND list_of_compiler_name "${compiler_name}")
        list(APPEND list_of_compiler_version "${compiler_version}")
        list(APPEND list_of_compiler_hostArch "${compiler_hostarch}")
        list(APPEND list_of_compiler_index "${_index}")
        list(APPEND list_of_compiler_displayText "${_compiler_displayText_for_ba}")

        MATH(EXPR _index "${_index} + 1")
    endwhile()

    append_blank_line_on_project_config_wxi()
    append_comment_on_project_config_wxi("start of extra settings")
    append_define_on_project_config_wxi("ListOfInstalledCompilers" "${list_of_compiler_id}")
    append_define_on_project_config_wxi("NumberOfInstalledCompilers" "${_data_length}")
    __write_installed_compiler_config_wxi("${list_of_compiler_id}" list_of_compiler_featuresToRemove)
    append_comment_on_project_config_wxi("end of extra settings")

    foreach(key_value IN ZIP_LISTS list_of_compiler_id list_of_compiler_name list_of_compiler_version list_of_compiler_hostArch list_of_compiler_index list_of_compiler_displayText list_of_compiler_featuresToRemove)
        set(_compiler_id ${key_value_0})
        set(_compiler_name ${key_value_1})
        set(_compiler_version ${key_value_2})
        set(_compiler_hostArch ${key_value_3})
        set(_compiler_index ${key_value_4})
        set(_compiler_displayText ${key_value_5})
        set(_compiler_featuresToRemove ${key_value_6})
        
        get_ba_compiler_setting_json(
            "${_compiler_id}"
            "${_compiler_name}"
            "${_compiler_version}"
            "${_compiler_hostArch}"
            "${_compiler_index}"
            "${_compiler_displayText}"
            "${_compiler_featuresToRemove}"
            _out_compiler_json)

        string(JSON _out_ba_compilers_json
            ERROR_VARIABLE _json_field_value_err
            SET "${_out_ba_compilers_json}" "${_compiler_index}" "${_out_compiler_json}")
    
        if (_json_field_value_err)
            message(FATAL_ERROR "${_json_field_value_err}")
        endif()    
    endforeach()
    
    set(${compiler_ids} "${list_of_compiler_id}" PARENT_SCOPE)
    set(${out_ba_compilers_json} "${_out_ba_compilers_json}" PARENT_SCOPE)
endfunction()