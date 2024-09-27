#include "bootstrapper-json-config.h"

#include <stdlib.h>
#include <json-c/json.h>

typedef struct MsiCompiler__
{
    LPCWSTR id;
    LPCWSTR name;
    LPCWSTR version;
    LPCWSTR hostArch;
    LPCWSTR displayText;
    LPCWSTR featuresToRemove;
    int index;

} MsiCompiler;

typedef struct MsiCompilers__
{
    int count;
    MsiCompiler *data;

} MsiCompilers;

typedef struct MsiConfig__
{
    LPCWSTR productName;
    LPCWSTR packageName;
    LPCWSTR manufacturer;
    LPCWSTR culture;
    LPCWSTR language;
    LPCWSTR registryKey;
    LPCWSTR registryRoot;
    LPCWSTR upgradeCode;
    LPCWSTR upgradeCodeRegistryKey;
    LPCWSTR version;
    LPCWSTR versionRegistryKey;
    LPCWSTR activeCompilerChoiceProperty;
    LPCWSTR activeCompilerIdRegistryKey;
    MsiCompilers compilers;

} MsiConfig__;

static char *bjc_compiler_fields[] = {
     "Id",
     "Name",
     "Version",
     "HostArch",
     "DisplayText",
     "FeaturesToRemove",
     "Index",
     NULL
};

static char *bjc_config_fields[] = {
     "MsiActiveCompilerChoiceProperty",
     "MsiActiveCompilerIdRegistryKey",
     "MsiCulture",
     "MsiLanguage",
     "MsiManufacturer",
     "MsiPackageName",
     "MsiProductName",
     "MsiRegistryKey",
     "MsiRegistryRoot",
     "MsiUpgradeCode",
     "MsiUpgradeCodeRegistryKey",
     "MsiVersion",
     "MsiVersionRegistryKey",
     "MsiCompilers",
     NULL
};

#ifndef BJC_Free_WCHAR_property
#define BJC_Free_WCHAR_property(p) if (p != NULL) {free((void *)(p)); p = NULL;}
#endif

static BOOL bjc_convert_utf8_to_unicode(LPCSTR utf8Str, int count, LPWSTR *unicodeStr)
{
    if (utf8Str == NULL || count < 0 || unicodeStr == NULL)
    {
        return FALSE;
    }

    int capacity = count + 1;
    WCHAR *buffer = (WCHAR *)(malloc(capacity * sizeof(WCHAR)));
    if (buffer == NULL)
    {
        return FALSE;
    }

    int requiredSize = MultiByteToWideChar(CP_UTF8, MB_PRECOMPOSED, utf8Str, capacity, buffer, capacity);
    if (requiredSize == 0)
    {
        free((void *)buffer);
        return FALSE;
    }

    *unicodeStr = buffer;

    return TRUE;
}

static void bjc_free_msi_compiler(MsiCompiler *compiler)
{
    if (compiler != NULL)
    {
        BJC_Free_WCHAR_property(compiler->id)
        BJC_Free_WCHAR_property(compiler->name)
        BJC_Free_WCHAR_property(compiler->hostArch)
        BJC_Free_WCHAR_property(compiler->version)
        BJC_Free_WCHAR_property(compiler->displayText)
        BJC_Free_WCHAR_property(compiler->featuresToRemove)
    }
}

static void bjc_free_msi_config_content(MsiConfig__ *config)
{
    if (config != NULL)
    {
        BJC_Free_WCHAR_property(config->productName)
        BJC_Free_WCHAR_property(config->packageName)
        BJC_Free_WCHAR_property(config->manufacturer)
        BJC_Free_WCHAR_property(config->culture)
        BJC_Free_WCHAR_property(config->language)
        BJC_Free_WCHAR_property(config->registryKey)
        BJC_Free_WCHAR_property(config->registryRoot)
        BJC_Free_WCHAR_property(config->upgradeCode)
        BJC_Free_WCHAR_property(config->upgradeCodeRegistryKey)
        BJC_Free_WCHAR_property(config->version)
        BJC_Free_WCHAR_property(config->versionRegistryKey)
        BJC_Free_WCHAR_property(config->activeCompilerChoiceProperty)
        BJC_Free_WCHAR_property(config->activeCompilerIdRegistryKey)
        
        if (config->compilers.data != NULL)
        {
            for (int i = 0; i < config->compilers.count; i++)
            {
                bjc_free_msi_compiler(config->compilers.data + i);
            }

            free((void *)(config->compilers.data));
            config->compilers.data = NULL;
        }
    }
}

