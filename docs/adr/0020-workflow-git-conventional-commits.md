# ADR 0020 — Global Git workflow and Conventional Commits

- **Status**: accepted
- **Date**: 2026-07-13

## Context

Without a branch and commit convention, projects suffered direct pushes to `main`, verbose or unstructured commit messages, and untracked local merges. Coordination between Claude Code sessions and the human developer was difficult.

## Decision

A strict workflow, all projects:

### Branches

- `main` = production — direct push forbidden
- `develop` = integration — direct push forbidden
- `feature/*` / `bugfix/*` / `hotfix/*`: the only pushable branches

### Conventional Commits (strict)

Format: `type(scope): short description`

Types: `feat` · `fix` · `refactor` · `docs` · `test` · `chore`

Rules: imperative present tense · no capital letter · no trailing period · 72 characters max · 1 commit = 1 intent · **single author (the repo owner) — never a co-author**

### Hooks

- `pre-tool-use.sh`: blocks `git push origin main` and `git push origin develop`

### Claude Code behavior

- A Git command is requested → formulate it following these rules
- A forbidden action is attempted → correct it and explain why
- A new project → offer to install the hooks via `/git-workflow`

## Positive consequences

- Readable, traceable git history
- Protected production branches
- No Claude co-author in commits — the repo owner is the sole author

## Alternatives considered

- **Free-form commits**: unusable history, no automatable changelog. Rejected.
- **Direct push to main**: risk of production regressions. Rejected.

## Scope

Infra — all git projects.
