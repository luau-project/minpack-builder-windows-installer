function(write_msi_bat)
    set(__wix_build_cmd
    "wix" "build" "-nologo" "-arch" "x64" "-ext" "WixToolset.UI.wixext")

    file(GLOB __wix_source_files
    RELATIVE "${WIXTOOLSET_MSI_PROJECT_DIR}"
    "${WIXTOOLSET_MSI_PROJECT_DIR}/*.wxs")

    file(GLOB __wix_localization_files
    RELATIVE "${WIXTOOLSET_MSI_PROJECT_DIR}"
    "${WIXTOOLSET_MSI_PROJECT_DIR}/*.wxl")

    foreach(wix_wxs "${__wix_source_files}")
    list(APPEND __wix_build_cmd ${wix_wxs})
    endforeach()

    foreach(wix_wxl "${__wix_localization_files}")
    list(APPEND __wix_build_cmd ${wix_wxl})
    endforeach()

    list(APPEND __wix_build_cmd "-out")
    list(APPEND __wix_build_cmd "${WIXTOOLSET_MSI_NAME}")

    list(JOIN __wix_build_cmd " " __wix_build_cmd)

    file(WRITE "${WIXTOOLSET_MSI_PROJECT_DIR}/${WIXTOOLSET_MSI_PROJECT_BAT_FILE_NAME}" "${__wix_build_cmd}")
endfunction()
