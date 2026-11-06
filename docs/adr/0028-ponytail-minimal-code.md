# ADR 0028 — Ponytail: minimal-code discipline before writing

- **Status**: accepted
- **Date**: 2026-08-21

## Context

Development agents tended toward over-engineering: introducing unnecessary dependencies, creating premature abstractions, writing more code than needed. This behavior increases technical debt and maintenance costs.

## Decision

Before writing or modifying code, walk the `ponytail` decision ladder in this order:

1. Does this feature need to exist?
2. Is it already in the codebase?
3. Does the stdlib cover it?
4. Does a native framework feature cover it?
5. Does an already-present dependency cover it?
6. Does a single line of code cover it?
7. Otherwise → write the minimum necessary

**Lazy about solutions, never about reading.** Read the existing code before writing.

Non-negotiable: validation, error handling, security, accessibility — these are never sacrificed for the sake of brevity.

## Positive consequences

- Reduces technical debt from the first commit
- Fewer dependencies = smaller attack surface, fewer updates
- More readable, more maintainable code

## Alternatives considered

- **Write then refactor**: the refactoring rarely happens. Rejected.

## Scope

Cross-cutting — `backend-agent`, `frontend-agent`, `mobile-agent`, all projects.

## 2026-09-11 amendment — aligning with upstream (ponytail v4.9)

Three upstream rules missing from the initial version are added:

1. **A bug fix targets the root cause**: grep every caller before editing; a guard in the shared function beats a guard per caller.
2. **Minimal verification**: any non-trivial logic leaves a runnable check (an assert / a `__main__` / a `test_*`); a trivial one-liner doesn't need one.
3. **The `ponytail:` marker is restricted** to real shortcuts with a known ceiling and a named upgrade path; a native or stdlib choice isn't marked.

The skill also gets a model-oriented `description:` frontmatter field (explicit triggers), previously missing.
