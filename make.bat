@ECHO off
@SET LUMEN_VERSION=0.0.2
@SET LUMEN_HOME=%~dp0

IF NOT "x%1" == "x" GOTO :%1

:all
IF NOT EXIST bin\lumen-language.exe CALL make.bat all
ECHO "Building lumen"
npx -p luvit luvi . -o bin\lumen-language.exe
if %errorlevel% neq 0 goto error
IF NOT EXIST bin\lumen-language CALL mklink /H bin\lumen-language bin\lumen-language.exe
if %errorlevel% neq 0 goto error
GOTO :end

:test
IF NOT EXIST bin\lumen-language.exe CALL make.bat all
ECHO "Testing lumen"
SET PREV_LUA_PATH=%LUA_PATH%
SET LUA_PATH=%LUMEN_HOME%bin\?.lua;;%LUA_PATH%
"%LUMEN_HOME%bin\lumen-language.exe" "%LUMEN_HOME%test.l"
if %errorlevel% neq 0 goto error
SET LUA_PATH=%PREV_LUA_PATH%
GOTO :end

:clean
IF EXIST bin\lumen-language.exe DEL /F /Q bin\lumen-language.exe
IF EXIST bin\lumen-language DEL /F /Q bin\lumen-language

:error
exit /b %errorlevel%

:end
