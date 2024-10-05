using System;
using System.Runtime.InteropServices;

namespace BootstrapperJsonConfigResource.DotNet
{
	internal static class NativeMethods
	{
        public const string BootstrapperJsonConfigResource_DLL = "BootstrapperJsonConfigResource.dll";
        
		[DllImport("kernel32.dll")]
		public static extern IntPtr LoadLibraryW([In] [MarshalAs(UnmanagedType.LPWStr)] string name);

		[DllImport(BootstrapperJsonConfigResource_DLL, CallingConvention = CallingConvention.Cdecl)]
		public static extern int bjcr_get_name_id();
        
		[DllImport(BootstrapperJsonConfigResource_DLL, CallingConvention = CallingConvention.Cdecl)]
		public static extern int bjcr_get_type_id();
		
	}
}
