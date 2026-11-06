# ADR 0050 — SKILL.md writing conventions outside the frontmatter

- **Status**: accepted
- **Date**: 2026-09-17

## Context

ADR 0021 sets the mandatory frontmatter metadata. The **body** of SKILL.md files had no convention, with four drift patterns observed across a corpus of 171 skills:

- hardcoded user-specific absolute paths, which break the skill on another machine;
- `Grep` instructions with no exclusions, which pulled back thousands of results from `node_modules/` and `vendor/`;
- dependencies between skills expressed as a `/skill-name` slipped into prose, which the model read as plain text and never invoked;
- human-only skills invoked by other skills, bypassing the user's decision.

## Decision

### 1. Portable paths

`~/.claude/` only in SKILL.md files. **Never a user-specific absolute path** — the repo gets deployed to different machines (ADR 0048).

### 2. Systematic search exclusions

Every `Grep` instruction excludes `node_modules/`, `vendor/`, and `*.test.*`.

### 3. Dependency between skills: explicit invocation

A dependency is written as **"Call the Skill tool with `name`"** — one call per skill, two calls for two skills. Never a `/name` in prose.

A skill marked `disable-model-invocation: true` is **reserved for the human**: no other skill calls it; the user is asked to run it themselves.

### 4. Child-skill contract

Input and output documented, plus a ⚠️ fallback behavior if the child skill is unavailable.

### 5. Orchestrable skills

An "Optional input" section, skipping memory writes, and conditional persistence — so a skill called by an orchestrator doesn't write stray memory.

### 6. Frontmatter text fields

`description:` is mandatory and model-oriented (concrete triggers), **quoted** as soon as it contains a colon followed by a space or starts with a special character. Same rule for `argument-hint` starting with `[`, otherwise the YAML fails to parse.

## Positive consequences

- Skills work identically on any machine where the repo is deployed
- Inter-skill dependencies actually execute instead of staying decorative
- Grep exclusions massively cut noise and the contextual cost of searches

## Negative consequences / risks

- Purely editorial conventions: nothing validates them automatically at write time
- An unquoted `description:` silently breaks the skill's loading — the symptom is a "missing" skill, not an explicit error
- The explicit-invocation rule adds overhead when writing heavily chained skills

## Alternatives considered

- **Extending ADR 0021**: 0021 covers structured, machine-readable metadata; these rules cover body writing. Distinct subjects, distinct ADR.
- **A SKILL.md linter**: desirable, but one more tool to maintain; worth considering if violations persist. Not adopted for now.
- **Leaving the body free-form**: the initial state, the source of the four observed drifts. Rejected.

## Scope

The ecosystem's 171 SKILL.md files. Complements ADR 0021 (frontmatter). Source: the "Skill conventions" section of `AGENTS.md`.
