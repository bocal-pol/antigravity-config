# Changelog

All notable changes to `antigravity-config`. Format
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), versioning
[SemVer](https://semver.org/).

**Versioning applies to the repository, not to each skill.** A `version:` field in every
frontmatter would be dozens of values to maintain by hand for information `git log` already gives.

What counts as a **breaking** (major) change: a `team-dev` mode removed or renamed, a skill removed
or merged, an agent renamed, a frontmatter convention that invalidates existing files. A skill can
be added or enriched without being a breaking change.

## [Unreleased]

### Added

- `.agents/scripts/audit-reminder.ps1`: ported from `claude-config`'s project `Stop` hook
  (blocks session end and asks to run a prompt audit when the prompt surface has unaudited real
  content changes), carried over with the same "unsupported, unconfirmed" caveat already used
  for the other 5 hook scripts there — Antigravity has no confirmed hook lifecycle equivalent,
  documented in `PORTING-NOTES.md` and `AGENTS.md`'s Known Limitations rather than fabricated.
- `security-agent`: three checks from the public "7 doors" checklist missing from its already
  broader OWASP coverage — an AI/third-party key exposed in the browser bundle plus production
  source maps, a payment webhook check (signature verification plus anti-replay/idempotency,
  dynamic scenario `D-WEBHOOK`), and signup abuse controls (rate limiting, email verification
  before free credits, an AI spend cap, dynamic scenario `D-SIGNUP`). Added a continuous watch
  mode in two parts: Phase 0b is a lightweight OPEN/CLOSED gate domain agents call after each
  implementation step, ported as-is since it depends on no hook system; Phase 0a (a `PostToolUse`
  hook that scans each changed file) is carried over as documentation of intent only, flagged
  unsupported/unconfirmed on this platform the same way as the other hook scripts, per the new
  `PORTING-NOTES.md` entry. `backend-agent`, `frontend-agent`, and `mobile-agent` now call the
  Phase 0b gate before marking any file touching auth, payment, a webhook, or a public route as
  done.

### Changed

- Migrated from Claude 5 to Claude 5.5 (`claude-opus-5-5` / `claude-sonnet-5-5` /
  `claude-haiku-5-5`) across 323 `model:` frontmatters (`.agents/skills/*/SKILL.md`,
  `.agents/*.md`), `AGENTS.md`, and the `ai-product-engineer` pricing example. Mirrors the same
  drift fixed upstream in `claude-config` (ADR 0016 revision) — new ADR 0016 revision entry added
  here too. The generic `gemini-pro` frontmatter example in `AGENTS.md` was left untouched
  (multi-provider example, not a Claude pin).

- `unlazy`: `NOT YET:` section in `GATES.md`, symmetric to `ABANDON:` — bounds over-completion
  (unrequested work an agent would do "to be thorough") the way `ABANDON:` bounds
  under-completion (an unproven gate explicitly waived). Step 6 (final report audit) now checks
  that nothing listed under `NOT YET:` happened along the way. Inspired by the "Not required
  yet" convention found in `bocal-pol/ai-hero` course material.
- `session-token-hardening`: prescriptive remediation for session cookies (HttpOnly, Secure,
  SameSite, `__Host-` prefix, ID regeneration after login/privilege elevation, CHIPS
  partitioning) and JWT (server-side algorithm allowlist against `alg:none` and RS256/HS256
  confusion, `kid`/`jku` validation) with corrected code examples for Laravel Sanctum,
  Express/`jsonwebtoken`, and .NET `Microsoft.IdentityModel.Tokens`. Coexists with
  `iam-engineer` (broad OAuth/RBAC detection) without replacing it. `security-agent` now
  invokes this skill in Phase 9c bis, alongside `iam-engineer` (Phase 9c).

## [1.3.0] - 2026-11-16

### Added

- `areopage`: decision panel skill.
- `dpo-toolkit`: real processing register and DPIA, wired into `project-bootstrap-agent` (Phase 6b)
  and `compliance-officer` (R-07/R-08 gaps); shared `.claude/country.md` jurisdiction convention
  (ADR 0076).

### Fixed

- `create-skill`: `tools` removed from the required skill frontmatter fields.
- `semgrep`: replaced hardcoded compose paths with a search fallback.
- Co-authorship guard in hooks scoped to actual commit/PR writes.

### Documentation

- `git-workflow`: documented the empty-repo bootstrap path.
- `laravel-developer`: documented Filament Wizard cross-step pitfalls.
- `team-dev`: documented background sub-agent tool limitations.
- `react-developer`: respects existing project folder conventions.
- `hindsight`: logged frozen PATH detection at session startup.

## [1.2.0] - 2026-11-12

### Documentation

- `isolation: worktree` documented for the four level-2 agents (backend, frontend, mobile,
  infrastructure). The underlying git-worktree mechanism has no confirmed Antigravity equivalent —
  see `PORTING-NOTES.md`.

## [1.1.0] - 2026-11-10

### Added

- `skillspector`: security scanner for third-party skills, agents, and MCP servers.
- `impeccable`: non-waivable floor rules ported from hallmark.
- `stack-diagram`: architecture diagram skill using real technology logos.
- `animate-lemo`: coded short-film skill (Lemo-Opuscar format).
- ASD-STE100 (Simplified Technical English) convention documented for English technical writing.
- Web performance checklists added across the stack and infrastructure skills.
- Anthropic prompt library wording discipline added to `team-dev` and `cadrage`.

### Fixed

- Protected-branch guard scoped to `origin` only (was tripping on unrelated remotes).

### Documentation

- `improve-skills`: documented the unported skillspector post-fix phase (not yet ported to this
  Antigravity format — see `PORTING-NOTES.md`).
- `skillspector`: documented install/output/max-skills pitfalls hit in practice.

## [1.0.0] - 2026-11-06 - Initial Antigravity-format port

### Added

- Initial Antigravity-format port of a private AI coding-assistant configuration: `AGENTS.md`,
  `primer.md`, `hindsight.md`, product rules, contributor guide, security policy, and the
  `.agents/` skill and agent structure.
- `PORTING-NOTES.md` and `RENAME-MAP.md` documenting the port's format uncertainties and every
  renamed agent/skill.

---

## Before this changelog

This repository starts fresh as a port; it carries no changelog history prior to this entry. The
source configuration's own history is not reproduced here.
