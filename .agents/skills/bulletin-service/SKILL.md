---
name: bulletin-service
description: Writing and managing the daily service bulletin — daily intervention log. Modes append (add an intervention), finalize (close the day), view (consult), report (period summary).
model: claude-sonnet-5
user-invocable: true
aliases: ["/bs"]
argument-hint: "[mode: append|finalize|view|report] [optional date]"
type: utility
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Service Bulletin — Daily Intervention Log

Manages the daily intervention log. Used by both support technicians and network experts to trace
activity.

## Target file

`reports/bulletins/YYYY-MM-DD_bulletin.md` (created automatically if absent)

---

## `append` mode — Add an intervention

Collect and append to the day's bulletin:

```markdown
### [HH:MM] — [Type: Hardware|OS|Network|Software|Account|Printer|Other]

**User / Device / Equipment:** [identification]
**Action:** [short description of the intervention]
**Result:** Resolved ✅ / Partial ⚠️ / Unresolved ❌ / Escalated 🔄
**Estimated duration:** [N minutes/hours]
**Observations:** [points to monitor, follow-up]
```

---

## `finalize` mode — Close the day

Add the end-of-day summary:

```markdown
---
## Day summary — [date]

| Indicator | Value |
|---|---|
| Total interventions | [N] |
| Resolved | [N] (X%) |
| Escalated | [N] |
| Unresolved | [N] |
| Total estimated time | [Xh Ym] |

### Open items for tomorrow
- [item if applicable]
```

---

## `view` mode — Consult

Read and display the bulletin for a given date (today by default).

---

## `report` mode — Period summary

Aggregate several bulletins and produce a summary:
- Total number of interventions
- Breakdown by type
- Recurring equipment / users
- Resolution rate

Redirects to `bulletin-analyser` for in-depth analysis.

---

## Automatic invocation

This skill is called automatically at the end of intervention skills (`pc-repair`,
`network-engineer`, `switch-audit`, `firewall-engineer`, etc.) to trace activity.
