# Workshop host for the Green Futures Wheel. No Node, no extra install.
# Serves the folder on the LAN so devices on the same Wi-Fi can open the page.

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
try { chcp 65001 > $null } catch { }

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

function Read-AppVersion {
  $file = Join-Path $root 'VERSION.txt'
  if (Test-Path $file) {
    foreach ($line in Get-Content -Path $file -ErrorAction SilentlyContinue) {
      if ($line -match '^\s*BuildDisplay:\s*(.+)\s*$') { return $Matches[1].Trim() }
      if ($line -match '^\s*Version:\s*(.+)\s*$') { return $Matches[1].Trim() }
    }
  }
  return '2026.09.01.02'
}

function Read-RoomId {
  $file = Join-Path $root 'workshop-room.txt'
  $room = '2026'
  if (Test-Path $file) {
    $raw = (Get-Content -Path $file -TotalCount 1 -ErrorAction SilentlyContinue)
    if ($raw) { $room = $raw.ToString().Trim() }
  }
  if ($room -notmatch '^\d{4}$') { $room = '2026' }
  return $room
}

function Get-LanIPv4 {
  try {
    $cfgs = Get-NetIPConfiguration -ErrorAction SilentlyContinue | Where-Object {
      $_.IPv4DefaultGateway -and $_.NetAdapter.Status -eq 'Up'
    }
    foreach ($cfg in $cfgs) {
      $ip = $cfg.IPv4Address.IPAddress
      if ($ip -is [array]) { $ip = $ip[0] }
      if ($ip -and $ip -notlike '127.*' -and $ip -notlike '169.254.*') { return [string]$ip }
    }
  } catch { }

  $found = [System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) |
    Where-Object { $_.AddressFamily -eq 'InterNetwork' -and $_.ToString() -notlike '127.*' -and $_.ToString() -notlike '169.254.*' }
  if ($found) { return $found[0].ToString() }
  return $null
}

function Test-PortFree([int]$port) {
  try {
    $probe = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $port)
    $probe.Start()
    $probe.Stop()
    return $true
  } catch {
    return $false
  }
}

function Find-Port {
  foreach ($p in 3456, 4173, 8080, 5500) {
    if (Test-PortFree $p) { return $p }
  }
  return 3456
}

function Try-OpenFirewall([int]$port) {
  try {
    $name = "FuturesWheelWorkshop$port"
    $existing = netsh advfirewall firewall show rule name=$name 2>$null
    if ($existing -and ($existing -match $name)) { return }
    Start-Process -FilePath 'netsh' -ArgumentList @(
      'advfirewall', 'firewall', 'add', 'rule',
      "name=$name", 'dir=in', 'action=allow', 'protocol=TCP', "localport=$port",
      'profile=private,public'
    ) -WindowStyle Hidden -Wait -ErrorAction SilentlyContinue | Out-Null
  } catch { }
}

$csharp = @'
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

public static class WorkshopHttp {
  static volatile bool running = true;
  static TcpListener listener;

  public static void Stop() {
    running = false;
    try { if (listener != null) listener.Stop(); } catch {}
  }

  public static void Start(string root, int port) {
    Thread t = new Thread(() => Run(root, port));
    t.IsBackground = true;
    t.Start();
  }

  public static void Run(string root, int port) {
    listener = new TcpListener(IPAddress.Any, port);
    listener.Start();
    while (running) {
      TcpClient client;
      try { client = listener.AcceptTcpClient(); }
      catch { break; }
      ThreadPool.QueueUserWorkItem(delegate { Serve(client, root); });
    }
  }

  static string Mime(string ext) {
    ext = (ext ?? "").ToLowerInvariant();
    if (ext == ".html") return "text/html; charset=utf-8";
    if (ext == ".css") return "text/css; charset=utf-8";
    if (ext == ".js") return "application/javascript; charset=utf-8";
    if (ext == ".svg") return "image/svg+xml";
    if (ext == ".json") return "application/json; charset=utf-8";
    if (ext == ".txt") return "text/plain; charset=utf-8";
    if (ext == ".png") return "image/png";
    if (ext == ".jpg" || ext == ".jpeg") return "image/jpeg";
    if (ext == ".ico") return "image/x-icon";
    if (ext == ".woff") return "font/woff";
    if (ext == ".woff2") return "font/woff2";
    return "application/octet-stream";
  }

