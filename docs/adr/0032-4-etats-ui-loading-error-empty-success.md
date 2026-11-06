# ADR 0032 — 4 mandatory UI states: Loading / Error / Empty / Success

- **Status**: **superseded by [ADR 0003](0003-ui-states-4-etats-obligatoires.md)**
- **Date**: 2026-08-21
- **Superseded on**: 2026-09-17

## Why this was superseded

This ADR and [ADR 0003](0003-ui-states-4-etats-obligatoires.md) were written the same day on the same subject — the four mandatory states of an asynchronous render — and both carried the "accepted" status, with neither referencing the other. Two competing ADRs on the same decision make the corpus ambiguous: a reader can't tell which one is authoritative.

**0003 is kept as canonical** (the earlier number, and the only one of the two to document negative consequences). 0032's unique contributions were merged into it on 2026-09-17: the cross-reference to the 3-part error message (ADR 0005), the `no-data` / `filtered` / `search` empty-state typology, the entry transition on the Success state.

The file is kept to preserve numbering continuity and existing links. It no longer carries any normative content.

## Where to read the decision

→ [ADR 0003 — 4 mandatory UI states for any asynchronous render](0003-ui-states-4-etats-obligatoires.md)

## Scope

None — a superseded ADR.
