using System;

namespace BootstrapperJsonConfig.DotNet
{
	public class MsiConfig : IDisposable
	{
		private IntPtr msiConfig;
		
		public MsiConfig(IntPtr hModule, string nameId, string typeId)
		{
			msiConfig = BootstrapperJsonConfig.DotNet.NativeMethods.bjc_new_msi_config_from_win32resource(
				hModule,
				nameId,
				typeId
			);
		}

		public bool Loaded
		{
			get
			{
				return msiConfig != IntPtr.Zero;
			}
		}

		public string GetProductName()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_product_name(msiConfig);
		}

		public string GetPackageName()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_package_name(msiConfig);
		}

		public string GetManufacturer()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_manufacturer(msiConfig);
		}

		public string GetCulture()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_culture(msiConfig);
		}

		public string GetLanguage()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_language(msiConfig);
		}

		public string GetRegistryKey()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_registry_key(msiConfig);
		}

		public string GetRegistryRoot()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_registry_root(msiConfig);
		}

		public string GetUpgradeCode()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_upgrade_code(msiConfig);
		}

		public string GetUpgradeCodeRegistryKey()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_upgrade_code_registry_key(msiConfig);
		}

		public string GetVersion()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_version(msiConfig);
		}

		public string GetVersionRegistryKey()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_version_registry_key(msiConfig);
		}

		public string GetActiveCompilerChoiceProperty()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_active_compiler_choice_property(msiConfig);
		}

		public string GetActiveCompilerIdRegistryKey()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_active_compiler_id_registry_key(msiConfig);
		}

		public int GetNumberOfCompilers()
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_number_of_compilers(msiConfig);
		}

		public string GetCompilerId(int i)
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_compiler_id(msiConfig, i);
		}

		public string GetCompilerName(int i)
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_compiler_name(msiConfig, i);
		}

		public string GetCompilerVersion(int i)
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_compiler_version(msiConfig, i);
		}

		public string GetCompilerHostArch(int i)
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_compiler_host_arch(msiConfig, i);
		}

		public string GetCompilerDisplayText(int i)
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_compiler_display_text(msiConfig, i);
		}

		public string GetCompilerFeaturesToRemove(int i)
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_compiler_features_to_remove(msiConfig, i);
		}

		public int GetCompilerIndex(int i)
		{
			return BootstrapperJsonConfig.DotNet.NativeMethods.bjc_get_compiler_index(msiConfig, i);
		}

		public void Dispose()
		{
			Dispose(true);
			GC.SuppressFinalize(this);
		}

		protected virtual void Dispose(bool disposing)
		{
			if (disposing)
			{
				if (msiConfig != IntPtr.Zero)
				{
					BootstrapperJsonConfig.DotNet.NativeMethods.bjc_free_msi_config(msiConfig);
					msiConfig = IntPtr.Zero;
				}
			}
		}
	}
}
