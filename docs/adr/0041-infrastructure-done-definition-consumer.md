# ADR 0041 — Definition of "done" for infrastructure: service + consumer + proof

- **Status**: accepted
- **Date**: 2026-09-17

## Context

An infrastructure service was regularly declared "in place" as soon as its container started: Redis was running but no application connected to it, a queue was declared but no worker consumed it, a MinIO was provisioned with not a single file ever passing through it. `docker compose ps` was green, yet nothing was actually wired up — the failure only surfaced in production, on first real use.

## Decision

Adding an infra service (Redis, a queue, MinIO, a mailer...) isn't done until **all three** conditions are met:

1. **The app config points to it** — both `.env` **and** `.env.example` updated (`.env.example` shapes the next developer's machine).
2. **A consumer runs if needed** — e.g. a queue worker declared in `compose`, not just the broker.
3. **A verification proves real use** — observed traffic (`redis-cli MONITOR`), a test job processed (`php artisan queue:work`), an object written then read back.

> A service running with no consumer = an unfinished task.

Proof of use is an observation, not a declaration: it produces a citable command output, in the spirit of ADR 0009's acceptance gates.

## Positive consequences

- Eliminates the "the service was there but nobody used it" class of incidents
- `.env.example` stays in sync, which makes bootstrapping new machines more reliable
- The proof of use serves as a reusable CI gate

## Negative consequences / risks

- Lengthens the task: starting a service isn't enough anymore, it has to be wired up and proven
- Some proofs require a full environment (worker + broker + app), costly locally
- Connection secrets must be managed outside `.env` (see ADR 0002), which complicates point 1

## Alternatives considered

- **Container healthcheck as the sole criterion**: proves the process is alive, not that it's useful. Rejected.
- **Integration test deferred to the next sprint**: exactly what produced the production failures. Rejected.

## Scope

Any infrastructure task, across all projects — backend, DevOps, platform. Source: the "Definition of done for infrastructure" section of `AGENTS.md`.
