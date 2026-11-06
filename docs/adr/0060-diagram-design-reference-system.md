# ADR 0060 — diagram-design as the visual reference system

**Date:** 2026-09-17
**Status:** Accepted

## Decision

Adopt the `diagram-design` visual system (bocal-pol/diagram-design, a fork of cathrynlavery/diagram-design) as the palette, typography, and grid-convention reference for every skill that produces diagrams (`illustre`, `architect`, `design-dna`, and any future visualization skill).

## Reason

The repo provides a coherent system of 39 diagram types, a WCAG AA semantic palette (ink/paper/accent/muted), a strict 4px grid, and three type families (Instrument Serif / Geist sans / Geist Mono). Centralizing this reference prevents every skill from inventing its own diverging palette.

## Consequences

- Diagram skills use the `paper` (#f5f5f5), `ink` (#2d3142), `accent` (#eb6c36), `muted` (#4f5d75) tokens by default.
- A project can override via `DESIGN.md` — the project palette always takes precedence over the system palette.
- The `diagram-improve` skill maintains consistency by auditing drift whenever the reference system updates.
- Coordination: `diagram-improve` is the propagation tool for future updates to the reference system.
