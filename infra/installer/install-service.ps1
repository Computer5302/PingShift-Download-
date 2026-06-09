# Installs kinex-daemon as a Windows service (Administrator).
# Requires NSSM: https://nssm.cc/download — place nssm.exe next to this script or in PATH.

param(
  [string]$InstallDir = $PSScriptRoot
)

$ErrorActionPreference = "Stop"
$daemonExe = Join-Path $InstallDir "pingshift-daemon.exe"
if (-not (Test-Path $daemonExe)) {
  $daemonExe = Join-Path $InstallDir "kinex-daemon.exe"
}
$nssm = Get-Command nssm -ErrorAction SilentlyContinue

if (-not (Test-Path $daemonExe)) {
  Write-Error "kinex-daemon.exe not found at $daemonExe"
}

if (-not $nssm) {
  Write-Warning "NSSM not found. Install manually: sc create KinexDaemon binPath= `"$daemonExe`" start= auto"
  exit 0
}

& nssm stop KinexDaemon 2>$null
& nssm remove KinexDaemon confirm 2>$null
& nssm install KinexDaemon $daemonExe
& nssm set KinexDaemon AppDirectory $InstallDir
& nssm set KinexDaemon DisplayName "PingShift Routing Service"
& nssm set KinexDaemon Description "WireGuard + WFP split tunnel service for PingShift"
& nssm set KinexDaemon Start SERVICE_AUTO_START
& nssm start KinexDaemon
Write-Host "KinexDaemon service installed and started."
