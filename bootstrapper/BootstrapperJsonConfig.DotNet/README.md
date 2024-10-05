# BootstrapperJsonConfig.DotNet

This library is a .NET wrapper around the unmanaged DLL [bootstrapper-json-config](../bootstrapper-json-config). 

> [!IMPORTANT]
> 
> Since ```bootstrapper-json-config``` is an unmanaged library with a runtime dependency on another unmanaged library ```json-c```, paths for both dynamic shared libraries must be passed as arguments to project at the building phase.

## Building

### MSVC

We are going to assume that you built both libraries ```json-c``` and ```bootstrapper-json-config``` as DLLs with MSVC, and such DLLs can be found at ```C:\dependencies\bin\json-c.dll``` and ```C:\dependencies\bin\BootstrapperJsonConfig.dll```, respectively.

Then, you can build ```BootstrapperJsonConfig.DotNet``` in the following manner:

```cmd
dotnet build BootstrapperJsonConfig.DotNet.csproj ^
    /p:BootstrapperJsonConfig_DLL=C:\dependencies\bin\BootstrapperJsonConfig.dll ^
    /p:JsonC_DLL=C:\dependencies\bin\json-c.dll
```

### GCC

We are going to assume that you built both libraries ```json-c``` and ```bootstrapper-json-config``` as DLLs with GCC, and such DLLs can be found at ```C:\dependencies\bin\libjson-c.dll``` and ```C:\dependencies\bin\libBootstrapperJsonConfig.dll```, respectively.

Then, you can build ```BootstrapperJsonConfig.DotNet``` in the following manner:

```cmd
dotnet build BootstrapperJsonConfig.DotNet.csproj ^
    /p:GCC_LIKE=true ^
    /p:BootstrapperJsonConfig_DLL=C:\dependencies\bin\libBootstrapperJsonConfig.dll ^
    /p:JsonC_DLL=C:\dependencies\bin\libjson-c.dll
```