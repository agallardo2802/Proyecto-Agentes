@echo off
setlocal

REM GGS Agents Windows launcher.
REM Usage:
REM   install-windows.cmd              installs for opencode
REM   install-windows.cmd codex        installs for codex
REM   install-windows.cmd claude       installs for claude
REM   install-windows.cmd opencode -SkipPrerequisites

set "SCRIPT_DIR=%~dp0"
set "AGENT=%~1"

if "%AGENT%"=="" set "AGENT=opencode"

shift /1

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%scripts\install.ps1" -Agent "%AGENT%" %*
set "EXITCODE=%ERRORLEVEL%"

echo.
if not "%EXITCODE%"=="0" (
  echo Instalacion finalizo con error. Codigo: %EXITCODE%
) else (
  echo Instalacion finalizada correctamente.
)
echo.
pause
exit /b %EXITCODE%
