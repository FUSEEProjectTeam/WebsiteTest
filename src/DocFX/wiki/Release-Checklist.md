* Create new release branch `git checkout -b release/v[x.y.z]`
* Update version number (Use the `UpdateVersionNumber.cmd` to open up all files)
  * Engine: `\Directory.Build.props` (Version, AssemblyVersion, FileVersion, PackageVersion)
  * Blender plugin: `\src\Tools\BlenderScripts\addons\io_export_fus\__init__.py` ("version")
  * Dotnet template: `\dis\DnTemplate\template\Fusee_App.csproj` (PackageReference Fusee.Desktop)
  * Visual Studio template:
    * `\dis\VSTemplate\VSIX\Properties\AssemblyInfo.cs` (AssemblyVersion, AssemblyFileVersion)
    * `\dis\VSTemplate\VSTemplate\Properties\AssemblyInfo.cs` (AssemblyVersion, AssemblyFileVersion)
    * `\dis\VSTemplate\VSTemplate\[Android,Core,Desktop]\[Android,Core,Desktop].csproj` (PackageReference Fusee.[Android,Core,Desktop])

**Everything below has to start over whenever a bug is discovered and fixed in the release process**

* Build NuGet packages
  * Execute `BuildNuget.cmd`
  * Check the log for errors
  * Verify that all packages are present in `\bin\Release\nuget` (nupkg: 19, snupkg: 15)
  * Note: if you are rebuilding the same version number again after something below failed you MUST delete them in `%USERPROFILE%\.nuget\packages`.
* Build Visual Studio template
  * VSIX Project in `\dis\VSTemplate\VSTemplate.sln`
  * Copy `\dis\VSTemplate\VSIX\bin\Debug\Fusee.Template.VS.vsix` somewhere nice
  * Copy `\dis\VSTemplate\VSTemplate\bin\Debug\ProjectTemplates\CSharp\1033\Fusee.Template.VS.zip` somewhere nice
* Uninstall previous Fusee tools and templates
  * `dotnet tool uninstall -g Fusee.Tools.CmdLine`
  * `dotnet new -u Fusee.Template.dotnet`
  * Uninstall Fusee.Template.VS extension in Visual Studio
* Install new Fusee tools and templates
  * `dotnet tool install -g Fusee.Tools.CmdLine --add-source bin\Release\nuget\`
  * `dotnet new -i Fusee.Template.dotnet --nuget-source [abolutepathtofusee]\bin\Release\nuget\`
  * Copy Fusee.Template.VS.zip to `%USERPROFILE%\Documents\Visual Studio 2019\Templates\ProjectTemplates`
* Test Fusee.Tools.CmdLine
  * Run `fusee player`
  * Run `fusee install`
  * Check if plugin version in Blender is correct and plugin can be activated
  * Check if an exported fus-file from Blender can be opened by double-click and displays correctly
* Test Fusee.Template.dotnet
  * Run `dotnet new fusee` in a temporary directory
  * Run `dotnet restore -s [abolutepathtofusee]\bin\Release\nuget`
  * Check if project works in Visual Studio Code.
* Test Fusee.Template.VS
  * Create an new Fusee project with Visual Studio
  * Add `[abolutepathtofusee]\bin\Release\nuget` as a local package source (https://docs.microsoft.com/en-us/nuget/consume-packages/install-use-packages-visual-studio#package-sources)
  * Check if Project works
  * Remove the local package source!
* Release (after pull request if accepted and merged)
  * Merge release commit into develop
  * Create git tag at the merge commit in master (v[x.y.z])
  * Create GitHub release and attach all NuGet packages, Fusee.Template.VS.zip and Fusee.Template.VS.vsix
  * Upload all NuGet packages to nuget.org
* Pet a cat 😸 
