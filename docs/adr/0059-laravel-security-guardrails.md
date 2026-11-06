# ADR 0059 — Laravel: mandatory API Resources, auth by default, secret-free logs

- **Status**: accepted
- **Date**: 2026-09-17

## Context

An audit of generated Laravel code (2026-06-11) surfaced three recurring flaws. Their origin wasn't carelessness — they were **prescribed by the skills themselves**. `laravel-developer` and `laravel-api` set it as an absolute rule to return data "with no API Resources," specified no authentication boundary check anywhere, and nowhere forbade logging secrets.

The skills meant to produce safe code were therefore producing the same three vulnerabilities on every endpoint.

## Decision

Three absolute rules for any generated Laravel code.

### 1. Never a raw Model in a response

Always go through an **API Resource** (`JsonResource`) as soon as a Model carries sensitive fields or relationships.

`response()->json($model)` serializes the whole object: `remember_token`, the password hash, internal columns, and any relationships loaded alongside them. The resource explicitly defines what gets exposed.

### 2. Authentication by default

Every route is `auth:sanctum` **unless explicitly justified otherwise** — login, an OAuth callback, a signed webhook. No dynamic public route.

The exception is justified in writing, at the point it's written; a missing middleware is never an acceptable default.

### 3. Secret-free logs

Never a plaintext password, hash, token, or personal data in `Log::`, **even for debugging**. Prefer `$e->getMessage()` over the full exception when it might carry credentials (a `QueryException` contains the query, and therefore its bound parameters).

## Positive consequences

- Closes the leak of internal fields via automatic serialization
- Authentication becomes the default and public exposure an explicit, traceable decision
- Logs stop being a secondary exfiltration vector

## Negative consequences / risks

- A `JsonResource` class per exposed entity: real overhead on small APIs
- `auth:sanctum` by default breaks legitimate public endpoints until the exception is declared
- Trimming exception logs makes production diagnosis harder — a correlation ID must be logged instead

## Alternatives considered

- **`$hidden` on the Model**: covers fields known at write time, but a column added later leaks by default. Insufficient alone.
- **Authentication middleware applied route by route**: the exact state that produced the flaw — omission is silent. Rejected in favor of the inverse default.
- **Post-processing log filtering**: the secret has already been written to disk. Rejected.

## Scope

All generated Laravel code, across all projects. See also ADR 0004 (API response format), 0002 (secrets), and 0006 (resilience). Operational detail: the "Security guardrails" section of `skills/laravel-developer/SKILL.md`.
