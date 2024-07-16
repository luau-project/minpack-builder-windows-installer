# Minpack Builder Windows Installer

## Summary

The goal of this repository is to provide a Windows Installer (.msi) to the [MINPACK-1](https://www.netlib.org/minpack) binaries built by our [Minpack Builder](https://github.com/luau-project/minpack-builder) project.

> [!IMPORTANT]
> 
> This project is still in early stages, but might evolve quickly, because *proof of concepts* (.msi) packages containing most expected features were worked locally.

## How

In order to create a MSI package for the binaries, we use [CMake](https://cmake.org/) (&ge; 3.20) to configure the project to be consumed by the command line tools of the [WiX Toolset V5](https://wixtoolset.org/).