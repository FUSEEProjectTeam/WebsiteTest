  > ⚠️ **Pre-Release Content**

# Light

## Types

In FUSEE we are capable to place various light sources in the scene by using ``LightComponents``. They can be of the following  ``LightTypes``:

### Point

Point lights are omnidirectional lights; they cast light in every direction. Additionally the light strength decreases the farther away we are from its source. This reduction is calculated in the background with a so-called attenuation function. To be able to calculate the light strength at a certain point in the scene, this kind of light source also needs a position.

Important, type dependent properties of the light component: 

| Type        | Name           | Description  |
| ------------- |-------------| -----|
| ``float``      | MaxDistance | The distance from the light source at which the light strength becomes zero (attenuation = 0). |

Examples for point lights are light bulbs or torches.

### Spot

Spot lights cast their light in a cone into a specific direction. Like point lights, the strength of the light decreases with increasing distance from the source.  
The cone is described based on an cutoff angle. Nothing that falls outside the cone will be lit. Additionally we define a inner cone angle. This lets us calculate a spot light with smooth edges. 

Important, type dependent properties of the light component: 

| Type        | Name           | Description  |
| ------------- |-------------| -----|
| ``float``      | MaxDistance | The distance from the light source at which the light strength becomes zero (attenuation = 0). |
| ``float``      | OuterConeAngle |The cutoff angle in radians. |
| ``float``      | InnerConeAngle |Needed to smooth the cone edges. Given in radians. |


The best example for a spot light is a flashlight.

### Parallel

Parallel lights are used to light the whole scene, for example to simulate the sun. If a light is away far enough, its light rays can be thought to be parallel, hence the name of the light. This type has a direction but its strength does not decrease with the distance to the source and therefor it doesn't need a specified position.

Important, type dependent properties of the light component: 

None.

### Legacy

The legacy light is a kind of parallel light, whose direction is always equal to the positive z-axis of the active camera (line of sight). This kind of light is inserted to the scene if no other ``LightComponents`` are detected.  
It isn't meant to be used manually, use the above types instead.

### Universal properties

Other useful properties of the ``LightComponent`` are described in the table below, they also can be animated at runtime.

| Type        | Name           | Description  |
| ------------- |-------------| -----|
| ``bool``      | Active | Turns the light on and off. |
| ``float``      | Color | The light color. |
| ``float``      | Strength | The overall intensity of the light. Needs to be a value between 0 and 1. |

## Position and Direction

As described above, some light types need a position and/or a direction to light the scene in the intended way. Those are not properties of the ``LightComponent`` itself, but calculated based on the ``TransformComponent``, associated with the light. This enables us to use one ``LightComponent`` multiple times in the scene graph. 

The position of the light in world space -- if used in a Scene Graph, also relative to the parent node -- is simply set by the translation property of the ``TransformComponent``.

The default direction of a light is the positive z-axis of the world space. To change it, we need to add a rotation to the ``TransformComponent``. For example: if we set a rotation of 90 degree around the positive x-axis, the lights direction will become equal to the negative y axis.

Exemplary setup of a spot light:

```C#
var blueSpotLightComponent = new LightComponent() 
{ 
    Type = LightType.Spot, 
    Active = true, 
    Color = new float4(0, 0, 1, 1), 
    MaxDistance = 100, 
    OuterConeAngle = 25, 
    InnerConeAngle = 5
};

var blueSpotLight = new SceneNodeContainer()
{
    Name = "blueLight",
    Components = new List<SceneComponentContainer>()
    {
        new TransformComponent()
        { 
            Translation = new float3(-5, 10, 0),
            Rotation = new float3(M.DegreesToRadians(90), 0, 0)
        },
        blueSpotLightComponent,
    }
},
```

## Differences between forward and deferred rendering

> ⚠️ The **forward** rendering pipeline supports **eight** light sources at the most!  
 Further lights will simply not be rendered.   

In the deferred pipeline the number of lights is only limited by our hardware.

# Shadow

