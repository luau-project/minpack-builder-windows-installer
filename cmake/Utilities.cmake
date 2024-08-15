find_program(
	UUIDGEN_PROG
	NAME uuidgen
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

function(get_tabs_indentation num out_var)
    string(REPEAT "\t" ${num} __out_var)
    set(${out_var} ${__out_var} PARENT_SCOPE)
endfunction()

function(file_append_line out_file line)
    file(APPEND "${out_file}" "${line}\r\n")
endfunction()