function(write_archives)
    file(MAKE_DIRECTORY "${WIXTOOLSET_MSI_PROJECT_ARCHIVES_DIR}")

    set(__installer_version_filename "${WIXTOOLSET_MSI_PROJECT_ARCHIVES_DIR}/${WIXTOOLSET_MSI_PROJECT_VERSION_FILE_NAME}")
    file(WRITE ${__installer_version_filename} "${PROJECT_VERSION}")

    set(__archive_filepath_base "${WIXTOOLSET_MSI_PROJECT_ARCHIVES_DIR}/${WIXTOOLSET_MSI_NAME_WE}")
    set(__zip_archive_filename "${__archive_filepath_base}.zip")
    set(__targz_archive_filename "${__archive_filepath_base}.tar.gz")

    # .zip archive
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar c "${__zip_archive_filename}" --format=zip -- "${WIXTOOLSET_MSI_PROJECT_DIR}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
        RESULT_VARIABLE zip_archive_res
    )

    # .tar.gz archive
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar cz "${__targz_archive_filename}" --format=gnutar -- "${WIXTOOLSET_MSI_PROJECT_DIR}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
        RESULT_VARIABLE targz_archive_res
    )

    set(__hashable_archives "${__zip_archive_filename}" "${__targz_archive_filename}" "${__installer_version_filename}")
    set(__hashes "SHA256" "MD5")

    foreach(__file_archive ${__hashable_archives})
        foreach (__hash ${__hashes})
            file(${__hash} ${__file_archive} __hash_value)
            file(WRITE "${__file_archive}-${__hash}.txt" "${__hash_value}")
        endforeach()
    endforeach()
endfunction()
