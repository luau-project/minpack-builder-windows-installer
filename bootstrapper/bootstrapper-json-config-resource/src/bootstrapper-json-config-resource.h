#ifndef BOOTSTRAPPER_JSON_CONFIG_RESOURCE_H
#define BOOTSTRAPPER_JSON_CONFIG_RESOURCE_H

#ifdef __cplusplus
extern "C" {
#endif

#include <windows.h>

#ifndef BootstrapperJsonConfigResource_API
    #ifdef BootstrapperJsonConfigResource_STATIC
        #define BootstrapperJsonConfigResource_API
    #else
        #ifdef BootstrapperJsonConfigResource_BUILDING
            #if defined(__GNUC__) || defined(__CYGWIN__) || defined(__MINGW32__)
                #define BootstrapperJsonConfigResource_API __attribute__((dllexport))
            #elif defined(_MSC_VER)
                #define BootstrapperJsonConfigResource_API __declspec(dllexport)
            #else
                #define BootstrapperJsonConfigResource_API __attribute__ ((visibility ("default")))
            #endif
        #else
            #if defined(__GNUC__) || defined(__CYGWIN__) || defined(__MINGW32__)
                #define BootstrapperJsonConfigResource_API __attribute__((dllimport))
            #elif defined(_MSC_VER)
                #define BootstrapperJsonConfigResource_API __declspec(dllimport)
            #else
                #define BootstrapperJsonConfigResource_API __attribute__ ((visibility ("default")))
            #endif
        #endif
    #endif
#endif

BootstrapperJsonConfigResource_API
int bjcr_get_name_id();

BootstrapperJsonConfigResource_API
int bjcr_get_type_id();

#ifdef __cplusplus
}
#endif

#endif