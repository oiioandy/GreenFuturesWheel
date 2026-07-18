# Local Yjs WebSocket server for Future Wheel collaboration testing.
# Open the app via http://localhost (not file://) after starting.

$port = 4455
$listening = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue

if ($null -ne $listening) {
    Write-Host ""
    Write-Host "Port $port is already in use. Server may already be running." -ForegroundColor Yellow
    Write-Host "Open the Future Wheel in your browser; no need to start again." -ForegroundColor Green
    Write-Host ""
    exit 0
}

Write-Host "Starting Yjs WebSocket server at ws://localhost:$port"
Write-Host "Press Ctrl+C to stop."
$env:HOST = "localhost"
$env:PORT = "$port"
npx --yes @y/websocket-server