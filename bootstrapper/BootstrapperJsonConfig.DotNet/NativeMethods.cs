using System;
using System.Runtime.InteropServices;

namespace BootstrapperJsonConfig.DotNet
{
	internal static class NativeMethods
	{
		#if GCC_LIKE
		private const string BootstrapperJsonConfig_DLL = "libBootstrapperJsonConfig.dll";
		#else
		private const string BootstrapperJsonConfig_DLL = "BootstrapperJsonConfig.dll";
		#endif

		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		public static extern IntPtr bjc_new_msi_config_from_win32resource(
			[In] IntPtr hModule,

			[MarshalAs(UnmanagedType.LPWStr)]
			[In] string lpNameId,
			
			[MarshalAs(UnmanagedType.LPWStr)]
			[In] string lpTypeId
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		public static extern bool bjc_free_msi_config(
			[In] IntPtr msiConfig
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_product_name(
			[In] IntPtr msiConfig
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_package_name(
			[In] IntPtr msiConfig
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_manufacturer(
			[In] IntPtr msiConfig
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_culture(
			[In] IntPtr msiConfig
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_language(
			[In] IntPtr msiConfig
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_registry_key(
			[In] IntPtr msiConfig
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_registry_root(
			[In] IntPtr msiConfig
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_upgrade_code(
			[In] IntPtr msiConfig
		);

		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_upgrade_code_registry_key(
			[In] IntPtr msiConfig
		);

		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_version(
			[In] IntPtr msiConfig
		);

		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_version_registry_key(
			[In] IntPtr msiConfig
		);

		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_active_compiler_choice_property(
			[In] IntPtr msiConfig
		);

		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_active_compiler_id_registry_key(
			[In] IntPtr msiConfig
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		public static extern int bjc_get_number_of_compilers(
			[In] IntPtr msiConfig
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_compiler_id(
			[In] IntPtr msiConfig,
			[In] int i
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_compiler_name(
			[In] IntPtr msiConfig,
			[In] int i
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_compiler_version(
			[In] IntPtr msiConfig,
			[In] int i
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_compiler_host_arch(
			[In] IntPtr msiConfig,
			[In] int i
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_compiler_display_text(
			[In] IntPtr msiConfig,
			[In] int i
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		[return: MarshalAs(UnmanagedType.LPWStr)]
		public static extern string bjc_get_compiler_features_to_remove(
			[In] IntPtr msiConfig,
			[In] int i
		);
		
		[DllImport(BootstrapperJsonConfig_DLL, CallingConvention = CallingConvention.Cdecl)]
		public static extern int bjc_get_compiler_index(
			[In] IntPtr msiConfig,
			[In] int i
		);
	}
}
