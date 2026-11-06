# ADR 0063 — MIT license and contribution governance

- **Status**: accepted
- **Date**: 2026-09-17

## Context

The `claude-config` repo moved from a personal configuration to an environment meant to be cloned by colleagues. A sharing audit on 2026-09-17 found it had no `LICENSE`, no `CONTRIBUTING.md`, no `SECURITY.md`, and no CI.

Legal consequence: **a published repo with no license is "all rights reserved" by default**. A colleague given the link formally has no right to clone, modify, or redistribute it — even on a private repo shared within a team. The absence of a license isn't permissive by default, it's the opposite.

Operational consequence: the repo imposed a Pull Request workflow on every project (ADR 0020) without applying that same tooling to itself. Nothing validated a contributed skill's frontmatter, even though the existing 172 skills were only compliant because a one-off migration script had normalized them.

## Decision

### 1. MIT license

Held by: the repo owner, 2026. Chosen for three reasons:

- It's compatible with skills already derived from MIT upstreams (`taste`, `impeccable`, `ponytail`), which a more restrictive license would put at odds with.
- The repo's content is conventions and prompts, not an asset to protect.
- It fits in two paragraphs, which matters for a repo whose entry cost is already high.

### 2. Automatic frontmatter validation

`.github/workflows/validate-frontmatter.yml` runs `.github/scripts/validate-frontmatter.mjs` on every PR to `develop` and `master`. The script fails if a `SKILL.md` is missing one of the eight mandatory fields, carries a `tools:` key (inert in a skill), has an improperly quoted value, a `model:` that isn't a known full identifier, a `name` that doesn't match its folder name — or if a file **tracked by git** contains a user-specific absolute path.

The script is written in Node with no dependencies: it runs identically in CI and locally on a Windows machine, which has neither `grep` nor `tail`.

### 3. Written governance

`CONTRIBUTING.md` (anatomy of a skill and an agent, git workflow, what CI checks), `SECURITY.md` (private reporting, what must never be committed), PR and issue templates.

## Positive consequences

- Reuse by a colleague becomes legally possible.
- Conventions stop relying on discipline alone: CI enforces them.
- The validation script is runnable locally before pushing, so CI isn't a wall discovered at the last minute.

## Negative consequences / risks

- **MIT can't be revoked.** A version published under MIT stays MIT for copies already distributed. This is what makes the decision hard to reverse, and therefore worth an ADR.
- The license covers the repo from the point it's adopted; it doesn't settle the question of content already pushed to the remotes before anonymization, which is a separate call.
- CI validates form, not relevance: a compliant but useless skill still passes.

## Alternatives considered

- **Apache-2.0**: a patent clause with no relevance here, and verbosity that adds nothing to documentary content. Rejected.
- **An internal proprietary license**: would have restricted sharing to one team, while most of the corpus (~130 skills) is generic and unrelated to any employer. Rejected.
- **CC BY-SA 4.0**: designed for editorial content, a poor fit for the repo's scripts and hooks. Rejected.
- **Staying unlicensed**: the observed state, which legally forbids the intended use. Rejected.

## Scope

Repo root, `.github/`. See also ADR 0020 (git workflow), 0016 (model identifiers), and 0062 (`~/.claude` as a git checkout).
