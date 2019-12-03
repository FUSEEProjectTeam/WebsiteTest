@echo off
setlocal

SET ROOT=%CD%
SET BUILDPATH="%CD%\docs"
SET BASEURL="https://fuseeprojectteam.github.io/WebsiteTest/"

SET HUGO="%CD%\bin\Hugo\hugo.exe"

%HUGO% --destination %BUILDPATH% --theme=beautifulhugo --baseURL %BASEURL% --cleanDestinationDir -s .\src\Hugo

endlocal