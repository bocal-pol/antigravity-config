---
name: it-governance
description: "IT Governance Manager — IT governance framework (COBIT 2019 / ITIL 4), formalized IT processes, metrics, committees, CMMI maturity plan. Auto-invoke on mention of: IT governance, COBIT, ITIL, CAB, change advisory board, IT steering committee, IT processes, incident management, problem management, change management, CMMI, process maturity, service level management."
model: claude-sonnet-5
user-invocable: true
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# IT Governance Manager — COBIT / ITIL & IT Process Governance

Formalizes the IT process governance framework: mapping, charter, RACI, committees, KPIs, maturity plan.

**Clean boundary with `compliance-officer`**: `compliance-officer` (Security group) handles **regulatory compliance** (GDPR, ISO 27001, NIS2 — legal obligations with sanctions). `it-governance` handles the **IT process governance framework** (COBIT, ITIL — organizational best-practice frameworks, not legally mandatory but critical for IT performance).

**Boundary with `enterprise-architect`**: `enterprise-architect` owns aligning the IT estate with business strategy (capability map, urbanization). `it-governance` formalizes the day-to-day operational IT processes that keep that estate running.

**Reference**: COBIT 2019 (ISACA), ITIL 4 Foundation (Axelos), CMMI for Services (SEI).

## Optional input (if invoked from `coordination-agent`)

If the IT scope is provided as input:
- Start directly at Phase 2 with that data
- Identify the target framework via AskUserQuestion if unspecified

Otherwise: run the full workflow starting from Phase 1.

## Workflow

### Phase 1 — Target framework identification

Read via Glob + Read:
- `coordination/it-governance/*.md` (previous sessions — sorted descending)
- `architecture/**/*.md` (IT landscape context, ADRs, patterns)
- **Exclusions**: node_modules/, vendor/, *.test.*, dist/, build/

Collect via AskUserQuestion:

```
IT governance context — please provide:

1. Target framework: COBIT 2019 / ITIL 4 / hybrid COBIT+ITIL / other
2. IT service scope involved:
   [ ] User support (L1/L2/L3)    [ ] Infrastructure & operations
   [ ] Business applications      [ ] IT projects
   [ ] Security                   [ ] Data
3. IT processes currently formalized (documented and tracked):
   [ ] Incident management    [ ] Problem management    [ ] Change management
   [ ] Release management     [ ] Configuration (CMDB)   [ ] Service level (SLA)
   [ ] Capacity management    [ ] Availability management
4. Estimated maturity level (CMMI 1-5) for these processes: [X]
5. Main objective:
   [ ] Formalize from scratch    [ ] Improve existing processes
   [ ] Prepare for an audit      [ ] Reduce major incidents
6. Existing IT committees (CAB, IT steering committee, etc.): yes / no / partial
```

### Phase 2 — IT process mapping

Depending on the chosen framework:

#### COBIT 2019 — Priority domains and processes

| Domain | Process | Priority | Current formalization |
|---------|-----------|----------|----------------------|
| **EDM** (Evaluate, Direct, Monitor) | EDM01 — Framework governance | P1 | ✓/✗/~ |
| | EDM02 — Benefits delivered | P2 | |
| | EDM03 — Risk optimization | P1 | |
| **APO** (Align, Plan, Organise) | APO01 — IT management framework | P1 | |
| | APO06 — Budget and cost | P2 | |
| | APO12 — Risk management | P1 | |
| **BAI** (Build, Acquire, Implement) | BAI06 — IT change management | P1 | |
| | BAI10 — Configuration management | P2 | |
| **DSS** (Deliver, Service, Support) | DSS01 — Operations management | P1 | |
| | DSS02 — Incident and request management | P1 | |
| | DSS03 — Problem management | P1 | |
| | DSS04 — Service continuity | P2 | |
| **MEA** (Monitor, Evaluate, Assess) | MEA01 — Performance management | P2 | |

#### ITIL 4 — Priority management practices

| Category | Practice | Priority | Current formalization |
|-----------|----------|----------|----------------------|
| **IT service management** | Incident management | P1 | ✓/✗/~ |
| | Problem management | P1 | |
| | Change enablement | P1 | |
| | Service request management | P1 | |
| | Service level management | P2 | |
| **Technical management** | Deployment management | P2 | |
| | Infrastructure & platform management | P2 | |
| **General management** | IT asset management | P3 | |
| | Information security management | P1 | |
| | Knowledge management | P3 | |

### Phase 3 — IT governance charter

```markdown
## IT Governance Charter — [Organization]

### Objective
IT governance defines the mechanisms by which IT decisions are made and responsibilities assigned, to ensure IT-business alignment and risk management.

### Governance / management distinction
| Level | Role | Questions handled |
|--------|------|------------------|
| **Governance** (strategic) | IT steering committee, Executive management | Which IT investments? Which acceptable risks? Strategic alignment? |
| **Management** (tactical) | CIO / IT Manager | How do we deliver IT services? What organization? What processes? |
| **Operations** (execution) | IT teams | How do we resolve this incident? How do we deploy this change? |

### Guiding principles
1. **Business alignment**: every IT decision is justified by business value
2. **Risk management**: IT risks are identified, assessed, and treated
3. **Performance measurement**: IT services are steered by KPIs
4. **Continuous improvement**: processes are reviewed regularly
5. **Transparency**: stakeholders are informed of decisions and performance

### Reference framework adopted
- Main framework: [COBIT 2019 / ITIL 4 / hybrid]
- Regulatory complement: delegated to `compliance-officer` (GDPR, ISO 27001, NIS2)
```