static BOOL parse_msi_compiler(json_object *array, int index, MsiCompilers *compilers)
{
    BOOL parseHadError = FALSE;
    json_object *element;
    json_object *prop;
    json_type propType;
    MsiCompiler *compiler;
    int i = 0;

    if (array == NULL || compilers == NULL || index < 0 || index >= compilers->count)
    {
        parseHadError = TRUE;
    }
    else
    {
        element = json_object_array_get_idx(array, index);
        compiler = compilers->data + index;

        if (element == NULL || compiler == NULL)
        {
            parseHadError = TRUE;
        }
        else
        {
            compiler->id = NULL;
            compiler->name = NULL;
            compiler->hostArch = NULL;
            compiler->version = NULL;
            compiler->displayText = NULL;
            compiler->featuresToRemove = NULL;

            while (bjc_compiler_fields[i] != NULL && !parseHadError)
            {
                prop = json_object_object_get(element, bjc_compiler_fields[i]);

                if (prop == NULL)
                {
                    parseHadError = TRUE;
                }
                else
                {
                    propType = json_object_get_type(prop);

                    if (propType == json_type_int && strcmp(bjc_compiler_fields[i], "Index") == 0)
                    {
                        compiler->index = json_object_get_int(prop);
                    }
                    else if (propType == json_type_string)
                    {
                        int propSize = json_object_get_string_len(prop);
                        LPWSTR res = NULL;
                        const char *utf8Prop = json_object_get_string(prop);
                        if (bjc_convert_utf8_to_unicode(utf8Prop, propSize, &res))
                        {
                            if (strcmp(bjc_compiler_fields[i], "Id") == 0)
                            {
                                compiler->id = (LPCWSTR)res;
                            }
                            else if (strcmp(bjc_compiler_fields[i], "Name") == 0)
                            {
                                compiler->name = (LPCWSTR)res;
                            }
                            else if (strcmp(bjc_compiler_fields[i], "Version") == 0)
                            {
                                compiler->version = (LPCWSTR)res;
                            }
                            else if (strcmp(bjc_compiler_fields[i], "HostArch") == 0)
                            {
                                compiler->hostArch = (LPCWSTR)res;
                            }
                            else if (strcmp(bjc_compiler_fields[i], "DisplayText") == 0)
                            {
                                compiler->displayText = (LPCWSTR)res;
                            }
                            else if (strcmp(bjc_compiler_fields[i], "FeaturesToRemove") == 0)
                            {
                                compiler->featuresToRemove = (LPCWSTR)res;
                            }
                            else
                            {
                                free((void *)res);
                                parseHadError = TRUE;
                            }
                        }
                        else
                        {
                            parseHadError = TRUE;
                        }
                    }
                    else
                    {
                        parseHadError = TRUE;
                    }
                }

                i++;
            }

            if (parseHadError)
            {
                bjc_free_msi_compiler(compiler);
            }
        }
    }

    return !parseHadError;
}

