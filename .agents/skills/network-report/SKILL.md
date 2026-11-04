---
name: network-report
description: Generates management reports on network infrastructure — availability, incidents, capacity, changes, budget. Markdown tables and Mermaid diagrams. Technical or executive audience.
model: claude-sonnet-5
user-invocable: true
aliases: ["/nrp"]
argument-hint: "[period] [audience: technical|executive] [focus: availability|incidents|capacity|changes|budget|full]"
type: domain
priority: medium
scope: infra
dependencies: []
conflicts: []
---

# Network Report — Network Infrastructure Management Reports

Generates reports on network infrastructure status, adapted to the audience (technical vs. executive).

## Phase 0 — Scoping

1. Period (week / month / quarter)
2. Audience (technical / executive / both)
3. Focus (availability / incidents / capacity / changes / budget / full)

## Available sections

### Network availability
- Network SLA (uptime per segment)
- P1/P2 incidents with MTTR
- Mermaid chart of the uptime trend

### Incidents
- Chronological table (date / description / duration / impact / status)
- Average MTTR
- Recurrence: repeated incidents on the same device

### Capacity
- Bandwidth usage per link (if data available)
- Switch port utilization (used ports / total)
- Saturation projection

### Changes
- Log of implemented RFCs (success / failure / rollback)
- Pending planned changes
- Upcoming maintenance windows

### Budget / Accounting
- Purchase / maintenance / support / license table per asset
- Planned vs. actual budget comparison

## Output format

```markdown
# Network Infrastructure Report — [Period]
**Date:** [date]
**Audience:** [technical / executive]

## Executive summary
[2-3 sentences — overall status, major point of attention, required action]

## [Sections per focus]

## Points of attention
[List of items requiring a decision or action]

## Recommended actions
[Table: action / owner / deadline / priority]
```

## Save location

`reports/YYYY-MM_[type]-report.md`
