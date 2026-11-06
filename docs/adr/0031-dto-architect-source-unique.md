# ADR 0031 — DTO Architect: the single source of truth for cross-stack DTO conventions

- **Status**: accepted
- **Date**: 2026-07-13

## Context

DTOs (Data Transfer Objects) were named and structured differently depending on the developer, the framework, and the project. No consistency between Laravel, .NET, Angular, React, Flutter. Raw APIs (direct Entity/Model exposure) caused frontend breaking changes on every schema migration.

## Decision

Create `dto-architect` as the single source of truth for cross-framework DTO conventions:

### Naming conventions (strict)

- `RequestDto` — API input
- `ResponseDto` — API output
- `EventDto` — events/messages

Never a bare `Dto`, never a raw Entity/Model exposed via the API.

### Structure by framework

| Framework | Path |
| --------- | ------ |
| Laravel | `app/DTOs/{Requests,Responses}/` |
| .NET | `src/Application/DTOs/{Requests,Responses}/` |
| Angular | `src/app/core/{dtos,mappers}/` |
| React | `src/{dtos,schemas,mappers}/` |
| Flutter/RN | `lib/data/{dtos,mappers}/` |

8 development skills depend on `dto-architect`: laravel-developer, dotnet-developer, angular-developer, react-developer, flutter-developer, react-native-developer, laravel-api, integration-developer.

## Positive consequences

- A stable API contract: internal changes (DB migrations) no longer break the frontend
- Cross-stack consistency: the same vocabulary everywhere
- Centralized validation at the API boundary

## Alternatives considered

- **Raw Entity exposed via the API**: breaking changes on every migration. Rejected.
- **Per-project conventions**: fragmentation, impossible to maintain. Rejected.

## Scope

Backend, frontend, mobile, integration — all projects with an API.
