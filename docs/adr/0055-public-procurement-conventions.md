# ADR 0055 — Public-procurement domain conventions

- **Status**: accepted
- **Date**: 2026-09-17

## Context

ICT administration skills (specification writing, purchase orders, contract management, budget planning) produce documents with administrative weight under a regulated framework — public-sector procurement. Two elements are hardcoded there and determine the produced content: procedure thresholds and identifier formats. They were scattered across the skills, with no trace of their origin or validity date.

## Decision

The example below illustrates the pattern using one real regulatory jurisdiction (Belgian public procurement); adapt the thresholds and formats to your own jurisdiction's rules.

### 1. Procedure thresholds (amount, tax excluded)

Any procurement document starts with a **Phase 0 qualification** step that determines the applicable procedure:

| Amount (tax excluded) | Procedure |
| --- | --- |
| < €30,000 | Direct procedure (3 quotes recommended) |
| €30,000 – €143,000 | Negotiated procedure with no publication |
| > €143,000 | Open procedure with official publication |

The estimated amount is established **before** writing the specifications: it drives the document's form, not the other way around.

### 2. Identifier formats

| Document | Format | Example |
| --- | --- | --- |
| Purchase order | `ICT-PO-YYYY-NUM` | `ICT-PO-2026-042` |
| Vendor contract | `ICT-CTR-YYYY-NUM` | `ICT-CTR-2026-007` |

A purchase order references its linked contract via `ICT-CTR-YYYY-NUM`. Filing: `documents/purchase-orders/YYYY-MM-DD_ICT-PO-YYYY-NUM_[vendor].md`.

### 3. Tax and structural constants

Local VAT rate, amounts expressed tax-excluded within the thresholds, mandatory budget allocation, specifications structured as **Mandatory** and **Desired/Optional** requirements.

### 4. Thresholds are regulatory, therefore dated

These amounts come from a jurisdiction's public-procurement regulation and **change over time**. They must be checked before any high-stakes procurement, and this ADR should be amended whenever they change — it documents a state, not a permanent truth.

## Positive consequences

- Identifiers are predictable and sortable, the purchase-order ↔ contract link is mechanical
- Phase-0 qualification avoids drafting a document in the wrong form
- Thresholds are grouped in a single place to amend

## Negative consequences / risks

- **Thresholds go stale**: an outdated amount produces a document under the wrong procedure, with real legal risk
- No automatic check confronts the skills against the regulation currently in force
- Identifier formats assume manually maintained numbering, with no central registry

## Alternatives considered

- **Thresholds entered by the user on every procurement**: shifts the memorization burden and produces inconsistencies. Rejected.
- **Fetching the regulation online on every use**: a network dependency and an unstable source for a frequent need. Rejected in favor of a documented, dated value.
- **Free-form identifiers**: loses the contract ↔ order link. Rejected.

## Scope

The specification-writing, purchase-order, contract-management, and budget-planning skills, and the `public-procurement-agent` (ADR 0052). Context: illustrated with Belgian public-sector procurement as the worked example.
