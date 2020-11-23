@echo off
setlocal

SET OUTPUTPATH=%CD%\docs
SET DOCFX="%CD%\bin\DocFX\docfx.exe"

rd /s /q %OUTPUTPATH%
mkdir %OUTPUTPATH%

echo fusee3d.org > %OUTPUTPATH%\CNAME


%DOCFX% "%CD%\src\DocFX\docfx.json" -o "%OUTPUTPATH%"



endlocal
