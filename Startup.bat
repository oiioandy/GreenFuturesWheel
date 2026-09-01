@echo off
setlocal
cd /d "%~dp0"
title Green Futures Wheel
if not exist "%~dp0workshop-server.ps1" (
  echo workshop-server.ps1 is missing.
  echo Keep Startup.bat inside the GreenFuturesWheel-classroom folder.
  pause
  exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0workshop-server.ps1"
if errorlevel 1 pause