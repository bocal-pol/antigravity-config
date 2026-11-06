# ADR 0043 — New service: inherit the test harness from the closest sibling

- **Status**: accepted
- **Date**: 2026-09-17

## Context

Every new app in a monorepo (frontend, microservice, module) was born with no tests. The intent was always "we'll add the harness after the MVP" — and the app reached production with not a single test, absent from the CI workflows, with tooling versions drifted from its neighbors. Catching up on the harness afterward consistently cost more than copying it upfront.

## Decision

When creating any new app in a monorepo, three actions before any delivery:

1. **Copy the test harness from the closest sibling service** — same tooling versions, same configuration. Inherit, don't reinvent.
2. **Write at least one smoke test** — the service starts and responds on its main entry point.
3. **Add the app to the existing CI workflows** — both test **and** lint.

> An app with no test harness must not be shipped as "done."

The "closest sibling service" is chosen by stack similarity (same framework, same language), not by proximity in the directory tree.

## Positive consequences

- Consistent tooling versions across the whole monorepo: a version bump is driven once
- The smoke test catches bootstrap regressions (a missing dependency, an absent config) from the first commit
- CI covers the new app from day one, with no decision deferred

## Negative consequences / risks

- Inheriting the harness also inherits its flaws: a poorly configured sibling service propagates its debt
- Startup overhead for an app that might be thrown away after a prototype
- A smoke test alone gives a false sense of coverage — it's a floor, not a goal

## Alternatives considered

- **Harness added after the MVP**: never happens in practice. Rejected.
- **A harness rewritten from scratch for every app**: version drift, repeated cost. Rejected.
- **An in-house scaffold generator**: cleaner in theory, but one more generator to maintain. Rejected in favor of copying the sibling.

## Scope

Any new app in a monorepo — frontend, microservice, module. See also ADR 0042 (shared extraction). Source: the "New services in a monorepo" section of `AGENTS.md`.
