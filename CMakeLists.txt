cmake_minimum_required(VERSION 3.20)

project(MinpackBuilderInstaller)

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

include(cmake/HarvestDirectory.cmake)
