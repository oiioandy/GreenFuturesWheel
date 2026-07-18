@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

netstat -ano | findstr ":4455.*LISTENING" >nul
if %errorlevel%==0 (
  echo.
  echo Port 4455 is already in use. Server may already be running.
  echo Open the Future Wheel in your browser; no need to start again.
  echo.
  pause
  exit /b 0
)

echo Starting Yjs WebSocket server at ws://localhost:4455 ...
echo Press Ctrl+C to stop.
set HOST=localhost
set PORT=4455
npx --yes @y/websocket-server
pause