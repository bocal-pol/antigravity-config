# Primer — permanent project context

> Loaded at every session via `@primer.md` in `AGENTS.md`.
>
> **This file does not repeat conventions.** They live in `AGENTS.md`, which is loaded alongside it:
> duplicating them here would mean paying for them twice per session and creating two sources to
> resynchronize. It only contains what no other file says — the repository's purpose, its
> relationship to the source repository, and its counters.

## Purpose

This is an **Antigravity-format port of a personal AI coding-assistant configuration**, adapted for
the Antigravity agentic IDE (Google/Gemini). The source of truth lives in a private companion
repository; this repository is a best-effort translation of that content into English, reorganized
under Antigravity's `.agents/` convention, with agent and skill names clarified.

Single entry point: see `.agents/team-dev.md` for the orchestration entry point.

## Relationship to the source configuration — the least obvious point

**This repository is regenerated from a private source configuration, not maintained
independently.** Every modification must be made in the source first, then re-synchronized into
this repository and pushed — never edited here in isolation, or the two configurations silently
diverge.

Corollary, inherited from the source's own hard-won lesson: **a change made upstream is not a
change ported here** until this repository has actually been regenerated and pushed. Proof of
synchronization is a fresh commit in this repository's history referencing the source change, not
an assumption that porting "already happened."

## Counters

| Element | Count |
| --- | --- |
| Skills (`.agents/skills/*/SKILL.md`) | see `RENAME-MAP.md` for the current count |
| Agents (`.agents/*.md`) | see `RENAME-MAP.md` for the current count |
| ADRs (`docs/adr/`) | ported from the source repository, same numbering |

Navigation index: `.agents/SKILLS_INDEX.md` · `docs/adr/README.md` · `RENAME-MAP.md` (old → new
names) · `PORTING-NOTES.md` (what is ported, what is uncertain).

## Two conventions worth stating here

- **A persona agent is named after its function**, never after a real person (e.g.
  `legal-compliance-agent`, `survival-logistics-agent`, `hr-agent`).
- This repository carries no `scope: personal` content — anything personal to the maintainer was
  excluded from the port.

## References

| File | Content |
| --- | --- |
| `AGENTS.md` | All conventions — skills, agents, git, security, costs |
| `PRODUCT-RULES.md` | The product rules, detail and checklists |
| `README.md` | Structure, agent and skill catalog, installation |
| `CONTRIBUTING.md` | How to propose a skill or an agent |
| `hindsight.md` | Journal of lessons learned, dated entries |
| `PORTING-NOTES.md` | What was ported from the source configuration, and the format uncertainties found |
| `RENAME-MAP.md` | Old (source) name → new (antigravity-config) name, for every agent and skill |
| `.agents/router.json` | Single source of truth for Skill Router priorities |
