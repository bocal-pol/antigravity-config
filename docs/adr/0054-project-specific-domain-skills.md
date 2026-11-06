# ADR 0054 — Project-specific domain skills hosted in the global configuration

- **Status**: accepted
- **Date**: 2026-09-17

## Context

The ecosystem hosts families of skills that are neither technical expertise nor development roles, but the **domain knowledge of a specific personal project**:

- the creativity-theory family (7 skills) — idea-generation theories: slow hunch, bisociation, incubation, Zettelkasten, feedback loops, psychological safety, lifecycle. Domain knowledge for a personal idea-management project.
- the pilgrimage family (7 skills) — a long-distance pilgrimage route: itinerary, gear, lodging, food, points of interest, preparation, planning. Domain knowledge for a personal trip-planning project.
- `family-context` — a permanent family-and-interests context, read by several personal POs to avoid the user repeating themselves.

The question was where to keep them: in the relevant project's own steering file, or in the global configuration.

## Decision

These skills live in the **global configuration** (`~/.claude/skills/`), with a **domain-guardian agent** per family (the creativity-theory agent, the pilgrimage-route agent), registered in the PO registry (ADR 0049).

Three reasons:

1. **The knowledge predates the project.** Idea-generation theory and the on-the-ground reality of a pilgrimage route don't depend on a code repo existing. They remain valid even if the project is rewritten or abandoned.
2. **The guardian validates realism.** The pilgrimage-route agent checks data models, seeds, and pilgrim UX against on-the-ground reality; the creativity-theory agent plays the same role for its project. A guardian housed inside the repo it has to challenge would lose its footing.
3. **The knowledge is reusable outside the project** — a question about the route or about idea incubation doesn't require opening the corresponding repo.

**Limit**: this rule applies to **durable domain knowledge**, not to a repo's own conventions. A project's stack, coding conventions, and architecture stay in its own steering file and project memory.

## Positive consequences

- Domain knowledge survives the project being rewritten
- The guardian keeps a position independent of the code it validates
- This expertise is accessible outside any project context

## Negative consequences / risks

- **Bloats the global configuration**: 15 of 171 skills serve two personal projects, loaded for everyone
- The line between "durable domain knowledge" and "repo convention" requires judgment on every addition
- An abandoned project leaves its skills in place, with no removal mechanism

## Alternatives considered

- **Skills inside the project's own `.claude/`**: the guardian loses its independence, and the knowledge disappears with the repo. Rejected.
- **Markdown documentation with no skills**: loses invocability and `team-selector` routing. Rejected.
- **One catch-all skill per project**: unreadable and non-composable — the 7-skill granularity allows invoking just one. Rejected.

## Scope

The creativity-theory family, the pilgrimage family, and `family-context`, plus any future durable domain knowledge tied to a personal project. See also ADR 0049 (the PO registry).
