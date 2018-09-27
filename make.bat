@ECHO off
@SET LUMEN_HOME=%~dp0
@SET LUMEN=%LUMEN_HOME%bin\lumen-language

IF NOT "x%1" == "x" GOTO :%1

:clean
IF EXIST "%LUMEN%" DEL /F /Q "%LUMEN%"
IF EXIST "%LUMEN%.exe" DEL /F /Q "%LUMEN%.exe"
GOTO :end

:all
CALL make.bat bundle
if %errorlevel% neq 0 goto error
GOTO :end

:rebuild
CALL make.bat clean
CALL make.bat all
CALL make.bat test
GOTO :end

:bundle
IF NOT EXIST "%LUMEN%.exe" CALL npx -p luvit luvi . -o "%LUMEN%.exe"
if %errorlevel% neq 0 goto error
IF NOT EXIST "%LUMEN%" CALL mklink /H "%LUMEN%" "%LUMEN%".exe
if %errorlevel% neq 0 goto error
GOTO :end

:test
CALL make.bat all
ECHO node:
node "%LUMEN_HOME%index.js" "%LUMEN_HOME%test.l"
if %errorlevel% neq 0 goto error
ECHO luvi:
SET LUA_PATH=%LUMEN_HOME%bin\?.lua;;%LUA_PATH%
"%LUMEN_HOME%bin\lumen-language.exe" "%LUMEN_HOME%test.l"
if %errorlevel% neq 0 goto error
GOTO :end

:error
exit /b %errorlevel%

:end
