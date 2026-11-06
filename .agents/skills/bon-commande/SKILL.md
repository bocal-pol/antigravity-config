---
name: bon-commande
description: Drafting purchase orders for ICT procurement — sequential reference numbering, line items, tax handling, budget code allocation, delivery timeline, payment terms. Generalized from a public-sector procurement workflow; adapt the tax rate, reference format, and payment-terms defaults to your own jurisdiction.
model: claude-sonnet-5
user-invocable: true
aliases: ["/po"]
argument-hint: "[supplier] [items]"
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Purchase Order — ICT Procurement

Drafts structured purchase orders for ICT purchases.

## Automatic reference numbering

Format: `ICT-PO-YYYY-NUM` — e.g. `ICT-PO-2026-042`

The next number is determined by reading `documents/purchase-orders/` or `contracts/contracts.md`.

## Information gathering

1. Supplier (name, address, tax ID, bank account, contact person)
2. Delivery address
3. Line items (description / quantity / unit price excl. tax)
4. Desired delivery timeline
5. Budget allocation (budget code / fiscal year)
6. Purchase order linked to a tender/RFQ? → provide the reference

## Purchase order structure

```
PURCHASE ORDER NO. ICT-PO-YYYY-NUM

Issuing department: [ICT Department — Organization]
Date: YYYY-MM-DD
Supplier: [Name] — [Tax ID] — [Address]
Supplier contact: [Name] — [Email] — [Phone]

Delivery address: [...]

ORDER LINES
| # | Description | Qty | Unit price (excl. tax) | Total (excl. tax) |
|---|---|---|---|---|

Subtotal (excl. tax): [amount]
Tax (rate %):         [amount]
TOTAL (incl. tax):    [amount]

Budget allocation: [code]
Delivery timeline: [date or timeframe]
Payment terms: [e.g. net 30 end of month]

Tender/RFQ reference (if applicable): ICT-RFQ-YYYY-NUM
Contract reference (if applicable): ICT-CTR-YYYY-NUM

Authorized signature: [Name — Title]
```

## Saving

`documents/purchase-orders/YYYY-MM-DD_ICT-PO-YYYY-NUM_[supplier].md`