static BOOL parse_msi_config(json_object *root, MsiConfig__ *config)
{
    BOOL parseHadError = FALSE;
    json_object *prop;
    json_type propType;
    int i = 0;

    if (root == NULL || config == NULL)
    {
        parseHadError = TRUE;
    }
    else
    {
        config->productName = NULL;
        config->packageName = NULL;
        config->manufacturer = NULL;
        config->culture = NULL;
        config->language = NULL;
        config->registryKey = NULL;
        config->registryRoot = NULL;
        config->upgradeCode = NULL;
        config->upgradeCodeRegistryKey = NULL;
        config->version = NULL;
        config->versionRegistryKey = NULL;
        config->activeCompilerChoiceProperty = NULL;
        config->activeCompilerIdRegistryKey = NULL;

        while (bjc_config_fields[i] != NULL && !parseHadError)
        {
            prop = json_object_object_get(root, bjc_config_fields[i]);

            if (prop == NULL)
            {
                parseHadError = TRUE;
            }
            else
            {
                propType = json_object_get_type(prop);

                if (propType == json_type_string)
                {
                    int propSize = json_object_get_string_len(prop);
                    LPWSTR res = NULL;
                    const char *utf8Prop = json_object_get_string(prop);

                    if (bjc_convert_utf8_to_unicode(utf8Prop, propSize, &res))
                    {
                        if (strcmp(bjc_config_fields[i], "MsiActiveCompilerChoiceProperty") == 0)
                        {
                            config->activeCompilerChoiceProperty = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiActiveCompilerIdRegistryKey") == 0)
                        {
                            config->activeCompilerIdRegistryKey = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiCulture") == 0)
                        {
                            config->culture = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiLanguage") == 0)
                        {
                            config->language = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiManufacturer") == 0)
                        {
                            config->manufacturer = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiPackageName") == 0)
                        {
                            config->packageName = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiProductName") == 0)
                        {
                            config->productName = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiRegistryKey") == 0)
                        {
                            config->registryKey = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiRegistryRoot") == 0)
                        {
                            config->registryRoot = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiUpgradeCode") == 0)
                        {
                            config->upgradeCode = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiUpgradeCodeRegistryKey") == 0)
                        {
                            config->upgradeCodeRegistryKey = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiVersion") == 0)
                        {
                            config->version = (LPCWSTR)res;
                        }
                        else if (strcmp(bjc_config_fields[i], "MsiVersionRegistryKey") == 0)
                        {
                            config->versionRegistryKey = (LPCWSTR)res;
                        }
                        else
                        {
                            free((void *)res);
                            parseHadError = TRUE;
                        }
                    }
                    else
                    {
                        parseHadError = TRUE;
                    }
                }
                else if (propType == json_type_array)
                {
                    if (strcmp(bjc_config_fields[i], "MsiCompilers") == 0)
                    {
                        int n = json_object_array_length(prop);
                        
                        config->compilers.count = n;
                        config->compilers.data = (MsiCompiler *)(malloc(n * sizeof(MsiCompiler)));

                        if (config->compilers.data == NULL)
                        {
                            parseHadError = TRUE;
                        }
                        else
                        {
                            int j = 0;
                            while (j < n && !parseHadError)
                            {
                                parseHadError = !parse_msi_compiler(prop, j, &(config->compilers));

                                j++;
                            }
                        }
                    }
                    else
                    {
                        parseHadError = TRUE;
                    }
                }
                else
                {
                    parseHadError = TRUE;
                }
            }

            i++;
        }

        if (parseHadError)
        {
            bjc_free_msi_config_content(config);
        }
    }

    return !parseHadError;
}

BootstrapperJsonConfig_API
MsiConfig bjc_new_msi_config(
    HMODULE hModule,
    LPCWSTR lpName,
    LPCWSTR lpType
)
{
    HRSRC hResInfo = FindResourceW(
        hModule,
        lpName,
        lpType);
    
    if (hResInfo == NULL)
    {
        return NULL;
    }

    DWORD size = SizeofResource(hModule, hResInfo);

    if (size == 0)
    {
        CloseHandle(hResInfo);
        return NULL;
    }

    HGLOBAL resource = LoadResource(hModule, hResInfo);

    if (resource == NULL)
    {
        CloseHandle(hResInfo);
        return NULL;
    }

    LPVOID data = LockResource(resource);

    if (data == NULL)
    {
        FreeResource(resource);
        CloseHandle(hResInfo);
        return NULL;
    }

    char *json_str = (char *)(malloc(size + 1));
    if (json_str == NULL)
    {
        FreeResource(resource);
        CloseHandle(hResInfo);
        return NULL;
    }

    memcpy(json_str, (LPCVOID)data, size);

    FreeResource(resource);
    CloseHandle(hResInfo);

    json_str[size] = '\0';

    json_object *root = json_tokener_parse(json_str);
    
    free((void *)json_str);

    if (root == NULL)
    {
        return NULL;
    }
    
    MsiConfig__ *config = (MsiConfig__ *)(malloc(sizeof(MsiConfig__)));

    if (config == NULL)
    {
        json_object_put(root);
        return NULL;
    }

    if (!parse_msi_config(root, config))
    {
        json_object_put(root);
        free((void *)config);
    }

    return config;
}

BootstrapperJsonConfig_API
BOOL bjc_free_msi_config(MsiConfig config)
{
    BOOL res;
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    if (res = !(config__ == NULL || config__->compilers.data == NULL))
    {
        bjc_free_msi_config_content(config__);
        free((void *)config__);
    }

    return res;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_product_name(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->productName;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_package_name(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->packageName;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_manufacturer(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->manufacturer;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_culture(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->culture;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_language(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->language;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_registry_key(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->registryKey;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_registry_root(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->registryRoot;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_upgrade_code(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->upgradeCode;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_upgrade_code_registry_key(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->upgradeCodeRegistryKey;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_version(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->version;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_version_registry_key(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->versionRegistryKey;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_activate_compiler_choice_property(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->activeCompilerChoiceProperty;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_activate_compiler_id_registry_key(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        ((LPCWSTR)NULL) : config__->activeCompilerIdRegistryKey;
}

BootstrapperJsonConfig_API
int bjc_get_number_of_compilers(MsiConfig config)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL) ?
        (-1) : config__->compilers.count;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_id(MsiConfig config, int i)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL || i < 0 || i >= config__->compilers.count) ?
        ((LPCWSTR)NULL) : config__->compilers.data[i].id;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_name(MsiConfig config, int i)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL || i < 0 || i >= config__->compilers.count) ?
        ((LPCWSTR)NULL) : config__->compilers.data[i].name;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_version(MsiConfig config, int i)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL || i < 0 || i >= config__->compilers.count) ?
        ((LPCWSTR)NULL) : config__->compilers.data[i].version;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_host_arch(MsiConfig config, int i)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL || i < 0 || i >= config__->compilers.count) ?
        ((LPCWSTR)NULL) : config__->compilers.data[i].hostArch;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_display_text(MsiConfig config, int i)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL || i < 0 || i >= config__->compilers.count) ?
        ((LPCWSTR)NULL) : config__->compilers.data[i].displayText;
}

BootstrapperJsonConfig_API
LPCWSTR bjc_get_compiler_features_to_remove(MsiConfig config, int i)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL || i < 0 || i >= config__->compilers.count) ?
        ((LPCWSTR)NULL) : config__->compilers.data[i].featuresToRemove;
}

BootstrapperJsonConfig_API
int bjc_get_compiler_index(MsiConfig config, int i)
{
    MsiConfig__ *config__ = (MsiConfig__ *)config;
    return (config__ == NULL || config__->compilers.data == NULL || i < 0 || i >= config__->compilers.count) ?
        (-1) : config__->compilers.data[i].index;
}