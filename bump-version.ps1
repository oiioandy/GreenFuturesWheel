# Bump BuildDisplay like oiioMobile: yyyy.MM.dd.NN (Asia/Taipei).
# Same day: VersionCode +1, BuildDaySeq +1 (01-99).
# New day: VersionCode +1, BuildDaySeq back to 1.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$versionFile = Join-Path $root 'VERSION.txt'
$tz = [TimeZoneInfo]::FindSystemTimeZoneById('Taipei Standard Time')
$today = [TimeZoneInfo]::ConvertTime([DateTime]::UtcNow, $tz).ToString('yyyy.MM.dd')

$seq = 1
$code = 1
$prevDate = $null
if (Test-Path $versionFile) {
  foreach ($line in Get-Content -Path $versionFile) {
    if ($line -match '^\s*BuildDaySeq:\s*(\d+)\s*$') { $seq = [int]$Matches[1] }
    if ($line -match '^\s*VersionCode:\s*(\d+)\s*$') { $code = [int]$Matches[1] }
    if ($line -match '^\s*BuildDisplay:\s*(\d{4}\.\d{2}\.\d{2})\.(\d{2})\s*$') {
      $prevDate = $Matches[1]
      $seq = [int]$Matches[2]
    }
  }
  if ($prevDate -eq $today) { $seq++ } else { $seq = 1 }
  $code++
}

if ($seq -lt 1 -or $seq -gt 99) { throw "BuildDaySeq must be 1-99, got $seq" }
$display = '{0}.{1}' -f $today, $seq.ToString('00')
$iso = $today.Replace('.', '-')

@(
  'Name: Green Futures Wheel'
  "BuildDisplay: $display"
  "BuildDaySeq: $seq"
  "VersionCode: $code"
) | Set-Content -Path $versionFile -Encoding ascii

$index = Join-Path $root 'index.html'
$html = [System.IO.File]::ReadAllText($index)
$html = [regex]::Replace($html, '(<meta name="application-version" content=")[^"]+(")', "`${1}$display`${2}")
$html = [regex]::Replace($html, "(const APP_VERSION = ')[^']+(')", "`${1}$display`${2}")
$html = [regex]::Replace($html, "(const APP_VERSION_DATE = ')[^']+(')", "`${1}$iso`${2}")
$html = [regex]::Replace($html, '(id="app-version">)[^<]+(</p>)', "`${1}$display`${2}")
[System.IO.File]::WriteAllText($index, $html)

$notice = Join-Path $root 'NOTICE'
if (Test-Path $notice) {
  $n = [System.IO.File]::ReadAllText($notice)
  $n = [regex]::Replace($n, '(?m)^\d{4}\.\d{2}\.\d{2}\.\d{2}\s*$', $display)
  [System.IO.File]::WriteAllText($notice, $n)
}

$readme = Join-Path $root 'dist\GreenFuturesWheel-classroom\README.txt'
if (Test-Path $readme) {
  $r = [System.IO.File]::ReadAllText($readme)
  $r = [regex]::Replace($r, '(?m)^\d{4}\.\d{2}\.\d{2}\.\d{2}\s*$', $display, 1)
  [System.IO.File]::WriteAllText($readme, $r)
}

$ps1 = Join-Path $root 'workshop-server.ps1'
$ps = [System.IO.File]::ReadAllText($ps1)
$ps = [regex]::Replace($ps, "(return ')[^']+(')", "`${1}$display`${2}", 1)
[System.IO.File]::WriteAllText($ps1, $ps)

Write-Host $display
Write-Host "VersionCode $code  BuildDaySeq $seq"
