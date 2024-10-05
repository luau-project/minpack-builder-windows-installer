# BootstrapperJsonConfigResource.DotNet

This library is a .NET wrapper around the unmanaged DLL [bootstrapper-json-config-resource](../bootstrapper-json-config-resource).

> [!IMPORTANT]
> 
> The path for the unmanaged DLL must be passed as argument to project at the building phase.

## Building

We are going to assume that you built ```bootstrapper-json-config-resource``` as DLL, and such DLL can be found at ```C:\dependencies\bin\BootstrapperJsonConfigResource.dll```.

Then, you can build ```BootstrapperJsonConfigResource.DotNet``` in the following manner:

```cmd
dotnet build BootstrapperJsonConfigResource.DotNet.csproj ^
    /p:BootstrapperJsonConfigResource_DLL=C:\dependencies\bin\BootstrapperJsonConfigResource.dll
```