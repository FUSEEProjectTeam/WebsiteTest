  > ⚠️ **Pre-Release Content**

## **[Prerequisites]**   
Understood FUSEE's Scene Graph concept, especially how ``SceneNodeContainers`` and ``SceneComponentContainers`` work together.  
Basic knowledge on matrix transformations in Computer Graphics (View and Projection matrices).  

## Using Cameras in the Scene Graph

Building a scene from code or loading a scene from a fus file will result in a ``SceneContainer``, containing Nodes and Components.  
To render the scene we can add a Camera to the ``SceneContainer``. Note that this is no must but, for example, makes the implementation of follow or orbit cameras much easier (see the [Examples section](#Examples)).

A camera consists of a ``SceneNodeContainer`` which contains a ``TransformComponent`` and a ``CameraComponent``.

### TransformComponent

As with every other ``TransformComponent`` the Translation, Rotation and Scale values are relative to the ones of the parent nodes.
The cumulated Translation and Rotation values describe the cameras position in world space and therefore are the basis for calculating the View matrix (which is done in the background).

### CameraComponent

The CameraComponent consists of the following properties:

| Type        | Name           | Description  |
| ------------- |-------------| -----|
| ``bool``      | Active | If set to ``true`` this camera generates a render output. |
| ``WritableTexture`` | RenderTexture | If this is not ``null`` the output gets rendered into the texture, otherwise to the screen. |
| ``float4``    | Viewport | The output is rendered to the section of the application window defined by the Viewport values (see [table below](#Viewport)). |
| ``float2``    | ClippingPlanes | Distance to the near (x value) and far (y value) clipping planes.|
| ``float``      | Fov | Vertical field of view in radians. |
| ``ProjectionMethod``  | ProjectionMethod | Sets the projection method. At the moment we can choose between perspective and orthographic. |
| ``int``      | Layer | If there is more than one CameraComponent in one scene, the rendered output of the camera with a higher layer will be drawn above the output of a camera with a lower layer. |
| ``float4``      | BackgroundColor | The background color of the render output. |
| ``bool``      | ClearColor | Is ``true`` per default. If set to ``false``, the color bit won't be cleared before this camera is rendered. Set this to ``false`` if the background color should be transparent. |
| ``bool``      | ClearDepth | Is ``true`` per default. If set to ``false``, the depth bit won't be cleared before this camera is rendered. |
| ``CustomCameraUpdate``  | CustomCameraUpdate | Is ``null`` by default. This delegate enables us to add a custom projection method. If we choose to use this delegate we need to provide a method that calculates a projection matrix and outputs a Viewport in percent in the range [0, 100]. Note that this is **optional** but if this delegate is not ``null`` its ``out`` values (Projection matrix and Viewport) will overwrite  the ones calculated from the other camera parameters.|

#### Viewport

The values are given in percent in the range [0, 100].

| ``float4``        | x           | y  | z| w| 
| ------------- |-------------| -----| -----| -----|
| | x value of the lower left corner| y value of the lower left corner | width | height |

## Examples

### Creating the Camera SceneNodeContainer

The constructor of the ``CameraComponent`` expects a projection method, the distances to the clipping planes and the field of view in radians.  
When creating the ``TransformComponent`` we can add a Scale value. This doesn't have an effect on the View matrix calculation, but can be useful if the camera node has a ``Mesh`` attached.

```C#
//1. Create a TransformComponent and a CameraComponent.
private TransformComponent _mainCamTransform;
private CameraComponent _mainCam = new CameraComponent(ProjectionMethod.PERSPECTIVE, 1, 1000, M.PiOver4);

public override async Task<bool> Init()
{
  _mainCam.Viewport = new float4(0, 0, 100, 100);
  _mainCam.BackgroundColor = new float4(1, 1, 1, 1);
  _mainCam.Layer = -1; 

  _mainCamTransform = _guiCamTransform = new TransformComponent()
  {
      Rotation = float3.Zero,
      Translation = new float3(0, 2, -10),
      Scale = new float3(0.33f, 0.33f, 0.5f)
  };

  [...]

  //2. Create the SceneNodeContainer.
  var cam = new SceneNodeContainer()
  {
      Name = "MainCam",
      Components = new List<SceneComponentContainer>()
      {
          _mainCamTransform,
          _mainCam,
          new Cube()
      },
      Children = new ChildList()
      {
          new SceneNodeContainer()
          {
              Components = new List<SceneComponentContainer>()
              {
                  new TransformComponent()
                  {
                      Scale = new float3(1, 1, 1),
                      Translation = new float3(0,0,-1.4f)
                  },
                  new Cube()
              }
          }
      }
  };

  //3. Add the camera to the scene.
  _rocketScene.Children.Add(cam);

  [...]

}
```

### Orbit Camera
  
In the code below we use the method ``TransformComponent.RotateAround`` to create an orbit camera. This method expects a point (``float3``), that is used as the rotation center, and a rotation in angle-axis representation (``float3`` up-axis, ``float`` angle).

> 💡 **Note:** In the example the rotation center is ``(0, 0, 0)``, in practice it is useful to take the world space position of the object we want to rotate around. We can get this position for example by using ``SceneNodeContainer.GetGlobalTranslation()``.

```C#
public override void RenderAFrame()
{
    [...]

    //4 Use RotateAround(float3 center, float3 up-axis, float angle) to rotate the camera.
    var rotAxis = float3.UnitY * float4x4.CreateRotationYZ(new float2(M.PiOver4, M.PiOver4));
    _mainCamTransform.RotateAround(new float3(0,0,0), rotAxis, someAngle * DeltaTime);

    [...]  
}
```

> 💡 **Note:** We can also achive achieve an orbit camera by not rotating the camera itself, but by placing it under a ``SceneNodeContainer``, which serves as a pivot point.  
In this case we rotate the pivot around its origin. This method may prove more stable against cummulative rounding errors.

### Follower Camera

A follower Camera can be achieved simply by adding the Camera ``SceneNodeContainer`` as a child to the object we want it to follow instead of putting it directly under the ``SceneContainer`` itself. 

```C#
public override async Task<bool> Init()
{
  [...]

  //3. Add the camera to a node.
  _someParentNode.Children.Add(cam);
}
```

### First Person Camera

To achieve a fps camera we can use ``TransformComponent.FpsView()``. This method will modify the ``Translation`` and ``Rotation`` of the camera according to the parameters we pass.  
It expects the following parameters:

| Type        | Name           | Description  |
| ------------- |-------------| -----|
| ``float``      | angleHorz |  The horizontal rotation angle in radians. Should probably come from Mouse input (``Mouse.XVel``).|
| ``float``      | angleVert |  The vertical rotation angle in radians. Should probably come from Mouse input (``Mouse.YVel``).|
| ``float``      | inputWSAxis |  The value we want to translate the camera when pressing the W or S key (``Keyboard.WSAxis``).|
| ``float``      | inputADAxis |  The value we want to translate the camera when pressing the A or D key (``Keyboard.ADAxis``).|
| ``float``      | speed |  Changes the speed of the camera movement.|

```C#
public override void RenderAFrame()
{
    [...] 

    _camTransform.FpsView(_angleHorz, _angleVert, Keyboard.WSAxis, Keyboard.ADAxis, Time.DeltaTime * 1000);

    [...]
}
```

## View and Projection matrices without a SceneGraph

If we render without a scene graph or do not want to use a camera for whatever reason, we can set the Viewport, Projection matrix and View matrix directly on the ``RenderContext``.

```C#
public override void RenderAFrame()
{
    RC.Viewport(0, 0, Width, Height);
    [...] 

    _camTransform.FpsView(_angleHorz, _angleVert, Keyboard.WSAxis, Keyboard.ADAxis, Time.DeltaTime * 1000);

    [...]

    var mtxRot = float4x4.CreateRotationX(_angleVert) * float4x4.CreateRotationY(_angleHorz);
    var mtxCam = float4x4.LookAt(0, 20, -_zoom, 0, 0, 0, 0, 1, 0);

    var view = mtxCam * mtxRot;
    var perspective = float4x4.CreatePerspectiveFieldOfView(_fovY, (float)Width / Height, ZNear, ZFar) * mtxOffset;

    RC.View = view;
    RC.Projection = orthographic;

    [...]
}
```

If we don't set the parameters at all FUSEE will use predefined default values. Those can be read from ``RenderContext.DefaultState``.  
  
## Implementation details
 > 👷 **Engine Developer**

In order for the camera to work in the expected way, each ``SceneRenderer`` – whether it is a Forward, Deferred or a custom one – needs a pre-rendering pass (one traversal of the scene). This pre-pass is responsible for collecting the ``CameraComponents`` and calculating the view matrix for each one.

This is implemented in the ``PrePassVisitor``. For each ``CameraComponent`` that is found while traversing the scene, we calculate the View matrix from the cumulated Model matrix by eliminating its scale (get the scale factor and divide the 3x3 rotation/scale part of the matrix by it) and inverting it (``view = _state.Model.Invert()``).  
The ``CameraComponent`` and its View matrix is then saved as a ``CameraResult`` to a public list and can therefore be accessed from the ``SceneRenderer``.

Back in the scene renderer we render one time for each camera we've found in the pre-pass, taking the ``CameraComponents'`` ``Viewport`` the resulting Projection matrix and the ``CameraResults'`` View matrix into account.




