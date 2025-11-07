@echo off
rem File: %~n0.bat
rem Purpose: Elevate (UAC) and start same-name .exe located next to this .bat, then exit
rem Author: takraztak
rem ==================================================================

setlocal enabledelayedexpansion

:: get base name and target exe path
set "SCRIPT_NAME=%~n0"
set "EXE=%~dp0%SCRIPT_NAME%.exe"

:: check elevation and relaunch elevated if needed
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { Start-Process -FilePath '%~f0' -Verb RunAs; exit 1 } else { exit 0 }"

if ERRORLEVEL 1 (
    :: we requested elevation and parent instance should exit
    exit /b
)

:: from here we are elevated
if not exist "%EXE%" (
    echo [%DATE% %TIME%] ERROR: "%EXE%" not found.
    echo [%DATE% %TIME%] Place "%SCRIPT_NAME%.exe" next to this .bat or rename accordingly.
    pause
    exit /b 2
)

:: start exe and close this bat immediately
echo [%DATE% %TIME%] Starting "%EXE%" %*
start "" "%EXE%" %*
exit /b 0
