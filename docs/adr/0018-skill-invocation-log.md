# ADR 0018 — Skill invocation log

- **Status**: accepted — **revised 2026-09-17** (declarative mechanism replaced by a hook)
- **Date**: 2026-08-21 · revised 2026-09-17

## Context

Skill selection was opaque: there was no way to know after the fact which skill had been invoked,
in which project, and why.

The first version (2026-08-21) asked the model to emit a `[SKILL-SELECT]` YAML block before each
invocation and write it to `~/.claude/logs/skill-selection.log` "in dev mode." Finding on 2026-09-17:
the file still only held its 3 header lines since 08-25. An observability mechanism that relies on
the model's own discipline observes nothing.

## Decision

1. **The log is written by the harness.** A `PreToolUse` hook, matching `Skill`, script
   `~/.claude/skill-log.sh`: one line per Skill-tool call —
   `timestamp · skill · project · args` — into `~/.claude/logs/skill-selection.log`. The file isn't
   versioned (`logs/*.log` is in `.gitignore`).
2. **The `[SKILL-SELECT]` block becomes optional**: emitted only when routing is ambiguous
   (score < 75) to explain the arbitration to the user, with an `alternative:` line under 60.

```yaml
# [SKILL-SELECT]
skill:      dotnet-developer
score:      68
reason:     "*.csproj present, laravel-developer not applicable"
matched_by: router.backend[1]
alternative: general-engineer
```

Scoring scale kept as-is: 90–100 explicit trigger · 75–89 clear domain, router position #1 ·
60–74 position #2+ or `team-selector` arbitration · 40–59 strong ambiguity · < 40 `general-engineer`
fallback.

## Positive consequences

- An exhaustive, reliable trace, with no token cost in the conversation
- A factual basis for `improve-skills` and `retro` (real skill-usage frequency)
- The explanatory block only appears when it adds information

## Negative consequences / risks

- The hook doesn't record the *score* or the *reason*: those are only visible in ambiguous cases where the block is emitted
- Depends on `bash` (Git Bash on Windows), like the other hooks

## Alternatives considered

- **Keep the mandatory block**: never applied in practice, costly in tokens. Rejected.
- **Remove all observability**: loses the factual basis for skill review. Rejected.

## Scope

Cross-cutting — every invocation of the Skill tool.
