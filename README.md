# Minpack Builder Windows Installer

## Summary

The goal of this repository is to provide a Windows Installer (.msi) to the [MINPACK-1](https://www.netlib.org/minpack) binaries built by our [Minpack Builder](https://github.com/luau-project/minpack-builder) project.

> [!NOTE]
> 
> This project is currently in alpha stage. Be aware that you might find bugs. An improved documentation is coming soon.

## Documentation

Browse the [documentation](./docs/README.md).

## Known limitations

In the current stage, the MSI installer works fine using the graphical user interface provided by Programs and Features (also known as Add/Remove Programs).

> [!IMPORTANT]
>
> It is known to **NOT** behave correctly through quiet command line installs:
> 
> ```cmd
> C:\path\to\installer.msi /qn
> ```