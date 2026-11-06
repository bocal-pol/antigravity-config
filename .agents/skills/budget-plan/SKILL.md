---
name: budget-plan
description: Drafting ICT budget plans — hardware/software investments, recurring costs, maintenance, services, reserves. Multi-year projection, management presentation note, actual-vs-planned comparison. Generalized from a public-sector budgeting workflow; adapt the tax rate and procurement-threshold logic to your own jurisdiction.
model: claude-sonnet-5
user-invocable: true
aliases: []
argument-hint: "[budget year] [scope: full|hardware|software|maintenance]"
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Budget Plan — ICT Budget Plan

Drafting and tracking the ICT budget. Structured around a civil fiscal year.

## Phase 0 — Scoping

1. Budget year (YYYY)
2. Scope (full / hardware only / software only / maintenance)
3. Sources to use: inventory (hardware-inventory), contracts (contract-manager), bulletins
   (bulletin-analyser)
4. **Public procurement threshold?** If an individual budget line exceeds your jurisdiction's public
   procurement threshold (license purchase, hosting, external service), or the project is run by an
   entity subject to public procurement law: route that line to a procurement-specific skill rather
   than costing it here. `budget-plan` remains the source for the overall costing and for lines
   below the threshold; the procurement skill qualifies the procedure (direct / negotiated / open)
   for lines above it. Don't double-cost: a line sent to the procurement skill appears in this
   budget as a cross-reference (`→ see procurement workflow, ref. [tender spec]`), not as an amount
   costed here.

## Budget categories

| Category | Examples |
|---|---|
| Hardware investment | Switches, servers, workstations, printers |
| Software investment | Licenses, SaaS subscriptions |
| Recurring costs | Annual support, preventive maintenance |
| Services | Consulting, training, assistance |
| Contingency reserve | 5–10% of the total excluding the reserve itself |

## Phase 1 — Collection

For each budget line:
- Description
- Category
- Estimated amount excl. tax
- Justification (EOL replacement / new infrastructure / contractual)
- Urgency (P1 mandatory / P2 planned / P3 desirable)
- Source (inventory ID / contract reference)

## Phase 2 — Budget table

```
# ICT Budget Plan — Fiscal year YYYY

## Summary
| Category | Amount (excl. tax) | % |
|---|---|---|

Total (excl. tax): [X]
Tax (rate %):      [X]
Total (incl. tax): [X]

## Detail by line
| # | Description | Cat. | Priority | Amount (excl. tax) | Justification |
|---|---|---|---|---|---|
```

## Phase 3 — Multi-year projection (optional)

| Line item | YYYY | YYYY+1 | YYYY+2 | Trend |
|---|---|---|---|---|

## Phase 4 — Management presentation note (1 page)

- Context and stakes
- Priorities for the year
- Costed summary
- Risks if the budget is reduced

## Saving

`documents/budgets/YYYY_ict-budget-plan.md`
