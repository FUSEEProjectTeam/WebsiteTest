@echo off
setlocal

SET BUILDPATH=".\docs"
SET BASEURL="https://fuseeprojectteam.github.io/WebsiteTest/"

SET HUGO=".\bin\Hugo\hugo.exe"

%HUGO% --destination %BUILDPATH% --theme=beautifulhugo --baseURL %BASEURL% --cleanDestinationDir -s .\src\Hugo

endlocal