function(write_minpack_builder_license_rtf)
    set(__target_dir "${CMAKE_BINARY_DIR}")

    file(MAKE_DIRECTORY ${__target_dir})

    set(__target_file "${__target_dir}/temp-rtf-LICENSE.md")

    if (EXISTS ${__target_file})
        file(REMOVE ${__target_file})
    endif()

    file_append_line(${__target_file} "## Table of Contents")
    file_append_line(${__target_file} "* Minpack License")
    file_append_line(${__target_file} "* Minpack Builder License")
    file_append_line(${__target_file} "")
    file_append_line(${__target_file} "## Minpack License")
    file_append_line(${__target_file} "")
    file(READ "${MINPACK_SOURCES}/disclaimer" __disclaimer)
    file_append_line(${__target_file} "${__disclaimer}")
    file_append_line(${__target_file} "")
    file_append_line(${__target_file} "## Minpack Builder License")
    file_append_line(${__target_file} "")
    file(READ "${MINPACK_BUILDER_SOURCES}/LICENSE.md" __license_md)
    string(REPLACE
        "${WIXTOOLSET_PROJECT_MINPACK_BUILDER_REPOSITORY_URL}"
        "[${WIXTOOLSET_PROJECT_MINPACK_BUILDER_REPOSITORY_URL}](${WIXTOOLSET_PROJECT_MINPACK_BUILDER_REPOSITORY_URL})"
        __license_md
        "${__license_md}")
    file_append_line(${__target_file} "${__license_md}")

    convert_to_rtf("${__target_file}" "${WIXTOOLSET_PROJECT_DIR}/${WIXTOOLSET_PROJECT_MINPACK_BUILDER_LICENSE_RTF_FILE_NAME}" "End-User License Agreement")

    file(REMOVE ${__target_file})
endfunction()

function(write_minpack_builder_license_pdf)
    set(__target_dir "${CMAKE_BINARY_DIR}")

    file(MAKE_DIRECTORY ${__target_dir})

    set(__target_file "${__target_dir}/temp-pdf-LICENSE.md")

    if (EXISTS ${__target_file})
        file(REMOVE ${__target_file})
    endif()

    file_append_line(${__target_file} "## Table of Contents")
    file_append_line(${__target_file} "* [Minpack License](#minpack-license)")
    file_append_line(${__target_file} "* [Minpack Builder License](#minpack-builder-license)")
    file_append_line(${__target_file} "")
    file_append_line(${__target_file} "## Minpack License")
    file_append_line(${__target_file} "")
    file(READ "${MINPACK_SOURCES}/disclaimer" __disclaimer)
    file_append_line(${__target_file} "${__disclaimer}")
    file_append_line(${__target_file} "")
    file_append_line(${__target_file} "## Minpack Builder License")
    file_append_line(${__target_file} "")
    file(READ "${MINPACK_BUILDER_SOURCES}/LICENSE.md" __license_md)
    string(REPLACE
        "${WIXTOOLSET_PROJECT_MINPACK_BUILDER_REPOSITORY_URL}"
        "[${WIXTOOLSET_PROJECT_MINPACK_BUILDER_REPOSITORY_URL}](${WIXTOOLSET_PROJECT_MINPACK_BUILDER_REPOSITORY_URL})"
        __license_md
        "${__license_md}")
    file_append_line(${__target_file} "${__license_md}")

    convert_to_pdf("${__target_file}" "${WIXTOOLSET_PROJECT_DIR}/${WIXTOOLSET_PROJECT_MINPACK_BUILDER_LICENSE_PDF_FILE_NAME}" "End-User License Agreement")
    
    file(REMOVE ${__target_file})
endfunction()