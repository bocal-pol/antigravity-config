# ADR 0015 — Centralized Skill Router with a weighted strategy

- **Status**: accepted
- **Date**: 2026-08-21

## Context

Skill priorities were hardcoded in `AGENTS.md`, `team-dev`, and each agent separately. Changing a priority meant editing several files with a risk of drift. There was no single source of truth for domain arbitration.

## Decision

Centralize conflict resolution in `.router.json` (single source of truth) with a `weighted` strategy and a `general-engineer` fallback.

### Priority matrix by domain

| Domain | Decreasing priority |
| ------- | --------------------- |
| `frontend` | `react-developer` › `angular-developer` › `frontend-updater` |
| `backend` | `laravel-developer` › `dotnet-developer` › `backend-updater` |
| `infra` | `sre` › `devops` › `cloud-engineer` |
| `mobile` | `flutter-developer` › `react-native-developer` › `mobile-updater` |
| `data` | `data-scientist` › `data-engineer` › `analytics-engineer` |
| `security` | `appsec` › `security-architect` › `pentest` |

Changing priorities: edit `.router.json` only — never `AGENTS.md` or the agents directly.

## Positive consequences

- A single place to edit to change a priority
- No possible drift between agents
- An explicit, documented fallback

## Alternatives considered

- **Hardcoded per-agent tables**: impossible to maintain at scale. Rejected.

## Scope

Cross-cutting — orchestration, all agents.
