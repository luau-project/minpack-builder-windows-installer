cmake_minimum_required(VERSION 3.15)

project(BootstrapperJsonConfigResource
    VERSION 1.0.0
    LANGUAGES C)

set(CONFIG_FILE "" CACHE FILEPATH "Bootstrapper json configuration file.")

if (NOT EXISTS "${CONFIG_FILE}")
	message(FATAL_ERROR "Configuration file \"${CONFIG_FILE}\" not found.")
endif()

include(GNUInstallDirs)

set(_app_resource "${CMAKE_CURRENT_BINARY_DIR}/app.rc")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/app.rc.in" ${_app_resource} @ONLY)

set(_bootstrapper_json_config_resource_public_header "${CMAKE_CURRENT_SOURCE_DIR}/src/bootstrapper-json-config-resource.h")
set(_bootstrapper_json_config_resource_sources
    "${CMAKE_CURRENT_SOURCE_DIR}/src/bootstrapper-json-config-resource.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/resource.h"
    ${_bootstrapper_json_config_resource_public_header}
    ${_app_resource})

add_library(BootstrapperJsonConfigResource SHARED "")

target_sources(BootstrapperJsonConfigResource PRIVATE ${_bootstrapper_json_config_resource_sources})
target_include_directories(BootstrapperJsonConfigResource PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/src")
target_compile_definitions(BootstrapperJsonConfigResource PRIVATE "BootstrapperJsonConfigResource_BUILDING")
set_target_properties(BootstrapperJsonConfigResource PROPERTIES
    PUBLIC_HEADER ${_bootstrapper_json_config_resource_public_header}
    PREFIX ""
)

install(TARGETS BootstrapperJsonConfigResource
	EXPORT "${PROJECT_NAME}-targets"
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
)

install(EXPORT "${PROJECT_NAME}-targets"
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}-${PROJECT_VERSION}")

configure_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/BootstrapperJsonConfigResource-config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/BootstrapperJsonConfigResource-config.cmake" @ONLY)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/BootstrapperJsonConfigResource-config.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}-${PROJECT_VERSION}")