  > ⚠️ **Pre-Release Content**

## Installing the Blender Add-on

The FUSEE Blender Add-on is part of the FUSEE commmand line tool (`fusee.exe`). The FUSEE command line tool is available as a dotnet tool. To donload and install dotnet tools the latest version of the dotnet framework is required. Thus, to install the FUSEE Blender Add-on:

1. Make sure Blender (v2.82 or higher) is installed at its default installation directory

2. Download and install the latest version of .NET Core (version 3.0 or higher):
   https://dotnet.microsoft.com/download

3. Open a command terminal window (shell) and dwonload and install the FUSEE command line tool by typing
   ```
   dotnet tool install -g Fusee.Tools.CmdLine
   ```

4. Advise the FUSEE command line tool (fusee.exe) to identify your Blender installation and copy the necessary Add-on files to the Blender installation location by typing 
   ```
   fusee install -b
   ```

5. In Blender activate the export Add-on by going to Edit → Preferences → Add-ons Tab → Testing category and checking [☑ Import-Export: .fus format]

As a result you should see the [FUS (.fus)] entry in Blender's File → Export menu.

## Exported Features

### Hierarchies (Parent/Child Relations)

Hierarchies of nodes in a Blender scene are fully exported to the resulting .fus files. Transformations (position/rotation) applied to a exported Blender scene in a FUSEE application e.g. as a result of user interaction will show the expected result.

FUSEE cannot handle Blender's system of storing the parent's inverse matrix at the time of parenting a child node. In addition FUSEE applies a parent's scale transformation to child nodes differently from the way Blender does this. Thus, all scale settings are applied to the respective geometry and recursively propagated to child nodes. As a result, all scale settings in the exported FUSEE file will be set to 1.0.

> 💡 **Note:** Applying the scale transformation to the mesh and children during export can be suppressed by unchecking the [☑ Apply Scale] settings in the Export FUS File View dialog (in the settings region at the right border of the dialog).

### Geometry

Blender's capabilities of representing 3D geometry is much richer than FUSEE's. In general, only Blender Mesh Objects will exported resulting in FUSEE geometry. To export as much of the geometry's visual impression within the FUSEE file format's  limited capabilities, the Blender exporter automatically takes the following actions

1. Re-calculate all normal directions to make them face to the object's outside
2. Apply Modifiers such as Multiresolution, Subdivision Surface, Mirror or Edge Split 
3. Triangulate the resulting mesh

> 💡 **Note:** Recalculating the normals towards the outside and applying the modifiers to the mesh during export can be suppressed by unchecking the [☑ Recalculate Outside] or the [☑ Apply Modifiers] settings in the Export FUS File View dialog (in the settings region at the right border of the dialog).

#### Exported Vertices

The exported FUSEE file only contains vertices contributing to a face. Non-manifold parts of the Blender geometry such as single vertices or vertices only connected by edges (no faces) are not exported. Only the first UV layer's texture coordinates will be exported.

Since FUSEE geometries consist of a vertex list and a triangle list referencing indices into the vertex list, vertices spanning multiple triangles can be re-used by referencing them more than once from the triangle list. The export Add-On will re-use vertices from different triangles with identical position, normal and uv.

#### Mesh Data Instances

Blender mesh data can be referenced from different mesh objects and thus instantiated more than once in a Blender scene. Imagine a forest made out of multiple instances of one single tree mesh data set positioned at different locations in a Blender scene. The exporter will keep track of such instances and will re-use meshes as good as possible.

> 💡 **Note:** If the [☑  Apply Scale] setting is set, whenever a Blender mesh data set is used in different mesh object instances with different scale transformations (e.g. one tree bigger than the others), the exporter will generate a new mesh object for each unique scale value.

#### Huge Meshes

Blender Mesh objects resulting in more than 65000 exportable vertices will be split up into a number of FUSEE scene nodes each containing a part of the original Blender Mesh geometry with no more than 65000 vertices. All FUSEE nodes belonging to a single original Blender Mesh are sub-grouped under a FUSEE node with the same name as the original Mesh object.

### Materials

Only a very limited subset of Blender's material system is supported by FUSEE and thus exported. Either use a Principled BSDF shader (recommended) or a small node graph combining  a Diffuse BSDF and a Specular BSDF through a Mix shader.

#### Principled BSDF

The following Principled BSDF properties are recognized by the FUSEE exporter

- Base Color (single value or Image Texture connected to Base Color)
- Specular (single value only - no texture)
- Roughness (single value only - no texture)
- Normal (Image Texture connected through a Normal Map node in Tangent Space)

#### Textures

