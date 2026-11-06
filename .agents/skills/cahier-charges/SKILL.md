---
name: cahier-charges
description: "Drafting tender specifications (RFQ/RFP documents) for public procurement — technical specifications, award criteria, administrative conditions. Generalized from a specific jurisdiction's public procurement law; adapt the procedure thresholds and legal references to your own jurisdiction."
model: claude-sonnet-5
user-invocable: true
aliases: ["/rfp"]
argument-hint: "[procurement subject] [estimated amount]"
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Tender Specifications — Public Procurement

Drafts tender specification documents (RFQ/RFP) for public procurement. The thresholds and
procedure names below follow one jurisdiction's public procurement framework as a worked example —
substitute your own jurisdiction's thresholds and procedure names before use.

## Phase 0 — Procurement qualification

1. Subject and summary description
2. Estimated amount excl. tax → determines the applicable procedure
3. Procurement type (supplies / services / works)

| Amount (excl. tax) | Procedure |
|---|---|
| Below the low threshold | Direct procedure (several quotes recommended) |
| Between the low and high thresholds | Negotiated procedure without publication |
| Above the high threshold | Open procedure with official publication |

## Phase 1 — Technical specifications

Structure into Mandatory Minimums (MM) and Optional Preferences (OP):

| # | Specification | Type | Justification |
|---|---|---|---|
| 1 | ... | MM / OP | |

Rule: every MM must be objectively justifiable to avoid discrimination between bidders.

## Phase 2 — Quantities and delivery

- Exact quantities or ranges (min/max)
- Delivery location
- Delivery / commissioning timeline
- Acceptance conditions (acceptance tests)

## Phase 3 — Award criteria

Total weighting = 100%

| Criterion | Weight | Evaluation method |
|---|---|---|
| Price | X% | Proportional formula |
| Technical value | X% | Scoring grid |
| Timeline | X% | |
| After-sales service | X% | |

## Phase 4 — Administrative conditions

- Contract duration
- Performance bond (typically a percentage of the amount — above a jurisdiction-specific threshold)
- Payment: specify terms (e.g. net 30 end of month)
- Governing law: [your jurisdiction]
- Dispute resolution: [competent courts]

## Phase 5 — Final document structure

```
# TENDER SPECIFICATIONS
Reference: ICT-RFP-YYYY-NUM

## 1. Subject of the procurement
## 2. Procedure
## 3. Technical specifications
## 4. Quantities and delivery
## 5. Award criteria
## 6. Administrative and legal conditions
## 7. Submission form
```

## Saving

`documents/tender-specs/YYYY-MM-DD_[short-subject].md`
