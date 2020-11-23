@echo off
setlocal

SET OUTPUTPATH=%CD%\docs
SET DOCFX="%CD%\bin\DocFX\docfx.exe"
SET GHWSTDFX="%CD%\bin\GitHubWikiSidbarToDocFX\GitHubWikiSidbarToDocFX.exe"

rd /s /q %OUTPUTPATH%
mkdir %OUTPUTPATH%

if not x%CD:Test=%==x%CD% goto SkipCNAME
if not x%CD:New=%==x%CD% goto SkipCNAME

echo fusee3d.org > %OUTPUTPATH%\CNAME

:SkipCNAME

rem %GHWSTDFX% docfx_project\wiki\_Sidebar.md docfx_project\wiki
%DOCFX% docfx_project\docfx.json

endlocal