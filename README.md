# PingShift Download Repository (PUBLIC — production only)

Hosts **production release binaries** and the **production** Tauri auto-updater manifest.

Dev/beta builds live in the separate **private** repo `PingShift-Download-Dev`.

## Branches

| Branch | Audience | Manifest |
|--------|----------|----------|
| `prod` | Production users | `prod/latest.json` |
| `development` | Staging manifest drafts (optional) | — |

The desktop app checks `prod/latest.json` on startup and every 4 hours.

## Directory layout

```
prod/
  latest.json          # Production update manifest (required)
infra/installer/       # Inno Setup scripts (PingShift-Setup.exe)
```
## Publishing a production update

1. Build a signed release from **PingShift-Code** (`prod` branch):
   ```powershell
   npm run build:production
   ```
2. Find artifacts under `bundle/nsis/`:
   - `PingShift_x.y.z_x64-setup.nsis.zip` (or `.exe`)
   - Matching `.sig` file
3. Upload the installer to GitHub Releases (this repo) or your CDN.
4. Copy the **signature** from the `.sig` file into `prod/latest.json`.
5. Set `platforms.windows-x86_64.url` to the public HTTPS download URL.
6. Commit and push to the **`prod`** branch.

### latest.json format

```json
{
  "version": "0.2.0",
  "notes": "Fix Valorant routing after Vanguard update",
  "pub_date": "2026-06-09T12:00:00Z",
  "platforms": {
    "windows-x86_64": {
      "signature": "<contents of .sig file>",
      "url": "https://github.com/YOUR_ORG/PingShift-Download/releases/download/v0.2.0/PingShift_0.2.0_x64-setup.nsis.zip"
    }
  }
}
```

## First-time installer

Website `/download/windows` redirects to `pingshift-windows-installer.exe` (Inno Setup output from `infra/installer/`). Auto-updates take over after the first install.

## Security

- Never commit code-signing `.pfx` files or Tauri private keys (`.tauri/pingshift.key`).
- Only signed updates (matching pubkey in the desktop app) will install.
