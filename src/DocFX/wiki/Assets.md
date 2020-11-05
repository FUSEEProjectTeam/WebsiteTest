 > ⚠️ **Pre-Release Content**  

# Assets

All Fusee assets should be stored within a folder named `Assets` usually inside the `Core` project folder. On build, all assets are being collected and copied to the correct output folder.

## Load an asset

There are several flavors to load an asset from code. For the simplest case Fusee provides the static method

```csharp
T AssetStorage.Load<T>(string id);
```

which freezes the main thread and therefore the program until the asset is present; after this, the asset is usable right away.

A little more enhanced is the possibility to load assets via the `async/await` pattern, where the asset loading is executed in a different thread and does therefore not block anything.

Fusee provides the static method

```csharp
Task<T> AssetStorage.LoadAsync<T>(string id);
```

which returns an awaitable `Task` which, on `await` delegates the current method into the background until the `Task` and therefore the asset loading is completed. Any potential commands after the call to `await`, of the now recurring method, are executed after this and the result is returned to the main thread. Note: one has to label the method in which the `await` call should be executed with the keyword `async`.

A full example could look like this:

```csharp
async void Init()
{
    var sceneLoaderTask =
    AssetStorage.LoadAsync<SceneContainer>("FuseeRocket.fus");

    var scene = await sceneLoaderTask;
    scene.Children[0].GetComponent<Transform>().x += 10;
}
```

If one has to load a lot of files at once Fusee provides the user furthermore with the following method:

```csharp
Task<T[]> AssetStorage.GetAssetsAsync<T>(IEnumerable<string> ids);
```

## Check status of assets

When using the `async/await` pattern, a user usually wants to check if all files the `AssetStorage` should load are present:

```csharp
bool AssetsStorage.AllAssetsFinishedLoading { get; }
```

Furthermore, the method

```csharp
bool AssetStorage.IsAssetPresent(string id);
```

helps to check if an asset is enqueued for loading or already present.

Attention, this is independent of any failed or success state!

For this use the method

```csharp
bool AssetStorage.IsAssetLoaded(string id)
```

which returns `true` only upon a successful and complete load.

## Implementing an asset decoder

For convenience, Fusee already implements the file handling logic for a few selected file types (images, text, fonts, SceneContainer) within the examples. Usually, this is done once per build target (Desktop, Android, etc.) via the creation of an `AssetHandler` in which the information on how to decode and handle a filetype is deposited. All `AssetHandler`s are then registered at a `FileAssetProvider` which itself is registered at the `AssetStorage`,  eventually.
The `FileAssetStorage` is platform-specific, too, and provides the logic on how to read a file from the build target's file storage.

A full example could look like this

```csharp
// Create an AssetHandler to load text files
var assetHandler = new AssetHandler
{
    // we want to return a string type
    ReturnedType = typeof(String),
    // implement the blocking decoder method
    Decoder = (string id, object storage) =>
    {
        var stream = (Stream)storage;
        Console.WriteLine("Hello from AH!");
        return storage.ReadToEnd();
    },
    // implement the async non-blocking decoder method
    DecoderAsync = (string id, object storage) =>
    {
       var stream = (Stream)storage;
       return storage.ReadToEndAsync();
    },
    // is the file there, then try to load and handle it
    Checker = id => File.Exists(id)
});

// create platform specific FileAssetProvider
// this one looks for assets in the folder "Assets"
var fap = new Fusee.Base.Imp.Desktop.FileAssetProvider("Assets");

// register our handler
fap.RegisterTypeHandler(assetHandler);

// register the provider
AssetStorage.RegisterProvider(fap);

// a call to Get<string> now selects our self-written asset handler as encoder
var t = AssetStorage.Get<string>("hello.txt");
Console.WriteLine(t);

//
//  Output:
//  ---------
//  Hello from AH!
//  [Content of hello.txt]
//

```