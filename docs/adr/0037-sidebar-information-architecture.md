# ADR 0037 — Sidebar: intent-based information architecture, max 7, lead feature first

- **Status**: accepted
- **Date**: 2026-08-24

## Context

Back-office sidebars were built around technical features: one item per model, table, or controller. Result: 12-to-15-entry navigations named after the code (`Users`, `Roles`, `Permissions`, `Invoices`, `Payments`...), incomprehensible to a business operator, with the primary feature buried in the middle.

## Decision

Three non-negotiable constraints on any navigation sidebar:

### 1. Grouping by intent

Labels describe what the operator wants to accomplish, never a table or model name. Two modes depending on the app's nature: by **user goal** (Access management, Billing...) or by **workflow** (Request processing = intake + validation + closing).

### 2. Maximum 7 root-level items (Miller's Law)

The root sidebar never exceeds 7 entries. If the need exceeds 7, grouping into submenus or collapsible sections is mandatory — never add an 8th item without merging or removing an existing one.

Recommended slot order:
1. The lead feature (always first)
2–5. Business-intent groups
6. Reporting / Overview (if relevant)
7. Configuration / Settings (always last)

### 3. Highlighting the lead feature

Two combined mechanisms:
- **Position-1 item** with distinct visual treatment (accent color, a slightly larger Solar icon, a persistent selected background)
- **A pinned quick-action button** fixed at the top (`+ New request`, `+ Create a user`...) — the operator can act without navigating first

## Positive consequences

- Navigation understandable by a non-technical business operator
- Reduced cognitive load (7 choices max vs. 12–15)
- The most frequent action is 0 clicks away from any screen

## Negative consequences / risks

- Requires thinking through business intents before coding the navigation — moderate design overhead
- Groupings can be subjective: validate with the business side when ambiguous

## Alternatives considered

- **One item per model/table**: a technical navigation, incomprehensible to the operator. Rejected.
- **An unbounded, scrollable sidebar**: excessive cognitive load, important items buried. Rejected.
- **A quick-action button alone, no distinct lead item**: insufficient to guide the eye. Rejected.

## Scope

Back-office (Filament/Laravel) as a priority. Also applies to frontend application sidebars (Angular, React, Flutter).
