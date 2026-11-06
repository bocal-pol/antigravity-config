---
name: ad-basic
description: Active Directory — user account, group, and OU management, password reset, unlock, expiration, membership audit. Unrestricted AD PowerShell.
model: claude-sonnet-5
user-invocable: true
aliases: ["/ad"]
argument-hint: "[action: reset|unlock|create|disable|move|audit] [username or OU]"
type: framework
priority: high
scope: backend
dependencies: []
conflicts: []
---

# AD Basic — Enterprise Active Directory

Managing accounts and Active Directory objects in a Windows Server / Azure AD environment.

## Frequent actions

### User accounts
```powershell
# Reset the password
Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString "TempP@ss!" -AsPlainText -Force)
Set-ADUser -Identity $user -ChangePasswordAtLogon $true

# Unlock an account
Unlock-ADAccount -Identity $user

# Disable / enable
Disable-ADAccount -Identity $user
Enable-ADAccount -Identity $user

# Audit an account
Get-ADUser -Identity $user -Properties * | Select-Object Name,SamAccountName,Enabled,LockedOut,LastLogonDate,PasswordExpired,MemberOf

# Move to an OU
Move-ADObject -Identity $dn -TargetPath "OU=DeactivatedUsers,DC=corp,DC=local"
```

### Groups
```powershell
# Members of a group
Get-ADGroupMember -Identity $group | Select-Object Name,SamAccountName

# Groups of a user
Get-ADUser -Identity $user -Properties MemberOf | Select-Object -ExpandProperty MemberOf

# Add / remove
Add-ADGroupMember -Identity $group -Members $user
Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
```

### Membership audit (conflicting identities or excessive rights)
```powershell
# Active accounts in OU X
Get-ADUser -Filter {Enabled -eq $true} -SearchBase "OU=Staff,DC=corp,DC=local" -Properties LastLogonDate | Where-Object {$_.LastLogonDate -lt (Get-Date).AddDays(-90)}
```

### Service accounts
```powershell
# List service accounts
Get-ADUser -Filter {Description -like "*service*"} -Properties Description,PasswordNeverExpires
```

## Optional logging

Call `security-bulletin-service append` at the end of an intervention.
