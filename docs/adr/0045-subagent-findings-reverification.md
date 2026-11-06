# ADR 0045 — Direct re-verification of subagents' Critical/High findings

- **Status**: accepted
- **Date**: 2026-09-17

## Context

Audit subagents (`security-agent`, `appsec`, `pentest`, exploration agents) produce findings from a partial, out-of-context read. Some are false positives: a "exposed" secret that's actually listed in `.gitignore`, a "duplicated" class that's really an interface, a "committed" key that only exists on disk. Reported as-is, these findings triggered costly or destructive actions — `git filter-branch`, key rotation, file deletion — over problems that didn't exist.

## Decision

Any **Critical** or **High** severity finding produced by a subagent must be **re-verified with a direct command** before:

- being reported to the user as fact, **or**
- triggering an action, especially a destructive one (`filter-branch`, secret rotation, file deletion, history rewrite).

Re-verification is a first-hand observation: read the file in question, run `git check-ignore`, grep the exact line. Not a second opinion asked of another agent.

An unverified finding is explicitly reported as **"unconfirmed"** — neither silenced nor presented as established.

## Positive consequences

- No destructive action triggered on a false positive
- The "unconfirmed" status keeps the information without giving it unearned weight
- Re-verification costs a few seconds against an unnecessary key rotation

## Negative consequences / risks

- Slows down reporting on large audits: every serious finding needs a round trip
- On an audit producing dozens of critical findings, exhaustive re-verification can exceed the session's budget — priorities then have to be set, and which ones stay unconfirmed stated
- Re-verification sometimes shares the subagent's blind spot if it reuses the same command

## Alternatives considered

- **Trusting the subagent**: the initial state, which produced destructive actions on false positives. Rejected.
- **Re-verifying every finding regardless of severity**: disproportionate cost for minor findings. Rejected in favor of the Critical/High threshold.
- **A second confirmation subagent**: two indirect reads aren't worth one direct observation, and double the cost. Rejected.

## Scope

Any orchestration producing findings — security audits, code reviews, multi-file explorations. See also ADR 0009 (mandatory evidence) and ADR 0046 (subagent discipline). Source: the "Verifying agent findings" section of `AGENTS.md`.
