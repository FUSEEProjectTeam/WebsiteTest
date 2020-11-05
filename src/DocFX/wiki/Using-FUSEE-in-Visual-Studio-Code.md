# TLDR

## Your own PC

- Install .NET Core 3.1 (https://dotnet.microsoft.com/download/dotnet-core/3.1)
- Install Visual Studio Code (https://code.visualstudio.com/)
- Install the C# extension for Visul Studio Code (https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp)

```
dotnet tool install -g Fusee.Tools.CmdLine
dotnet new -i Fusee.Template.dotnet
fusee install
```
⚠️ If `fusee install` throws an error about the Blender installation, you can either direct it by using the `-i` argument, or you can install the Blender addon manually by using the `io_export_fus.zip` in the [latest release](https://github.com/FUSEEProjectTeam/Fusee/releases).
If you don't have Blender installed just ignore this error, Fusee will run perfectly fine without it. Blender is just used to create/export 3D-models for the use in Fusee.

## HFU PC

```
dotnet tool install -g Fusee.Tools.CmdLine
set PATH=%PATH%;%USERPROFILE%\.dotnet\tools
dotnet new -i Fusee.Template.dotnet
fusee install
```

Run these commands every time you log onto a machine.

# Prerequisite
## .NET Core 3.1

- Install .NET Core 3.1 (https://dotnet.microsoft.com/download/dotnet-core/3.1)
- Install Visual Studio Code (https://code.visualstudio.com/)
- Install the C# extension for Visul Studio Code (https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp)

# Fusee command line tool
## Installing

`dotnet tool install -g Fusee.Tools.CmdLine`

On HFU Pcs you in addition have to `set PATH=%PATH%;%USERPROFILE%\.dotnet\tools`

## Uninstalling

`dotnet tool uninstall -g Fusee.Tools.CmdLine`

## Updating

`dotnet tool update -g Fusee.Tools.CmdLine`

## Usage

`fusee` and follow the help text.

# Visual Studio Code template
## Installing

`dotnet new -i Fusee.Template.dotnet`

## Uninstalling

`dotnet new -u Fusee.Template.dotnet`

## Creating a project using this template and starting it in Visual Studio Code

```
mkdir <YourProjectName>
cd <YourProjectName>
dotnet new fusee
code .
``` 

## Updating
### Template package

```
dotnet new --update-check
dotnet new --update-apply
```

### Packages in a project

Run `dotnet add package Fusee.Desktop` in the same directory as the csproj file. You can optionally force it to use a certain version with the `--version` switch.

## FUSEE's Blender addon
### Install

Install Fusee command line tool.

`fusee install -b`

Alternatively you can download the latest Blender addon directly from our [latest release](https://github.com/FUSEEProjectTeam/Fusee/releases), the file you want is io_export_fus.zip. Install it through the [Blender addon dialog](https://docs.blender.org/manual/en/latest/editors/preferences/addons.html).

### Uninstall

Install Fusee command line tool.

`fusee install -bu`

## Packaging your FUSEE application to a .fuz-file

In Visual Studio Code press `Ctrl`+`Shift`+`B` select 'Pack Fusee app as fuz file'. You can find the fuz file in your build directory (usualy 'bin/Debug').

Upload the .fuz file to your webspace and link it with a fusee URI scheme handler e.g.: `fusee://mywebspace.com/myfuseeapp.fuz`.

