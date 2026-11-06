# ADR 0001 — Mandatory session revocation after logout

- **Status**: accepted
- **Date**: 2026-08-20

## Context

A flaw was found in production: after logout, a protected URL copied before logout remained accessible. The session wasn't revoked server-side — only localStorage was cleared client-side. The user believed they were logged out, but their data stayed exposed.

## Decision

Every login/logout flow must be followed by an **automated revocation test via Playwright**: login → copy a protected URL → logout → navigate to the URL → verify access is refused (401/302, no sensitive content).

Invalidation must happen server-side (token/cookie invalidated in the database or a blocklist), not just a client-side localStorage clear.

### Mandatory completion criteria

1. After logout, any protected URL returns a redirect to login (not silent access, nor a 403 with sensitive content)
2. The revocation test is automated via Playwright
3. Invalidation happens server-side
4. The test covers both directions: frontend (redirect) and backend (HTTP 401/302)

An auth flow without a revocation test = an unfinished task.

## Positive consequences

- Eliminates an entire class of post-logout session-hijacking vulnerabilities
- The Playwright test acts as a permanent CI guardrail

## Negative consequences / risks

- Requires a token blocklist or database-backed invalidation (moderate backend overhead)
- Stateless JWTs require a blocklist or a very short lifetime

## Alternatives considered

- **Clearing localStorage alone**: insufficient — the token stays valid server-side. Rejected.
- **Short token lifetime with no revocation**: improves the situation but doesn't guarantee immediate revocation. Insufficient on its own.

## Scope

All projects with authentication, both frontend and backend.
