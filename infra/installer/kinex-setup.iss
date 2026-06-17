; PingShift installer — bundle GUI + routing daemon (requires Inno Setup 6).
; Build PingShift-Code first, then compile this script from PingShift-Download.
; Override output dir: iscc /DBuildOutputDir=C:\path\to\release kinex-setup.iss

#ifndef BuildOutputDir
  #define BuildOutputDir "..\..\..\kinex-desktop\src-tauri\target\release"
#endif

#define MyAppName "PingShift"
#define MyAppVersion "0.1.0"
#define MyAppPublisher "Vodvisor LLC"
#define MyAppExeName "PingShift.exe"
#define MyDaemonExeName "pingshift-daemon.exe"

[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\PingShift
DefaultGroupName=PingShift
OutputDir=dist
OutputBaseFilename=PingShift-Setup
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=admin

[Files]
Source: "{#BuildOutputDir}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildOutputDir}\{#MyDaemonExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "install-service.ps1"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\PingShift"; Filename: "{app}\{#MyAppExeName}"

[Run]
; Install routing service directly — no PowerShell flash.
Filename: "{app}\pingshift-routing-service.exe"; Parameters: "--install"; Flags: runhidden waituntilterminated; StatusMsg: "Installing PingShift Routing service..."

[Code]
; SignTool=signtool sign /fd SHA256 /a /tr http://timestamp.digicert.com /td SHA256 $f
