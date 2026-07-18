@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

set PORT=3456
echo.
echo Future Wheel - local web server
echo Open: http://localhost:%PORT%/index.html
echo.
echo Press Ctrl+C to stop this window.
echo.

start "" "http://localhost:%PORT%/index.html"
npx --yes serve -l %PORT% .