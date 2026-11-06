---
name: incident-pattern
description: Automatic detector of recurring outages — analyzes tickets from the last 48 hours to identify network, application, or hardware patterns. Triggers an alert and suggests escalation if a cluster of incidents is detected.
model: claude-sonnet-5
user-invocable: true
aliases: []
argument-hint: "[optional ticket file path]"
type: utility
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Incident Pattern — Recurring Outage Detector

Automatic ticket analysis to detect repetitive incidents that indicate an infrastructure problem rather than an isolated failure.

## Data source

Reads `tickets/task-list.md` by default (or the path passed as an argument).

## Analysis window

Last 48 hours. Filters tickets marked CLOSED in case a quick closure is masking a systemic problem.

## Alert thresholds

| Threshold | Signal | Action |
|---|---|---|
| 2 similar tickets in < 4h | ⚠️ Watch | Flag to the technician |
| 3 similar tickets in < 8h | 🚨 Alert | Escalate to network expert or dev |
| 4 similar tickets in < 24h | 🚨🚨 Major incident | Immediate escalation + open an infrastructure ticket |

## Indicators by type

### Network
Keywords: "slow", "connection", "Teams", "Outlook not responding", "network", "network share", "can't access", "WiFi", "VPN", "internet down", "ping"

### Application
Same application name across multiple tickets, "application crashes", "database", "intranet", "ERP", "500 error", "timeout"

### Local hardware (no alert)
"broken screen", "keyboard", "mouse", "USB printer", "BSOD on this machine", "charger", "battery"

## Alert format

```
⚠️ / 🚨 PATTERN DETECTED — [TYPE: Network | Application | Mixed]

Affected tickets:
- [Ticket ID] — [Short description] — [Time]
- [Ticket ID] — ...

Common indicators: [list]
Likelihood: infrastructure (vs. isolated)

→ Recommendation: [Escalate to network-engineer / dev team / sysadmin]
→ Immediate action: [Suggested diagnostic command]

Forward to: [network expert / dev team] if confirmed
```

## Automatic invocation

This skill is called as a pre-check by: `pc-repair`, `windows-admin`, `software-deploy`, `printer-support`, `debug`, `user-call`, `network-engineer`, `firewall-engineer`, `switch-audit`.

If no pattern: continue silently.
If a pattern is detected: display the alert before continuing the intervention.
</content>
