@ECHO off
@SET LUMEN_HOME=%~dp0

IF NOT "x%1" == "x" GOTO :%1

:all
CALL make bundle
if %errorlevel% neq 0 goto error
GOTO :end

:clean
set LUMEN_CWD=%CD%
cd "%LUMEN_HOME%bin"
IF EXIST lumen-language DEL /F /Q lumen-language
IF EXIST lumen-language.exe DEL /F /Q lumen-language.exe
IF EXIST lumen-node.exe DEL /F /Q lumen-node.exe
cd "%LUMEN_CWD%"
GOTO :end

:bundle
set LUMEN_ERROR=0
set LUMEN_CWD=%CD%
cd "%LUMEN_HOME%"
IF NOT EXIST bin\lumen-language.exe CALL npx luvit-luvi . -o bin\lumen-language.exe
if %errorlevel% neq 0 set LUMEN_ERROR=%errorlevel%
IF NOT EXIST bin\lumen-node.exe CALL npx pkg index.js -t win -o bin\lumen-node.exe
if %errorlevel% neq 0 set LUMEN_ERROR=%errorlevel%
cd "%LUMEN_HOME%bin"
IF NOT EXIST lumen-language CALL mklink /H lumen-language lumen-language.exe
if %errorlevel% neq 0 set LUMEN_ERROR=%errorlevel%
cd "%LUMEN_CWD%"
set errorlevel=%LUMEN_ERROR%
if %errorlevel% neq 0 goto error
GOTO :end

:test
CALL make all
set LUMEN_ERROR=0
ECHO node:
CALL "%LUEMN_HOME%bin\lumen-node" "%LUMEN_HOME%test.l"
if %errorlevel% neq 0 set LUMEN_ERROR=%errorlevel%
ECHO luvi:
SET LUA_PATH=%LUMEN_HOME%bin\?.lua;;%LUA_PATH%
CALL "%LUEMN_HOME%bin\lumen-language" "%LUMEN_HOME%test.l"
if %errorlevel% neq 0 set LUMEN_ERROR=%errorlevel%
set errorlevel=%LUMEN_ERROR%
if %errorlevel% neq 0 goto error
GOTO :end

:-B
:rebuild
CALL make clean
CALL make all
CALL make test
GOTO :end

:bootstrap
CALL make bundle
CALL make test
GOTO :end

:error
exit /b %errorlevel%

:end
