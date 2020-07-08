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
[Necessary Tools](../necessary-tools/) are installed.

## Installing

`dotnet tool install -g Fusee.Tools.CmdLine`

On HFU Pcs you in addition have to `set PATH=%PATH%;%USERPROFILE%\.dotnet\tools`

## Uninstalling

`dotnet tool uninstall -g Fusee.Tools.CmdLine`

## Updating

`dotnet tool update -g Fusee.Tools.CmdLine`

## Usage

`fusee` and follow the help text.

## Install Blender Add-on

`fusee install` 

### Enable the FUSEE Export Add-On within Blender

If a Blender installation exists at a typical installation path (e.g. "C:\Program Files\Blender Foundation\...")
one of the `Setup...` commands in the previous step already copied the FUSEE Blender Add-on to a directory recognized
by Blender on start up. Still, the Add-on needs to be activated inside Blender:

1. Open Blender
1. Open the _User Preferences_ window ("File &rarr; User Preferences" or `Ctrl+Alt+U`)
1. Open the _Add-ons_ Tab
1. Under _Supported Level_ activate _Testing_ (The FUSEE Blender Add-on is still experimental).
1. As a result, the Export Add-on should show up as _Import-Export: .fus format_. 
   If the Add-on does not appear in the list, the Blender Add-on installation part of the setup process 
   failed. 
1. Activate the Add-on by checking the check-box.
1. _Save User Settings_ and close the User Preferences window.
1. Blender's File->Export menu should now contain the _FUS (.fus)_ option capable of writing
  FUSEE's .fus file format for 3D Assets.

#### Screen Cast: Enable the FUSEE Export Add-On within Blender.
![Enable FUSEE Blender Add-On](images/enableblenderaddon.gif)



