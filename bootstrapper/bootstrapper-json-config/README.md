# BootstrapperJsonConfig

This project is a C library that loads and parses a configuration file (.json) embedded as a resource in the bootstrapper application. Such config file has the purpose to share with the bootstrapper application all the relevant MSI properties that were set during the .msi building phase. After loading the config file from the embedded resource, it is parsed and made available through the API contained at [src/bootstrapper-json-config.h](./src/bootstrapper-json-config.h).

## Dependencies

In order to parse the config file, this library uses [json-c](https://github.com/json-c/json-c) to handle the .json format, which is licensed in a MIT-like manner.

## Glossary

* bootstrapper application: the application that detects installed versions, and manages (install / uninstall / update) the .msi installer passing proper parameters to the ```msiexec```.