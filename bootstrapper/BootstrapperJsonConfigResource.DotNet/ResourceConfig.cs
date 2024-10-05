using System;

namespace BootstrapperJsonConfigResource.DotNet
{
    public static class ResourceConfig
    {
        private static readonly IntPtr hModule;

        static ResourceConfig()
        {
            hModule = BootstrapperJsonConfigResource.DotNet.NativeMethods.LoadLibraryW(BootstrapperJsonConfigResource.DotNet.NativeMethods.BootstrapperJsonConfigResource_DLL);
        }

        public static IntPtr GetHModule()
        {
            return hModule;
        }

        public static string GetNameId()
        {
            return "#" + BootstrapperJsonConfigResource.DotNet.NativeMethods.bjcr_get_name_id().ToString();
        }

        public static string GetTypeId()
        {
            return "#" + BootstrapperJsonConfigResource.DotNet.NativeMethods.bjcr_get_type_id().ToString();
        }
    }
}

