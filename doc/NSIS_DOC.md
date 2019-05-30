# NSIS Usage Documentation

Tools which you should have to build an installer for GRAFT clients:
* [NSIS (3.04)](https://sourceforge.net/projects/nsis/files/NSIS%203/3.04/nsis-3.04-setup.exe/download?use_mirror=netcologne&download=)
* [nsProcess plugin v1.6 (NSIS UNICODE support, by brainsucker)](https://nsis.sourceforge.io/NsProcess_plugin)

## NSIS installation

To install NSIS on your PC, you have to download the [NSIS installer](https://sourceforge.net/projects/nsis/files/NSIS%203/3.04/nsis-3.04-setup.exe/download?use_mirror=netcologne&download=), run it and follow by installation instruction.

When you already installed NSIS, you have to install plugins to successfully build an installer for GRAFT clients. For this, just unzip [NsProcess.zip](https://nsis.sourceforge.io/NsProcess_plugin) to **NsProcess** and paste contents of **NsProcess/Include to PATH_TO_NSIS/Include** and **NsProcess/Plugins to PATH_TO_NSIS/Plugins**.

## NSIS Usage (Manual Running)

For manual running NSIS script to create an installer for GRAFT clients you will have to exec:

```
$ PATH_TO_NSIS/makensis.exe PATH_TO_NSIS_BUILD_SCRIPT/install.nsi
```
