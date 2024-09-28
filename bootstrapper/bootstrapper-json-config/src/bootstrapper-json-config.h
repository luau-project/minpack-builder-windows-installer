#ifndef BOOTSTRAPPER_JSON_CONFIG_H
#define BOOTSTRAPPER_JSON_CONFIG_H

#ifdef __cplusplus
extern "C" {
#endif

#include <windows.h>

#ifndef BootstrapperJsonConfig_API
    #ifdef BootstrapperJsonConfig_STATIC
        #define BootstrapperJsonConfig_API
    #else
        #ifdef BootstrapperJsonConfig_BUILDING
            #if defined(__GNUC__) || defined(__CYGWIN__) || defined(__MINGW32__)
                #define BootstrapperJsonConfig_API __attribute__((dllexport))
            #elif defined(_MSC_VER)
                #define BootstrapperJsonConfig_API __declspec(dllexport)
            #else
                #define BootstrapperJsonConfig_API __attribute__ ((visibility ("default")))
            #endif
        #else
            #if defined(__GNUC__) || defined(__CYGWIN__) || defined(__MINGW32__)
                #define BootstrapperJsonConfig_API __attribute__((dllimport))
            #elif defined(_MSC_VER)
                #define BootstrapperJsonConfig_API __declspec(dllimport)
            #else
                #define BootstrapperJsonConfig_API __attribute__ ((visibility ("default")))
            #endif
        #endif
    #endif
#endif

typedef void *MsiConfig;

BootstrapperJsonConfig_API
MsiConfig bjc_new_msi_config(
    HMODULE hModule,
    LPCWSTR lpName,
    LPCWSTR lpType
);

BootstrapperJsonConfig_API
BOOL bjc_free_msi_config(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_product_name(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_package_name(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_manufacturer(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_culture(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_language(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_registry_key(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_registry_root(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_upgrade_code(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_upgrade_code_registry_key(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_version(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_version_registry_key(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_activate_compiler_choice_property(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_activate_compiler_id_registry_key(MsiConfig config);

/* start of compiler-related */

BootstrapperJsonConfig_API
int bjc_get_number_of_compilers(MsiConfig config);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_id(MsiConfig config, int i);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_name(MsiConfig config, int i);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_version(MsiConfig config, int i);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_host_arch(MsiConfig config, int i);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_display_text(MsiConfig config, int i);

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_features_to_remove(MsiConfig config, int i);

BootstrapperJsonConfig_API
int bjc_get_compiler_index(MsiConfig config, int i);

/* end of compiler-related */

#ifdef __cplusplus
}
#endif

#endif