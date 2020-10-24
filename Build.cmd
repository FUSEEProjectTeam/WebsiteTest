@echo off
setlocal

SET ROOT=%CD%
SET OUTPUTPATH=%CD%\docs
SET BASEURL=https://fuseeprojectteam.github.io/WebsiteTest/

SET FUSEESRC=../Fusee/src

SET DOCFX="%CD%\bin\DocFX\docfx.exe"
SET HUGO="%CD%\bin\Hugo\hugo.exe"

%DOCFX% "%CD%\src\DocFX\docfx.json" -o "%OUTPUTPATH%"

rem %HUGO% --destination %OUTPUTPATH% --theme=beautifulhugo --baseURL %BASEURL% --cleanDestinationDir -s .\src\Hugo




endlocal