> ⚠️ Shadow casting is only available in the **deferred** pipeline!  
See the [Deferred Rendering Page](Deferred-Rendering) on how to use it.

FUSEE is able to render shadows for every light in the scene. For this the engine uses _Shadow Mapping_. In short this done as follows:

For every light source  

1. render a depth map (= shadow map) of the scene from the light's position. For spot and point lights this will be the position given in the ``TransformComponent``. For parallel lights it is calculated internally.

In the lighting pass  

2. transform the position into light space.
3. Check whether the position's z value is lesser or greater than the associated texel of the shadow map. If it is greater, this fragment lies in shadow.

For further information and OpenGL implementation details refer to this [tutorial](https://learnopengl.com/Advanced-Lighting/Shadows/Shadow-Mapping) on learnopengl.com.  

To enable shadow casting for a specific light, we need to set the property ``IsCastingShadows`` of the ``LightComponent`` to ``true``. Furthermore it may be possible to adjust the ``Bias`` of the ``LightComponent``.

## Bias

The bias can have a massive impact on the quality of the shadow. 

If it is too small it can lead to incorrect self shadowing or shadow acne.  
If it is to big, peter panning (the shadow isn't attached to associated object anymore) or light leaking can occur.

In the event that we do not see a shadow, but are sure that we have set all parameters of the light correctly, this may also be due to a incorrect bias. Try playing around with it to get the best results in terms of shadow quality.

## Shadow Map resolution

We can choose the resolution of the shadow maps in the ``SceneRendererDeferred`` by setting the value of ``ShadowMapRes``.  
The higher the resolution we choose the clearer the shadow will appear, because we have a better texel to fragment assignment (step three of the short description above).  
Keep in mind, that a higher resolution may have an impact on the performance of the application.

## Cascades Shadow Mapping - shadows for parallel lights

If we encounter bad quality shadows coming from parallel lights (like those seen in the picture below), it may help to increase the ``numberOfCascades`` in the ``SceneRendererDeferred``. This will increase the number of shadow maps that are created for each parallel light. A number to great may result in performance loss. 

### [TLDR] Background

As described above, parallel lights light the whole scene. In the basic shadow mapping algorithm we would have one shadow map with (in a worst case scenario) 512 x 512 pixel that needs to cover a big scene, maybe spanning several kilometers in world space - or at least the part of it, that is inside the viewing frustum, which can also have a big volume. This leads to shadows with a very bad quality as seen in the picture below.

![Un-cascaded shadow](https://raw.githubusercontent.com/wiki/FUSEEProjectTeam/Fusee/Images/Light-and-Shadow/noCascade.jpg)

We can also see, that the farther away a point is from our point of view, the less noticeable the bad quality gets. This leads to the idea of Cascaded Shadow Mapping.  

With this, the viewing frustum is split into _n_ cascades, here given by the ``numberOfCascades``. The algorithm used to split the frustum is [Parallel-Split Shadow Maps](https://developer.nvidia.com/gpugems/GPUGems3/gpugems3_ch10.html). 

For each cascade the algorithm calculates the axis aligned bounding box, which encloses the cascade. This bounding box is used as the (orthographic) viewing frustum for rendering the shadow map for this cascade. This results in shadow maps with a better texel to fragment assignment, because each shadow map only displays a subset of the scene. 

The picture below shows the cascades (C0 - C2) and the bounding boxes (green).

![Frustum and Cascades](https://raw.githubusercontent.com/wiki/FUSEEProjectTeam/Fusee/Images/Light-and-Shadow/cascades.png)

In the lighting pass, the shader determines the correct cascade for each fragment and calculates the shadow according to the shadow map associated with this cascade. Note that it is okay if the bounding boxes intersect, as long as the shader chooses one of the shadow maps.

In the case shown above the quality is improved significantly by using three cascades:

![Three cascades](https://raw.githubusercontent.com/wiki/FUSEEProjectTeam/Fusee/Images/Light-and-Shadow/threeCascades.jpg)


