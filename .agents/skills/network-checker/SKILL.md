---
name: network-checker
description: "Network Checker — systematic verification before any switch port configuration. Validates mode (Access/Trunk), VLAN tagging, and description (traceability). Generates the verified config in multi-vendor form (Cisco <-> Huawei) + rollback. Auto-invoke systematically on: configure a port, switch port, switch interface, access port, trunk port, vlan port, switchport, port link-type, network interface description."
model: claude-sonnet-5
user-invocable: true
type: utility
priority: low
scope: infra
dependencies: []
conflicts: []
---

# Network Checker — Mandatory Verification Before Port Configuration

Systematic verification ritual for the 3 critical properties of a switch port before applying any configuration. Produces the verified config + multi-vendor equivalence + rollback.

> This skill is the **"Key Skill"** of the Infrastructure & Network group.
> Every port configuration goes through this verification — no exceptions.

## ICT rules — Non-negotiable

| Rule | Application |
|-------|------------|
| **3 mandatory checks** | Mode (Access/Trunk) + VLAN tagging + Description — in this order |
| **Multi-vendor** | Cisco config + Huawei equivalence SYSTEMATICALLY. Juniper + Alcatel-Lucent as a bonus if requested |
| **Safety First** | Rollback documented BEFORE the target config |
| **Traceability** | Description is mandatory, never optional. Recommended format: `ROLE-DEVICE-NAME` |

## Optional input (if invoked from `network-engineer`)

If vendor + hostname + port + mode + VLAN + description are provided as input:
- Skip Phase 1 (collection) and start directly at Phase 2 (checklist)

Otherwise: run the full workflow starting at Phase 1.

## Workflow

### Phase 1 — Collecting port information

Collect via AskUserQuestion (one grouped question):

```
Switch port verification — please provide:

1. Vendor: Cisco / Huawei / Juniper / Alcatel-Lucent (AOS)
2. Switch hostname (e.g. SW-ACC-01)
3. Port identifier (e.g. GigabitEthernet0/1 / Gi0/1 / GE0/0/1 / ge-0/0/1 / 1/1/1)
4. Port mode:
   [ ] Access (a single untagged VLAN)
   [ ] Trunk (several tagged VLANs + native VLAN)
5. If Access: VLAN ID (e.g. 10)
   If Trunk: allowed VLANs (e.g. 10,20,30) + native VLAN (e.g. 999)
6. Port description (mandatory — e.g. "PC-HR-Smith", "TRUNK-SW-DIST-01", "WEB-SERVER-01")
7. Juniper / Alcatel-Lucent wanted too? Yes / No
```

### Phase 2 — Checklist of the 3 mandatory checks

```
╔══════════════════════════════════════════════════════════════════╗
║  NETWORK CHECKER — SW: [HOSTNAME] — Port: [PORT-ID]             ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  CHECK 1 — PORT MODE                                             ║
║  ─────────────────────────────────────────────────────────────  ║
║  Requested mode: [Access / Trunk]                                ║
║  Consistency with topology: [OK / CHECK]                         ║
║  → Port connected to: [PC / Server / Switch / AP / Phone]        ║
║  → Recommended mode for this type: [Access / Trunk]              ║
║  → Verdict: [Consistent / Inconsistent — explain]                ║
║                                                                  ║
║  CHECK 2 — VLAN TAGGING                                          ║
║  ─────────────────────────────────────────────────────────────  ║
║  If Access → VLAN ID: [X]                                        ║
║    Does the VLAN exist in the plan? [Yes / To create first]      ║
║    VLAN appropriate for this device type? [Yes / Check]          ║
║  If Trunk → allowed VLANs: [X,Y,Z]                                ║
║    Native VLAN != VLAN 1? [Yes (VLAN [N]) / NO — risk]            ║
║    Do all listed VLANs exist? [Yes / To create: VLAN X]           ║
║  → Verdict: [Correct VLAN / Correction required]                 ║
║                                                                  ║
║  CHECK 3 — PORT DESCRIPTION                                      ║
║  ─────────────────────────────────────────────────────────────  ║
║  Description provided: "[DESCRIPTION]"                           ║
║  Acceptable length (max 80 chars): [Yes / Check]                 ║
║  Recommended format followed: [Yes ROLE-NAME / Needs improvement] ║
║  Sufficient traceability: [Identifiable / Too vague]              ║
║  → Verdict: [Description OK / Suggestion: "..."]                 ║
║                                                                  ║
║  OVERALL RESULT: [ALL CHECKS OK / CORRECTIONS NEEDED]             ║
╚══════════════════════════════════════════════════════════════════╝
```

> If a check fails (blocking issue): **STOP** and report the required correction before generating the config. Do not produce a configuration for a port whose 3 checks aren't all validated.

### Phase 3 — Verified configuration

#### Cisco IOS / IOS-XE (primary vendor or equivalence)

```ios
! === SW: [HOSTNAME] — Port: [PORT-ID] ===
! Network Checker validated: Mode=[ACCESS/TRUNK] | VLAN=[X] | Description="[DESC]"
!
! ROLLBACK: copy the current config before applying
!   show running-config interface [PORT-ID] > before modifying
!   ROLLBACK: interface [PORT-ID] / shutdown / no description / switchport access vlan 1 / no shutdown
!              OR restore: copy flash:backup-[DATE].cfg running-config

interface [PORT-ID]
 description [DESCRIPTION]       ! Traceability — mandatory
```

