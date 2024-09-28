cmake_minimum_required(VERSION 3.15)

project(BootstrapperJsonConfig
    VERSION 1.0.0
    LANGUAGES C)

option(BUILD_SHARED_LIBS "Build shared library" ON)
option(BUILD_STATIC_LIBS "Build static library" ON)

if (NOT BUILD_SHARED_LIBS AND NOT BUILD_STATIC_LIBS)
    message(FATAL_ERROR "You must build at least a shared or static library.")
endif()

include(GNUInstallDirs)

find_package(json-c CONFIG REQUIRED)

if (TARGET "json-c::json-c")
    set(JSON_TARGET_LIB "json-c::json-c")
elseif (TARGET "json-c::json-c-static")
    set(JSON_TARGET_LIB "json-c::json-c-static")
else()
    message(FATAL_ERROR "Unable to find a proper json-c target")
endif()

set(bootstrapper_json_config_shared "${PROJECT_NAME}")
set(bootstrapper_json_config_static "${PROJECT_NAME}-static")
set(bootstrapper_json_config_public_header "${CMAKE_CURRENT_SOURCE_DIR}/src/bootstrapper-json-config.h")
set(bootstrapper_json_config_sources 
    "${CMAKE_CURRENT_SOURCE_DIR}/src/bootstrapper-json-config.c"
    ${bootstrapper_json_config_public_header})

set(bootstrapper_json_config_targets_to_install "")

if (BUILD_SHARED_LIBS)
    add_library(${bootstrapper_json_config_shared} SHARED "")

    target_sources(${bootstrapper_json_config_shared} PRIVATE ${bootstrapper_json_config_sources})
    target_compile_definitions(${bootstrapper_json_config_shared} PRIVATE "BootstrapperJsonConfig_BUILDING")
    target_link_libraries(${bootstrapper_json_config_shared} PRIVATE ${JSON_TARGET_LIB})
    set_target_properties(${bootstrapper_json_config_shared} PROPERTIES
        PUBLIC_HEADER ${bootstrapper_json_config_public_header})
    
	list(APPEND bootstrapper_json_config_targets_to_install ${bootstrapper_json_config_shared})
endif()

if (BUILD_STATIC_LIBS)
    add_library(${bootstrapper_json_config_static} STATIC "")

    target_sources(${bootstrapper_json_config_static} PRIVATE ${bootstrapper_json_config_sources})
    target_compile_definitions(${bootstrapper_json_config_static} PUBLIC "BootstrapperJsonConfig_STATIC")
    target_link_libraries(${bootstrapper_json_config_static} PRIVATE ${JSON_TARGET_LIB})
    set_target_properties(${bootstrapper_json_config_static} PROPERTIES
        PUBLIC_HEADER ${bootstrapper_json_config_public_header})
    
	list(APPEND bootstrapper_json_config_targets_to_install ${bootstrapper_json_config_static})
endif()

install(TARGETS ${bootstrapper_json_config_targets_to_install}
	EXPORT "${PROJECT_NAME}-targets"
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
)

install(EXPORT "${PROJECT_NAME}-targets"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}-${PROJECT_VERSION}")

configure_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/BootstrapperJsonConfig-config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/BootstrapperJsonConfig-config.cmake" @ONLY)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/BootstrapperJsonConfig-config.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}-${PROJECT_VERSION}")