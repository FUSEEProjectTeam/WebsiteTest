---
title: Install FUSEE
subtitle: Step-by-step installation instructions
comments: false
date: 2017-11-25
weight: 20
---

>  **NOTE**: Developing FUSEE Apps is currently only supported on Windows operating systems.

-------------

Before following the FUSEE installation instructions on this page, make sure all
[Necessary Tools](../getting-started/necessary-tools.html) are installed.

## Installing

`dotnet tool install -g Fusee.Tools.CmdLine`

`dotnet new -i Fusee.Template.dotnet`

On HFU Pcs you in addition have to `set PATH=%PATH%;%USERPROFILE%\.dotnet\tools`

## Uninstalling

`dotnet tool uninstall -g Fusee.Tools.CmdLine`

`dotnet new -u Fusee.Template.dotnet`

## Updating

`dotnet tool update -g Fusee.Tools.CmdLine`

## Usage

`fusee` and follow the help text.


### Install/Enable the FUSEE Export Add-On within Blender

1. Download the [io_export_fus.zip](https://github.com/FUSEEProjectTeam/Fusee/releases/latest/download/io_export_fus.zip)
1. Open Blender
1. Open the `User Preferences` window ("File &rarr; Preferences" or `Ctrl+Alt+U`)
1. Open the `Add-ons` Tab
1. Under Supported Level activate Testing (The FUSEE Blender Add-on is still experimental).
1. Click the `Install` button 
1. Goto the `io_export_fus.zip` location and select it
1. Click the `Install Add-on` button
1. Activate the Add-on by checking the check-box.
1. Save User Settings and close the User Preferences window.
1. Blender's File->Export menu should now contain the FUS (.fus) option capable of writing FUSEE's .fus file format for 3D Assets.

#### Screen Cast: Enable the FUSEE Export Add-On within Blender.
![Enable FUSEE Blender Add-On](images/enableblenderaddon.gif)



