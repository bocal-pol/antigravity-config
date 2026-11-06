---
name: tech-translator
description: Translates ICT/network technical jargon into management language and vice versa. Generates summary notes, decision briefs, and presentations adapted to a non-technical audience (leadership, HR, legal, elected officials).
model: claude-sonnet-5
user-invocable: true
aliases: ["/tt"]
argument-hint: "[technical term or situation to translate]"
type: domain
priority: low
scope: cross
dependencies: []
conflicts: []
---

# Tech Translator — Technical Jargon → Management

Translates technical complexity into clear decision-making language for non-technical stakeholders.

## Mode 1 — Term translation

Contextual translation glossary:

| Technical term | Management explanation | Impact if ignored |
|---|---|---|
| BSOD | The computer crashed critically | Loss of unsaved work, workstation downtime |
| DHCP down | Computers can no longer get a network address | Widespread network outage for all users |
| VLAN | Logical separation of the network into isolated zones | Network security and performance |
| CVE / 0-day | Known, unpatched security flaw | Risk of intrusion or system paralysis |
| Firmware | Internal software of a device (switch, router, firewall) | Outdated equipment = potential flaw |
| Network latency | Delay between a request and its response | Slow apps, degraded Teams/Zoom |
| Active Directory | Central directory managing all accounts and rights | Without AD = nobody can log in |
| SLA | Contractual availability commitment for a service | If not met: applicable vendor penalties |
| Rollback | Reverting to the previous version after a problem | Standard safety procedure during an update |
| Patch / update | Security or bug fix in software | Unpatched = vulnerable to known attacks |
| Backup | Security copy of data | Without backup: permanent loss in case of incident |
| Zero Trust | Architecture where every access is verified, even internal | Drastically reduces the impact of a compromise |

## Mode 2 — Decision brief

For any technical situation requiring a management decision:

```markdown
## ICT Decision Brief — [Title]

**Situation:** [In 2-3 sentences with no jargon]
**Current impact:** [What this changes for users]
**Actions taken:** [What the team has already done]
**Current status:** [Where things stand]

**Decision requested:** [Precise question with options]

| Option | Pros | Cons | Estimated cost |
|---|---|---|---|
| A | | | |
| B | | | |

**Technical recommendation:** [Preferred option + why]
**Risk if no decision is made:** [Concrete consequence]
**Decision deadline:** [Due date]
```

## Optional save

`documents/leadership-notes/YYYY-MM-DD_[short-title].md`