Currently the exporter only support textures as Image Texture nodes connected to a Principled BSDF's Base Color or Normal value. The only supported file formats by FUSEE are .jpg or .png. Make sure to make the textures' dimensions powers of 2 (256, 512, 1024, ...). The image files will be copied to the destination .fus file's directory. 

#### Multiple Materials

A Blender mesh referencing more than one material will be split up into a as many FUSEE nodes as there are materials referenced from the mesh geometry. All of these FUSEE nodes belonging to a single original Blender Mesh are sub-grouped under a FUSEE node with the same name as the original Mesh object. The geometry part belonging to a single material is possibly further subdivided if the part will generate more than 65K vertices on export (see [Huge Meshes](#Huge-Meshes)).


## 👷 Developer Information

### Overall Structure

The Blender FUSEE Export Add-on follows the general Blender Add-on rules written in Python. It consists of four parts depending on each others in the following order:

1. The Add-on glue code to make it appear in Blender's File → Export menu (`__init__.py`). On export this calls: 
2. The Visitor to traverse the Blender scene graph in a Pre-order manner (`BlenderVisitor.py`). It contains various methods for the different types of Blender objects appearing in a Blender scene graph. This class can be reused in other scenarios than an export menu entry where a FUSEE scene should be generated from within blender (see [Command Line](#Command-Line)). During Blender scene traversal it uses:
3. A Blender Python (bpy)-agnostic FUSEE scene writer class taking to-be-exported payload (such as materials, transformation settings, mesh geometry) in a structured way while traversing the original scene graph (`FusWriter.py`). This class could be reused in other situations where a FUSEE scene should be generated from Python code. To assemble the serialized FUSEE file stream, it uses:
5. The Google-Protobuf Python classes (`proto/FusSerialization_pb2.py`). These classes are automatically generated in a two-step process during the FUSEE build process: 
   1. The command `fusee protoschema` generates a Google-Protobuf schema from the C# classes found in Fusee (mainly in the Fusee.Serialization project).
   2. A call to the Protobuf compoiler `protoc.exe` generates Python code from the schema.

#### Command Line
In addition to the Add-on hooking into Blender's File → Export menu, the export functionality can be accessed through the `fusexport.py` Python script. Blender can be started from the command line and advised to execute this script (`--python` / `-P`). The script can be passed an input Blender file and an output .fus file file/path. This allows transforming blender files into FUSEE files in automated processes, e.g. during build or as part of automated tests. Since Blender can be started without a window (`--background` / `-b`) it can run on build servers or cloud services. To start the FUSEE export process from the command line, the Add-on does not need to be installed. Yet, all of the above mentioned python files (without `__init__.py`) must be present relative to `fusexport.py`. 

Example usage to read MyScene.blend and convert it to MyScene.fus:

```
> <PATH_TO_BLENDER>/blender -b MyScene.blend -P <PATH_TO_ADDON>/fusexport.py -- -o MyScene.fus
```

Note the "isolated" double hyphen (`--`) separating the Blender flags (`-b`, `-P`) from the flag recognized by the script (`-o`).

### Debugging

The Exporter can only run inside a running Blender instance. Fortunately Visual Studio as well as Visual Studio code can debug into any existing application hosting Python through PTVSD. On the python side on the developer machine, `pip ptvsd` enables the Blender Add-on (`__init__.py`) to hook to a debugging session. With the respective Python Add-Ins in Visual Studio or VS Code installed, the respective IDE's debugger can connect to Blender. It is then possible to set breakpoints and step through the code during .fus export. The VS Code workspace at `<FUSEE_ROOT>/src/Tests/Serialization/Fusee.Serialization.PyTest/PythonTest.code-workspace` contains a debug configuration for this scenario.

#### Debugging Setup

To directly debug into the development code in `<FUSEE_ROOT>/src//Tools/BlenderScripts/addons/io_export_fus` using Visual Studio code:

1. Start Blender, go to Edit → Preferences → Add-ons Tab and deactivate (better: de-install) any FUSEE Export Add-on instance at the standard Blender Add-on locations.
2. In the preferences dialog, go to the File Paths tab and set the Scripts directory to: `<FUSEE_ROOT>/src/Tools/BlenderScripts/`.
3. Restart Blender, then activate the export Add-on directly in the FUSEE source tree by going to Edit → Preferences → Add-ons Tab → Testing category and checking [☑ Import-Export: .fus format].
4. Open VS Code with the above mentioned `PythonTest.code-workspace`.
5. Set a breakpoint, e.g. in the `ExportFUS` class' `export()` method (in `__init__.py`).
6. Load a .blend file, click the [FUS (.fus)] entry in Blender's File → Export menu and hit the Export FUS button.

As a result, VS Code should stop Blender's execution at the specified breakpoint. You can now inspect variables, step forward and set new breakpoints as usual.
