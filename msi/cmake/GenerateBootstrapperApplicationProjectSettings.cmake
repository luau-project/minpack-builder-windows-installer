function(__set_json_object_setting json_content json_field json_value out_value)
    string(JSON _json_field_value
        ERROR_VARIABLE _json_field_value_err
        SET "${json_content}" "${json_field}" "${json_value}")

    if (_json_field_value_err)
        message(FATAL_ERROR "${_json_field_value_err}")
    endif()

    set(${out_value} "${_json_field_value}" PARENT_SCOPE)
endfunction()

function(__escape_backslash_string_for_json json_string out_json_string)
    string(REPLACE "\\" "\\\\" _escaped "${json_string}")
    set(${out_json_string} "${_escaped}" PARENT_SCOPE)
endfunction()

function(get_ba_compiler_setting_json
    compiler_id
    compiler_name
    compiler_version
    compiler_hostArch
    compiler_index
    compiler_displayText
    compiler_featuresToRemove
    out_value)

    set(__json_content "{}")

    __set_json_object_setting(${__json_content}
        "Id" "\"${compiler_id}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "Name" "\"${compiler_name}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "Version" "\"${compiler_version}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "HostArch" "\"${compiler_hostArch}\""
        __json_content)
        
    __set_json_object_setting(${__json_content}
        "Index" "${compiler_index}"
        __json_content)

    __set_json_object_setting(${__json_content}
        "DisplayText" "\"${compiler_displayText}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "FeaturesToRemove" "\"${compiler_featuresToRemove}\""
        __json_content)

    set(${out_value} "${__json_content}" PARENT_SCOPE)
endfunction()

function(write_ba_project_settings
    msi_upgrade_code
    msi_manufacturer
    msi_product_name
    msi_language
    msi_culture
    msi_version
    msi_package_name
    msi_registry_root
    msi_registry_key
    msi_active_compiler_id_registry_key
    msi_active_compiler_choice_property
    msi_compilers_config_json)
    
    __escape_backslash_string_for_json("${msi_registry_key}" escaped_backslash_msi_registry_key)
    __escape_backslash_string_for_json("${msi_active_compiler_id_registry_key}" escaped_backslash_msi_active_compiler_id_registry_key)

    set(__json_content "{}")

    __set_json_object_setting(${__json_content}
        "MsiUpgradeCode" "\"${msi_upgrade_code}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "MsiManufacturer" "\"${msi_manufacturer}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "MsiProductName" "\"${msi_product_name}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "MsiLanguage" "\"${msi_language}\""
        __json_content)
        
    __set_json_object_setting(${__json_content}
        "MsiCulture" "\"${msi_culture}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "MsiVersion" "\"${msi_version}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "MsiPackageName" "\"${msi_package_name}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "MsiRegistryRoot" "\"${msi_registry_root}\""
        __json_content)
        
    __set_json_object_setting(${__json_content}
        "MsiRegistryKey" "\"${escaped_backslash_msi_registry_key}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "MsiActiveCompilerIdRegistryKey" "\"${escaped_backslash_msi_active_compiler_id_registry_key}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "MsiActiveCompilerChoiceProperty" "\"${msi_active_compiler_choice_property}\""
        __json_content)

    __set_json_object_setting(${__json_content}
        "MsiCompilers" "${msi_compilers_config_json}"
        __json_content)
        
    file(WRITE "${WIXTOOLSET_MSI_PROJECT_DIR}/${WIXTOOLSET_BA_PROJECT_SETTINGS_FILE_NAME}" "${__json_content}")

endfunction()
