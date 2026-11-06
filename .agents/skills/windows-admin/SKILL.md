---
name: windows-admin
description: Windows Server and enterprise workstation administration — GPO, WSUS, shares, services, registry, optimization, PowerShell administration scripts. Full unrestricted access.
model: claude-sonnet-5
user-invocable: true
aliases: ["/winadm"]
argument-hint: "[target: workstation|server|domain] [action]"
type: framework
priority: high
scope: backend
dependencies:
  - incident-pattern
conflicts: []
---

# Windows Admin — Enterprise Windows Administration

Administration of Windows Server (2016/2019/2022) and Windows 10/11 workstations in an Active Directory environment.

## Automatic pre-check

Invoke `incident-pattern` if the request concerns multiple workstations or a shared service.

## Covered domains

### GPO (Group Policy)
- GPO creation, modification, linking
- Diagnostics: `gpresult /R`, `gpupdate /force`
- Resulting GPO on a user/workstation

### WSUS / Updates
- Update validation
- Exclusions
- Fleet status report

### Shares and permissions
- SMB shares: `Get-SmbShare`, `New-SmbShare`
- NTFS permissions: `icacls`, `Get-Acl`
- Access auditing

### Services and processes
- Windows service management
- Start/stop scripts
- Task Scheduler

### Registry
- Reading/writing keys via PowerShell
- Deploying values via GPO

### Administration scripts
- PowerShell remoting (WinRM)
- Execution across a workstation fleet
- Quick inventory report

## Common system tools

```powershell
# Quick workstation audit
systeminfo | Select-String "OS\|Hostname\|RAM\|Hotfix"
Get-WmiObject -Class Win32_ComputerSystem
# Force GPO
Invoke-GPUpdate -Computer $hostname -RandomDelayInMinutes 0
```

## Optional save

Call `bulletin-service append` at the end of the intervention.
