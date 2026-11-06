---
name: bulletin-analyser
description: Analyzes ICT service bulletins (support and/or network technicians) to extract patterns, trends, recurring equipment, frequent users, workload. Produces a management-level summary report.
model: claude-sonnet-5
user-invocable: true
aliases: []
argument-hint: "[period: month|week|quarter] [team: support|network|all] [optional path]"
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Bulletin Analyser — ICT Service Bulletin Analysis

Reads service bulletins from one or more ICT teams, extracts key data, and produces a patterns-and-
trends report.

## Default sources

- Support technicians: `support-team/reports/bulletins/`
- Network: `network-team/reports/bulletins/`
- Or any explicitly provided path

## Phase 0 — Scoping

1. Period? (week / month / quarter / [start date] → [end date])
2. Team(s)? (support / network / both)
3. Focus? (recurring equipment / frequent users / workload / incident types / everything)

## Phase 1 — Reading and extraction

Read the files for the period, extract per bulletin:
- Date, operator, intervention type, user/device, outcome, observations

## Phase 2 — Pattern analysis

### Recurring equipment
Alert threshold: **3 or more interventions** → candidate for preventive maintenance or replacement.

### Frequent users
Alert threshold: **4 or more calls** → training need or unsuitable equipment.

### Dominant incident types
Percentage breakdown by category (Hardware / OS / Software / Accounts / Printers / Network).

### Workload
Per operator + identification of peaks (busy days/weeks).

### Resolution rate
Resolved on first call / after several interventions / unresolved / escalated.

## Phase 3 — Summary report

```markdown
# ICT Activity Report — [Period]

## Overview
[Total interventions, teams, period]

## Points of attention
### Equipment to monitor
[List with recommendations: maintenance / replacement]

### Users needing follow-up
[Context — training / equipment]

## Incident breakdown
[Table by type]

## Team workload
[Per operator + comment on peaks]

## Resolution rate
[Figure + comment]

## Recommendations
[3 to 5 concrete, quantified actions if possible]
```

## Phase 4 — Saving

Offer to save to `reports/YYYY-MM_ict-activity.md`.
