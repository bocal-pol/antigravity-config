---
name: printer-support
description: Network and local printer support — stuck print queue, drivers, missing network printers, slow printing, configuration errors, GPO deployment. incident-pattern pre-check.
model: claude-sonnet-5
user-invocable: true
aliases: ["/print"]
argument-hint: "<symptom or printer name>"
type: framework
priority: medium
scope: backend
dependencies:
  - incident-pattern
conflicts: []
---

# Printer Support — Enterprise Printer Support

Support for printing issues in a Windows environment with a print server or direct network printers.

## Automatic pre-check

Invoke `incident-pattern` — if several users report the same printer, it's probably an infrastructure issue (print server, network, global queue).

## Quick diagnosis

```powershell
# Spooler status
Get-Service -Name Spooler | Select-Object Status

# List the machine's printers
Get-Printer | Select-Object Name,DriverName,PortName,PrinterStatus

# Print queue
Get-PrintJob -PrinterName $printer

# Clear the queue (stuck jobs)
Get-PrintJob -PrinterName $printer | Remove-PrintJob
```

## Common actions

### Stuck print queue
```powershell
Stop-Service -Name Spooler -Force
Remove-Item "$env:SystemRoot\system32\spool\PRINTERS\*" -ErrorAction SilentlyContinue
Start-Service -Name Spooler
```

### Reinstalling a driver
```powershell
# Remove the current driver
Remove-PrinterDriver -Name $driverName -ErrorAction SilentlyContinue
# Reinstall from the print server
Add-Printer -ConnectionName "\\printserver\$printerName"
```

### Missing network printer
- Check IP connectivity: `Test-NetConnection -ComputerName $printerIP -Port 9100`
- Check the DHCP reservation if the IP is dynamic
- Redeploy via GPO if applicable

### GPO deployment
- GPO Computer Configuration → Windows Settings → Deployed Printers
- Filter by OU or security group

## Optional log entry

Call `bulletin-service append` at the end of the intervention.
