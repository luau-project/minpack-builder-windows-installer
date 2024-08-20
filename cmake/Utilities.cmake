find_program(
	UUIDGEN_PROG
	NAME uuidgen
	REQUIRED
)

find_program(
	PANDOC_PROG
	NAME pandoc
	REQUIRED
)

find_program(
	WEASYPRINT_PROG
	NAME weasyprint
	REQUIRED
)

function(get_guid guid_var)
	execute_process(
		COMMAND ${UUIDGEN_PROG}
		OUTPUT_VARIABLE __guid
	)
	string(STRIP "${__guid}" __guid)
	string(TOUPPER "${__guid}" __guid)
	set(${guid_var} "${__guid}" PARENT_SCOPE)
endfunction()

function(convert_to_rtf in_file out_file title)
	execute_process(
		COMMAND ${PANDOC_PROG} "-s" "${in_file}" "-o" "${out_file}" "--metadata" "title=${title}"
		OUTPUT_VARIABLE __rtf_output
	)
endfunction()

function(convert_to_pdf in_file out_file title)
	execute_process(
		COMMAND ${PANDOC_PROG} "-s" "${in_file}" "-o" "${out_file}" "--pdf-engine=weasyprint" "--metadata" "title=${title}"
		OUTPUT_VARIABLE __pdf_output
	)
endfunction()

function(get_tabs_indentation num out_var)
	MATH(EXPR __repetition "${num} * 4")
    string(REPEAT " " ${__repetition} __out_var)
    set(${out_var} ${__out_var} PARENT_SCOPE)
endfunction()

function(file_append_line out_file line)
    file(APPEND "${out_file}" "${line}\r\n")
endfunction()

function(get_LCID_from_culture culture out_var)
	if ("${culture}" STREQUAL "en-us")
		set(${out_var} "1033" PARENT_SCOPE)
	elseif ("${culture}" STREQUAL "pt-br")
		set(${out_var} "1046" PARENT_SCOPE)
	else()
		message(FATAL_ERROR "Unsupported culture.")
	endif()
endfunction()
