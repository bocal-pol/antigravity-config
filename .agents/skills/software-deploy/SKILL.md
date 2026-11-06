---
name: software-deploy
description: Software deployment in a Windows enterprise environment — Intune, SCCM, GPO Software Installation, MSI/EXE packages, PowerShell scripting. Tests and rollback. Pre-check incident-pattern.
model: claude-sonnet-5
user-invocable: true
aliases: ["/deploy"]
argument-hint: "<software> [target: machine|group|OU|domain] [mode: msi|exe|winget|intune|sccm|gpo]"
type: framework
priority: medium
scope: backend
dependencies:
  - incident-pattern
conflicts: []
---

# Software Deploy — Enterprise Software Deployment

Deployment and management of software across the Windows fleet, from a single machine to mass
rollout.

## Automatic pre-check

Invoke `incident-pattern` if the deployment involves multiple machines or shared software.

## Deployment methods

### Local installation
```powershell
# Silent MSI
msiexec /i "setup.msi" /qn /norestart ALLUSERS=1

# Silent EXE (common format)
Start-Process -FilePath "setup.exe" -ArgumentList "/S /norestart" -Wait

# Winget (Windows Package Manager)
winget install --id Publisher.AppName --silent --accept-package-agreements
```

### Multi-machine PowerShell scripting
```powershell
# Deploy across a list of machines
$computers = Get-Content "computers.txt"
$computers | ForEach-Object {
    Invoke-Command -ComputerName $_ -ScriptBlock {
        Start-Process msiexec -ArgumentList "/i \\server\share\app.msi /qn" -Wait
    }
}
```

### GPO Software Installation
- MMC GPMC → GPO → Computer/User Configuration → Software Settings → Software Installation
- MSI package required (not EXE)
- Prefer "Assigned" (computer) for critical software

### Intune / Microsoft Endpoint Manager
- Package type: Win32 App (intunewin), MSI line-of-business
- Detection: file path, registry, or MSI Product Code
- Targeting rules: Azure AD groups

## Uninstall / Rollback

```powershell
# Uninstall by GUID
msiexec /x "{GUID}" /qn

# Uninstall via winget
winget uninstall --id Publisher.AppName --silent
```

## Optional logging

Call `security-bulletin-service append` at the end of the intervention.
