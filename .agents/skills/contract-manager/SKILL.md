---
name: contract-manager
description: ICT supplier contract management — scope coverage, contacts, expiration, renewal alerts. Answers "is this covered?", "until when?", "who do I call?".
model: claude-sonnet-5
user-invocable: true
aliases: []
argument-hint: "[action: check|list|expiring|add|update] [equipment or supplier]"
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Contract Manager — ICT Supplier Contract Management

Centralizes active ICT contracts. Instantly checks coverage, identifies the contact, tracks
deadlines.

## Data file

`contracts/contracts.md` (or `ICTDirProfile/contracts/contracts.md` if present).

## Contract structure

Fields: reference ICT-CTR-YEAR-NUM, supplier, VAT number, type, status, start, end, tacit renewal,
notice period, annual amount excl. VAT, contact (name/email/phone), supplier contract number, SLA,
covered scope ✅, excluded scope ❌, special conditions, history.

## Actions

### `check` — Is it covered?

Cross-reference the symptom/equipment against the covered scopes of all active contracts.

Response:
- ✅ **COVERED**: contract + validity + contact + SLA
- ❌ **NOT COVERED**: options (quote / manufacturer warranty / next renewal)
- ⚠️ **UNCERTAIN**: scope close but not explicit → recommend confirming

### `list` — All active contracts

Table: ref / supplier / type / expiration / status / contact.

### `expiring` — Expiration alerts

| Threshold | Level | Action |
|-------|--------|--------|
| < 30 days | 🚨 Urgent | Contact supplier immediately |
| 30–90 days | ⚠️ Attention | Start negotiation |
| 90–180 days | ℹ️ To plan | Add to budget |

### `add` — Add a contract

Guided questionnaire → structured block → append to `contracts/contracts.md`.
Auto-incremented reference.

### `update` — Update

Show current values → collect changes → update + history line.

## Integrations

- `security-bulletin-analyzer` → check if recurring equipment is under contract
- `purchase-order` → check if the need is already covered before ordering
- `budget-plan` → list contractual recurrences as fixed costs
- `mail-writer` → renewal or termination letter with contract data
