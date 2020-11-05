# Logging

Logging is implemented within `Fusee.Base.Core.Diagnostics.cs`.

- [1. Log levels](#1-log-levels)
   - [1.1 Examples](#11-examples)
- [2. Format](#2-format)
   - [2.1 Example](#21-example)
- [3. Log targets](#3-log-targets)
- [4. Targets and severity levels with different build configurations](#4-targets-and-severity-levels-with-different-build-configurations)
   - [4.1 Examples](#41-examples)

## 1. Log levels

The following log levels are usable:

- `Diagnostics.Debug` (used for generic, short, debug messages) 
- `Diagnostics.Info` (used for messages that should be displayed in debug, as well as release builds)
- `Diagnostics.Warning` (used for warning messages, which do not lead to any crashes)
- `Diagnostics.Error` (used for fatal errors, e. g. exceptions)
- ~~`Diagnostics.Log`~~ (obsolete, legacy logging)

with these parameters:
- `object msg`, the debug message (`.ToString()` is called within this method)
- `Exception ex`, a possible exception (can be `null`)
- `object[] args`, additional arguments that can and/or should be displayed during logging (can be `null`)



## 1.1 Examples

### 1.1.1 Debug

```C#
var t = float4x4.Identity;
Diagnostics.Debug("Identity matrix created");
```

### 1.1.2 Warning (with args)

```C#
var invMat = float4x4.Invert(mat);
var invMat2 = float4x4.Invert(mat2);
if(invMat.Equals(mat) && invMat2.Equals(mat2))
    Diagnostics.Warn($"The following matrices could not be inverted!", null, new float4x4[] { mat, mat2 });
```

### 1.1.3 Error (with exception and args)

```C#
try 
{
   var compiledShader = CreateShader(ef.VertexShaderSrc, ef.PixelShaderSrc);
}
catch(Exception ex)
{
    Diagnostics.Error("Error while compiling the shader.", ex, new string[] { ef.VertexShaderSrc, ef.PixelShaderSrc });
}
```



## 2. Format

Per default each debug message follows this pattern:

>  ```[CallingMethod():LineNumber] Message```

everything else (warning, error, etc.):

> ```DD.MM.YYYY HH:MM:SS, [SeverityLevel] [FileName.cs] [CallingMethod():LineNumber] Message```

One can overwrite the format of every log message by setting the `Formater` delegate via `SetFormat(Formater formater)`.

### 2.1 Example
```C#
Diagnostics.SetFormat((caller, lineNmbr, sourceFile, logLvl, msg, ex, args) => {

    var l = $"{sourceFile} said: within my method {caller} at the line number {lineNmbr}, the following message, with the severity level {logLvl} appeared: {msg}.";

    if (ex != null)
        l += $"\nOh no, a wild exception appears: {ex}";

    return l;
});
```
### 3. Log targets

There are three log targets:
- Console output
- Debug output (where System.Diagnostics.Debug writes its' output) 
- File

Console and debug output are enabled by default. The file target is disabled and can be activated with `Diagnostics.LogToTextFile(bool log, string logFileName = "")`. 

## 4. Targets and severity levels with different build configurations

Within a _debug build_, every log message is displayed for every available target.
A _release build_ also displays every log message per default but the `Diagnostics.Debug()` method is removed completely.

Furthermore, one can adapt every minimal log level for every target with the following three methods:
- `Diagnostics.SetMinConsoleLoggingSeverityLevel(lvl)`
- `Diagnostics.SetMinDebugOutputLoggingSeverityLevel(lvl)`
- `Diagnostics.SetMinTextFileLoggingSeverityLevel(lvl)`


> 💡 **Note:** this does not bring back the output of the `Diagnostics.Debug()` method within a release build! This functionality is implemented differently with the help of pre-compiler flags.


### 4.1 Examples

#### 4.1.1 Display no debug messages on the console

```C#
Diagnostics.SetMinConsoleLoggingSeverityLevel(SeverityLevel.INFO);
```

#### 4.1.2 Display only error messages on the console and display no debug messages on the debug output

```C#
Diagnostics.SetMinConsoleLoggingSeverityLevel(SeverityLevel.ERROR);
Diagnostics.SetMinDebugOutputLoggingSeverityLevel(SeverityLevel.INFO);
```

#### 4.1.3 Display nothing on the console and display only warning and error messages on the debug output

```C#
Diagnostics.SetMinConsoleLoggingSeverityLevel(SeverityLevel.NONE);
Diagnostics.SetMinDebugOutputLoggingSeverityLevel(SeverityLevel.WARN);
```

#### 4.1.4 Enable file logging for warnings and errors, display no debug messages on the console

```C#
// enable file logging to Fusee.Log.txt
Diagnostics.LogToTextFile(true, "Fusee.Log.txt"); 
// log warnings and errors to file 
Diagnostics.SetMinTextFileLoggingSeverityLevel(SeverityLevel.WARN); 

// disable debug output on console
Diagnostics.SetMinConsoleLoggingSeverityLevel(SeverityLevel.INFO); 
// display everything within the debug output target
Diagnostics.SetMinDebugOutputLoggingSeverityLevel(SeverityLevel.DEBUG); // this is also the default value
```

> 💡 **Note:**   file logging is currently not supported for android and produces a `NotImplementedException()`


---


> 👷 **Engine Developer:** for more information browse [Diagnostics.cs](https://github.com/FUSEEProjectTeam/Fusee/blob/develop/src/Base/Core/Diagnostics.cs)





 