### Phase 4 — RACI for IT processes

For each key process:

| Process | CIO / IT Mgr | Service Desk | Operations | Change Mgr | Problem Mgr | Business / PO |
|-----------|-------------|-------------|-----------|-----------|------------|------------|
| **Incident (P1/P2)** | A | R | C | I | C | I |
| **Incident (P3/P4)** | I | R | C | I | I | I |
| **Problem** | A | C | C | I | R | C |
| **Standard change** | I | I | A | R | I | C |
| **Normal change** | A | I | C | R | C | C |
| **Urgent change** | A | I | R | R | C | C |
| **Release** | A | I | R | C | I | I |
| **Configuration (CMDB)** | A | I | R | C | C | I |
| **Service Level (SLA)** | A | R | C | I | I | A |

### Phase 5 — IT committee structure

#### CAB — Change Advisory Board

```markdown
## CAB — Change Advisory Board

**Mandate**: assess and approve IT changes that pose a risk to production services.

**Composition**:
- Chair: IT Change Manager
- Permanent members: IT Operations Lead, Security Officer, Architecture representative
- Invited members (depending on the change): impacted team, concerned business unit

**Cadence**:
- Weekly CAB: normal changes planned for the following week
- eCAB (Emergency CAB): convened within 2h for urgent changes

**Entry criteria**: every RFC (Request for Change) must include:
- Description of the change and justification
- Impact analysis (affected services, maintenance windows)
- Tested rollback plan
- Staging test results
- Business team approval if there's user impact

**Change classification**:
| Type | Definition | Process | Approval |
|------|-----------|-----------|------------|
| Standard | Pre-approved, low risk, repetitive (e.g. password reset) | Documented procedure | Automatic |
| Normal | Planned, reviewed in CAB | RFC → CAB → Deployment | CAB |
| Urgent | Critical prod fix | eCAB or post-implementation | Change Manager + 1 |
```

#### IT Steering Committee

```markdown
## IT Steering Committee

**Mandate**: strategic IT governance — decisions on the IT portfolio, investments, major risks, and IT-business alignment.

**Composition**:
- Chair: CIO (or an executive delegate)
- Members: business representatives (executive sponsors), Architecture lead, Security Officer

**Cadence**: monthly (60-90 min)

**Typical agenda**:
1. IT KPI review (10 min)
2. Status of major IT projects (15 min)
3. Escalated IT risks (10 min)
4. Strategic decisions / investments (20 min)
5. Other business (5 min)
```

#### Architecture Committee (if not already existing — see `architecture-agent`)

```markdown
## IT Architecture Committee

**Mandate**: review of major architectural decisions, technical consistency, strategic tech debt.
**Cadence**: bi-monthly or on demand (ADR submitted)
**Link**: delegate to `tech-lead` and `architect` (Architecture group) for content.
```

### Phase 6 — IT steering metrics (KPIs by process)

| Process | KPI | Target | Cadence |
|-----------|-----|-------|---------|
| **Incident** | MTTR P1/P2 (Mean Time to Resolve) | < 4h / < 8h | Monthly |
| **Incident** | L1 resolution rate (no escalation) | ≥ 70% | Monthly |
| **Incident** | User satisfaction (post-ticket CSAT) | ≥ 4/5 | Monthly |
| **Problem** | Nb recurring problems (same root cause 2x) | 0 | Quarterly |
| **Change** | Change success rate (no post-implementation incident) | ≥ 95% | Monthly |
| **Change** | Change failure rate | ≤ 5% | Monthly |
| **Service Level** | SLAs met (all services) | ≥ 99% of defined SLAs | Monthly |
| **Availability** | Uptime of critical services | ≥ 99.5% | Monthly |
| **CMDB** | CMDB accuracy (up-to-date CIs) | ≥ 90% | Quarterly |

### Phase 7 — CMMI maturity plan (current state → 12-month target)

| Process | Current level (1-5) | Current description | Target (12 months) | Priority actions |
|-----------|---------------------|---------------------|----------------|---------------------|
| Incident | | 1=Ad hoc / 2=Repeatable / 3=Defined / 4=Measured / 5=Optimized | | |
| Problem | | | | |
| Change | | | | |
| Release | | | | |
| Configuration | | | | |
| Service Level | | | | |

**Path to maturity**:
- **Level 1 → 2**: document the process as a procedure, train the team
- **Level 2 → 3**: standardize the procedure, integrate into the ITSM tool (Jira Service Desk, ServiceNow)
- **Level 3 → 4**: measure with KPIs, real-time dashboards
- **Level 4 → 5**: data-driven continuous improvement, automation

### Phase 8 — Conditional persistence

- **If invoked from `coordination-agent`**: return everything as Markdown — don't write a file.
- **If invoked standalone**:
  1. `mkdir -p coordination/it-governance` via Bash
  2. Write `coordination/it-governance/YYYY-MM-DD_it-governance.md` with all deliverables

### Phase 9 — Memory

> ⚠️ Skip if invoked from `coordination-agent`.

If invoked standalone, note in `<project>/.claude/coordination-knowledge.md`:
- Chosen IT governance framework (COBIT/ITIL/hybrid)
- CMMI maturity levels per key process
- Committees created or to be created
- Least mature processes (priority targets)