  static void Serve(TcpClient client, string root) {
    try {
      client.ReceiveTimeout = 8000;
      client.SendTimeout = 15000;
      NetworkStream stream = client.GetStream();
      byte[] buf = new byte[16384];
      int n = stream.Read(buf, 0, buf.Length);
      if (n <= 0) return;
      string text = Encoding.ASCII.GetString(buf, 0, n);
      string first = text.Split(new string[] { "\r\n" }, 2, StringSplitOptions.None)[0];
      string[] parts = first.Split(' ');
      if (parts.Length < 2) return;
      string raw = parts[1];
      int q = raw.IndexOf('?');
      string path = q >= 0 ? raw.Substring(0, q) : raw;
      path = Uri.UnescapeDataString(path);
      if (path == "/" || path == "") path = "/index.html";
      path = path.TrimStart('/').Replace('/', Path.DirectorySeparatorChar);
      string full = Path.GetFullPath(Path.Combine(root, path));
      string rootFull = Path.GetFullPath(root);
      if (!full.StartsWith(rootFull, StringComparison.OrdinalIgnoreCase) || !File.Exists(full)) {
        WriteResp(stream, "404 Not Found", "text/plain; charset=utf-8", Encoding.UTF8.GetBytes("Not found"));
        return;
      }
      byte[] data = File.ReadAllBytes(full);
      WriteResp(stream, "200 OK", Mime(Path.GetExtension(full)), data);
    } catch {
    } finally {
      try { client.Close(); } catch {}
    }
  }

  static void WriteResp(NetworkStream stream, string status, string mime, byte[] data) {
    string header = "HTTP/1.1 " + status + "\r\n" +
      "Content-Type: " + mime + "\r\n" +
      "Content-Length: " + data.Length + "\r\n" +
      "Connection: close\r\n" +
      "Access-Control-Allow-Origin: *\r\n\r\n";
    byte[] hb = Encoding.ASCII.GetBytes(header);
    stream.Write(hb, 0, hb.Length);
    stream.Write(data, 0, data.Length);
    stream.Flush();
  }
}
'@

if (-not ([System.Management.Automation.PSTypeName]'WorkshopHttp').Type) {
  Add-Type -TypeDefinition $csharp -Language CSharp
}

$appVersion = Read-AppVersion
$room = Read-RoomId
$port = Find-Port
$lanIp = Get-LanIPv4
$localUrl = "http://127.0.0.1:${port}/?room=$room"
$shareUrl = if ($lanIp) { "http://${lanIp}:${port}/?room=$room" } else { $localUrl }

Try-OpenFirewall $port

try {
  [WorkshopHttp]::Start($root, $port)
  Start-Sleep -Milliseconds 400
} catch {
  Write-Host ''
  Write-Host 'This computer could not open the room. Copy the whole folder again, or try another PC.' -ForegroundColor Yellow
  Write-Host $_.Exception.Message
  Write-Host ''
  Read-Host 'Press Enter to close'
  exit 1
}

try { Set-Clipboard -Value $shareUrl } catch { }

Clear-Host
Write-Host ''
Write-Host '  Green Futures Wheel' -ForegroundColor Green
Write-Host "  $appVersion"
Write-Host '  ----------------------------------------'
Write-Host "  Room: $room"
Write-Host ''
Write-Host '  Join the same Wi-Fi, then open:' -ForegroundColor Yellow
Write-Host ''
Write-Host "      $shareUrl" -ForegroundColor Cyan
Write-Host ''
Write-Host '  This URL is on the clipboard. Paste it onto a slide if you need to.'
Write-Host '  Do not close this window.'
Write-Host '  If Windows asks to allow access, choose Allow.'
Write-Host '  Close this window when the workshop ends.'
Write-Host '  ----------------------------------------'
Write-Host ''

Start-Process $shareUrl

try {
  while ($true) { Start-Sleep -Seconds 1 }
} finally {
  try { [WorkshopHttp]::Stop() } catch { }
}