**If Access mode:**
```ios
 switchport mode access
 switchport access vlan [VLAN-ID]
 spanning-tree portfast           ! Only for edge ports (PC, server, AP)
 no shutdown
!
! Post-apply verification:
! show interfaces [PORT-ID] switchport
! show spanning-tree interface [PORT-ID]
```

**If Trunk mode:**
```ios
 switchport mode trunk
 switchport trunk encapsulation dot1q
 switchport trunk allowed vlan [VLAN-LIST]
 switchport trunk native vlan [NATIVE-VLAN]
 no shutdown
!
! Post-apply verification:
! show interfaces [PORT-ID] trunk
! show interfaces [PORT-ID] switchport
```

#### Huawei VRP — Systematic equivalence

```vrp
# === SW: [HOSTNAME] — Port: [PORT-ID] ===
# Network Checker validated: Mode=[ACCESS/TRUNK] | VLAN=[X] | Description="[DESC]"
#
# ROLLBACK: display current-configuration interface [PORT-ID]
#   ROLLBACK: interface [PORT-ID] / shutdown / undo description / port default vlan 1 / undo shutdown
```

**If Access mode:**
```vrp
interface [PORT-ID]
 description [DESCRIPTION]
 port link-type access
 port default vlan [VLAN-ID]
 stp edged-port enable           ! Equivalent to portfast
 undo shutdown
#
# Post-apply verification:
# display interface [PORT-ID]
# display stp interface [PORT-ID]
```

**If Trunk mode:**
```vrp
interface [PORT-ID]
 description [DESCRIPTION]
 port link-type trunk
 port trunk allow-pass vlan [VLAN-LIST]
 port trunk pvid vlan [NATIVE-VLAN]
 undo shutdown
#
# Post-apply verification:
# display interface [PORT-ID] trunk
# display vlan [PORT-ID]
```

#### Juniper JunOS — If requested

```junos
# ROLLBACK: rollback 1 / commit  OR  commit confirmed 5
set interfaces [PORT-ID] description "[DESCRIPTION]"
```

**If Access mode:**
```junos
set interfaces [PORT-ID] unit 0 family ethernet-switching interface-mode access
set interfaces [PORT-ID] unit 0 family ethernet-switching vlan members vlan-[VLAN-ID]
commit confirmed 5
# Verification: show interfaces [PORT-ID]
```

**If Trunk mode:**
```junos
set interfaces [PORT-ID] unit 0 family ethernet-switching interface-mode trunk
set interfaces [PORT-ID] unit 0 family ethernet-switching vlan members [vlan-X vlan-Y vlan-Z]
set interfaces [PORT-ID] unit 0 family ethernet-switching native-vlan-id [NATIVE-VLAN]
commit confirmed 5
# Verification: show interfaces [PORT-ID]
```

#### Alcatel-Lucent AOS — If requested

```aos
! ROLLBACK: configuration snapshot before applying
interfaces port [PORT-ID] alias "[DESCRIPTION]"
```

**If Access mode:**
```aos
vlan [VLAN-ID] members port [PORT-ID] untagged
! Verification: show vlan [VLAN-ID] members
```

**If Trunk mode:**
```aos
vlan [VLAN-X] members port [PORT-ID] tagged
vlan [VLAN-Y] members port [PORT-ID] tagged
! Verification: show vlan members port [PORT-ID]
```

### Phase 4 — Summary table

```
┌─────────────────────────────────────────────────────────────────┐
│  CONFIGURATION SUMMARY                                          │
│  Switch   : [HOSTNAME]                                          │
│  Port     : [PORT-ID]                                           │
│  Mode     : [Access (VLAN [X]) / Trunk (VLANs [X,Y,Z])]        │
│  Native   : [VLAN [N] / N/A if Access]                          │
│  Desc     : "[DESCRIPTION]"                                     │
│  Portfast : [Enabled / Not applicable]                          │
│                                                                  │
│  Vendors covered: Cisco Yes | Huawei Yes | Juniper [Yes/—] | AOS [Yes/—] │
│                                                                  │
│  ROLLBACK (Cisco)  : interface [PORT-ID] / shutdown / no desc   │
│                      / [undo switchport config] / no shutdown   │
│  ROLLBACK (Huawei) : interface [PORT-ID] / shutdown / undo desc │
│                      / [undo port config] / undo shutdown       │
└─────────────────────────────────────────────────────────────────┘
```

### Phase 5 — Conditional persistence

- **If invoked from `network-engineer` or `infrastructure-agent`**: return the verified configs as Markdown — do not write a file.
- **If invoked standalone**:
  1. `mkdir -p infrastructure/network-checker` via Bash (if it doesn't exist)
  2. Append to `infrastructure/network-checker/YYYY-MM-DD_network-checker.md` with the summary table and generated configs (traceability log)

### Phase 6 — Memorization

> Skip if invoked from `network-engineer` or `infrastructure-agent`.

If invoked standalone, note in `<project>/.claude/infra-knowledge.md`:
- Primary vendor used
- Ports configured (hostname + ID + mode + VLAN) for historical reference
