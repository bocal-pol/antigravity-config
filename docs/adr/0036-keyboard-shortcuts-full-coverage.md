# ADR 0036 — Keyboard shortcuts: full coverage + command palette

- **Status**: accepted
- **Date**: 2026-08-24

## Context

Interfaces were designed exclusively for the mouse. Advanced users (back-office operators, power users) lost time on repetitive actions with no shortcuts. Discoverability of existing shortcuts (when they existed at all) was nonexistent.

## Decision

Any mouse-accessible action must have a keyboard shortcut. Three coverage levels:

1. **Global actions** — navigation, creation, save, undo
2. **Contextual actions** — every button, menu, table action
3. **Command palette** (`Cmd+K` / `Ctrl+K`) — a universal, searchable entry point

### Discoverability: two mandatory mechanisms

- **Hover tooltip**: the shortcut shown to the right of the label (`"Archive  ⌘⇧A"`)
- **A `?` panel**: a centralized, filterable list of every active shortcut, organized by section

### Back-office (Filament/Laravel)

Tables: `↑↓` navigation, `E` edit, `D` delete, `Space` select, `Enter` open, `Escape` deselect.

Forms: strict `Tab`/`Shift+Tab`, `Ctrl+Enter` submit, `Escape` cancel.

### Frontend (Angular / React / Flutter)

A centralized shortcut service (e.g. `useHotkeys`) — never scattered `keydown` listeners. Context priority: modal > drawer > page. Single-letter shortcuts disabled when focus is in an input field.

## Positive consequences

- Advanced users can work mouse-free on their common flows
- The `Cmd+K` palette reduces discovery time to zero — everything is searchable
- Cross-app consistency reduces the learning curve

## Negative consequences / risks

- Initial development overhead (centralized service, tooltips, `?` panel)
- Single-letter shortcuts can conflict with IMEs (Asian languages) — disable in those contexts
- The command palette is a global component — it must be kept up to date with every new action

## Alternatives considered

- **Ad hoc shortcuts with no centralized service**: scattered listeners, conflicts, impossible to maintain. Rejected.
- **Partial coverage (primary actions only)**: insufficient for back-office power users. Rejected.
- **Tooltip alone, no reference panel**: passive discovery only, hard to learn. Rejected.

## Scope

All projects with a user interface — frontend (Angular, React, Flutter) AND back-office (Filament/Laravel).
