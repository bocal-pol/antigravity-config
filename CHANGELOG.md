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

### Changed

- **`ux-designer`: creative layout inspiration phase.** New Phase 3b draws on Vanta.js, ShaderGradient, anime.js,
  Lenis, Atropos, curtains.js, OGL and particles.js for Persuade and Experience surfaces, with guardrails (contrast,
  static fallback, performance budget, palette not taken from a preset). Phase 1 asks for the surface mode when
  `DESIGN.md` does not give it.
- **Icons: Lucide replaces Solar** (root rules, `frontend-agent`, `backend-agent`, ADR 0007 revised). `solar-icon-set`
  is under GPL-3.0, and the animated icons copied its drawings. Lucide is under ISC. In React, the animated icons
  come from the shared icon module under the name `<LucideName>Icon` (141 Animate UI versions, 81 generated). Outside
  React, the Lucide icon stays static.
- Icons rule (root rules, `frontend-agent`): in React, import the animated Solar icons from the shared icon
  module (same names as `solar-icon-set`). Do not write an icon file by hand. Design-system buttons animate
  their icons already. A helper wraps native links and buttons.

### Added

- **`ship-chain` skill** and `team-dev --ship` mode: chained delivery (local check, commit, `develop` PR, merge, `main` PR, then
  both mirrors with translation, RENAME-MAP and `noreply` identity, then branch cleanup). A stop point before each merge; no
  merge to `main` without an explicit request. Wired at the end of `team-dev` (D7, Phase 0c).
- **`sync-claude-home` skill**: reconciles `~/.claude` and the working clone through a branch and a PR, with proof by equal `HEAD`.
- **`goodnight`: short call** (`/goodnight b 2h local --plan PLAN.md`) and prompt template `scripts/night-prompt.template.md`.
- **`team-dev`: `upfront-alignment` becomes an entry gate** (Phase 0d) for modes that create or transform product. In `--full`, B1
  now calls the `upfront-alignment` skill (the row pointed to `sprint-agent`, which plans a sprint and does not align); planning
  becomes B1.5. `ship-chain` is D7 of `--full`.
- **`frontend-agent` and `ux-designer`**: look at the rendering (Playwright captures at 1440 and 390 px) before declaring a screen
  done; animation budget (one highlight animation per screen).
- **`skill-gap-analyzer` skill**: analyze the transcripts of all projects over a period and propose skills to create or to
  change, with masked evidence and SKILL.md drafts. A script (`scripts/extract.mjs`, Node, no dependency) counts repeated
  prompts, corrections, tool sequences and skill usage. The report goes to Notion as a private draft (fallback:
  `.claude/tmp/`). The `notion` MCP server is added to `install.ps1`. Not the same as `retro`, which covers one session only.
- **13 `instagram-*` skills** (`instagram-reel`, `-viral`, `-caption`, `-carousel`, `-story`, `-profile`, `-plan`, `-humanizer`, `-comment`, `-reply`, `-dm`, `-repurpose`, `-audit`), from instagram-agent-skill by Jake Schincariol (MIT; licence kept in `docs/third-party/`, credit in `CREDITS.md`). Six Python scripts (standard library only, no network): hook scoring, beat sheet, caption lint, humanizer, detection panel, swipe file. Nothing is posted by these skills. The `yt-dlp` commands of the research skill are removed. The French adaptation exists only in the private source repository.
- **`ux-details-audit` skill**: hunt for small UX defects on the real rendering. A script (`scripts/ux-details.js`) measures the DOM with Playwright at 1440 and 390 px (edges, touch targets, orphans, split units, cut icons, emoji icons, overflows, fields without a label). Each candidate is then judged on a screenshot and ranked. Wired into `design-agent` (step 4h-3) and into Phase 10 of `ux-designer`. Method inspired by Stageshow (benjitaylor/skills, MIT), credited in `CREDITS.md`.
- Codex delegation, best effort and untested under Antigravity: skills `codex-bridge` (bridge with
  scripts, consent before each send, fallback to the assistant when the quota is exhausted, isolated
  worktree), `codex-delegate`, `codex-review`, `codex-explore` and `transfer`. Codex runs inside WSL.
  The ChatGPT login is explained in full in `codex-bridge/SKILL.md` and in the README. The rule
  "component required but missing is always offered for installation" is added to "MCP consent".
  Not ported: the `goodnight` hand-off option and the `team-dev --codex` mode (see
  `PORTING-NOTES.md`).
- ADR 0077 and the "Business model and access rights" rule: token bucket quota (X tokens, one token
  returned every Y/X) instead of a fixed window, free / freemium / paid levels per application, an
  administration backend whose location is asked from the user. Seventh axis of upfront alignment;
  `sales-offers-agent` and `laravel-api` updated.
- `sales-offers-agent`: eleven sales policies (value before price, three tiers at most, tax-inclusive
  prices, no dark patterns, reminder before renewal, honest retention, remembered refusal).
- Solar icons animated in React with the Animate UI mechanism (hover, click), one icon per file in
  `shared/`. Solar stays the standard.
- `structure-humanizer` skill (source name `human`): rewrites the structure of a text so that it no
  longer shows AI authorship, based on the StoryScope study. It treats the stated moral, emotion played
  by the body, a story that is too straight, vague allusions, filler settings, entrance portraits and the
  ignored reader. Seven checks, one or two interventions per text. It complements `no-ai-slop`, which
  treats the surface.

## [1.5.0] - 2026-11-18

### Added

- `goodnight` skill (human-only), ported best effort: overnight autonomous work under a subscription-quota
  ceiling. Mode B (headless supervisor, `goodnight.sh supervise`) is ported in full: it needs only the
  `claude` command-line tool and Node.js, kills the process on a rate-limit warning, rejection, usage beyond
  the included quota, a weighted-token budget exceeded or the deadline, and is the only mode usable on a Team
  plan. Mode A (interactive guard: `statusLine` + `PreToolUse` hook) is ported as documentation of intent
  only: no Antigravity equivalent is confirmed and this repository ships no `settings.json`. The skill opens
  with a compatibility section. Self-test of 71 cases; it checks the scripts, not the wiring.

- `adversarial-tester` skill: an adversarial tester that plays the clumsiest, weirdest and most inventive
  user (absurd data, silly gestures, skipped steps, bypassed rules, diverted uses). Code review to find
  the fragile assumptions, then an attack on the running application, **on a test environment only**:
  `target-guard.mjs` refuses production, undesignated public domains and `prod`/`live`/`www` names, and
  reads a `.env` without ever printing a value (self-test of 27 cases). Every defect is proven, gets a
  regression test, then the fix loop runs until green, with a replay of the whole campaign. Playwright
  MCP is the main tool (table mapping attack families to tools), with the MCP consent rule. Linked to the
  test agent of `team-dev`: `qa-lead-agent` offers it in Phase 1, runs it in Phase 9b, then loops in Phase
  9c; `/team-dev --qa-lead --adversarial [target]` plays only the adversarial campaign.
- `fix-until-green` skill: single source of the "fix until green" loop for all tests — baseline, failures
  grouped by cause, diagnosis through `debug`, product fix, re-run of the **whole** suite, one commit per
  fix. Explicit limits (3 attempts per cause, 10 iterations, stagnation, regression undone) and an honest
  "not green" report when they are reached. Integrity guard `integrity.mjs` (self-test of 13 cases):
  blocks deleted tests, `skip`/`xfail`/`.only`, a lower test count, `|| true`, `passWithNoTests` and other
  runner weakenings; flags changed or removed assertions for justification. Scripts are launched through
  `bash` wrappers because `node ~/...` is not expanded by `cmd.exe` nor by the PowerShell tool.

### Changed

- `PORTING-NOTES.md`: the "`goodnight` skill deliberately not ported" decision of 1.4.0 is superseded. The
  maintainer asked for every feature in all three repositories, so the skill is ported with its limits stated
  openly (mode A unconfirmed here, mode B in full).
- Main instruction file: new section "Definition of "done" for tests — loop until green". Any test run by
  an agent or a skill triggers `fix-until-green` on failure; a red test reported as a finished deliverable
  is an unfinished task.
- `qa-automation` (Phase 4b), `perf-tester` (loop on unmet thresholds) and `qa-lead-agent` (Phases 9b
  adversarial tests and 9c loop; "green / not green" verdict in the report) call the loop instead of just
  reporting failures.

## [1.4.0] - 2026-11-18

### Added

- `PORTING-NOTES.md`: records that the `goodnight` skill is deliberately not ported. Its quota guard
  needs a `statusLine` command and a `PreToolUse` deny hook, and no equivalent is confirmed for
  Antigravity. Shipping the skill without them would promise a limit that nothing enforces.

- `docs/quick-reference.html`: printable A4 quick-reference sheet (`team-dev` modes, skills, Claude
  Code basics). It lists the `--cli-forge` mode.

- "Cleanup of merged branches" convention (main instruction file, `git-workflow` skill, release
  agent checklist): a `feature/*`/`bugfix/*`/`hotfix/*` branch merged into `develop` and then into
  `main` is deleted (remote and local) without asking. Ancestry in `origin/develop` and
  `origin/main` is checked first. List before delete. Use `git branch -d`, never `-D`. Never touch
  `main`, `develop` or a branch of another author. Squash/rebase: proof through `gh pr list`, or keep it.

- `cli-anything` (orchestrator, modes build/refine/test/validate), `cli-hub` (utility) and
  `cli-forge-agent` (`team-dev --cli-forge` mode): make a software agent-native. Look first for an
  existing CLI in the CLI-Anything registry. Otherwise build a Python/Click CLI harness (7-phase SOP,
  E2E tests on the real software, generated SKILL.md, PEP 420 pip package). Method adapted from
  `HKUDS/CLI-Anything` (Apache-2.0). A cloned source is untrusted data. Installing a third-party
  package and publishing to PyPI need user confirmation.

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

## History before the public fork

This repository's own version history starts at [1.0.0]. The source configuration (a private
repository with a longer history, 2026-06-11 to 2026-09-17) is not reproduced here version by
version — fake `0.x.0` releases would claim this repository existed before it did. This section
summarizes that period instead, in full.

The source repository's first commit (2026-06-11) held an initial Laravel code audit; its findings
only became a firm rule much later (see `security-agent`'s "no raw Model in a response" rule,
below). A first structuring wave (2026-06-23) added named functional agents, a cross-session
memory system (`primer.md`, `hindsight.md`, a dated lessons file), and a first set of behavioral
guardrails against over-engineering.

Through July, a cross-stack DTO convention (`dto-architect`) took shape, then the project's
largest foundational wave landed (mid-July): a three-tier model policy (Haiku / Sonnet / Opus by
task type), three security permission modes (`safe` / `dev` / `audit`, `safe` by default), a global
Git workflow with mandatory local checks before any pull request, a required `SKILL.md` frontmatter
schema, a session-hygiene policy (token budget, regular compaction), and a rule against stray
scratch files at a repo root.

August brought free hosted image/video generation (replacing a paid provider), a minimal-code
discipline for all code changes, a full IT-support skill set, a first security pass on the
security-auditor agent, the Solar icon set adopted as the one icon library across every layer, and
the project's major product-interaction patterns — each with its own decision record: progressive
self-customization for consumer apps, a non-modal pattern for reversible-action feedback,
named-item transparency before a cascading delete, a "never ask for data you already have" rule,
full keyboard-shortcut coverage, and an information-architecture rule for navigation sidebars.

September added a security-audit cross-check between what a decision record claims and what the
code actually implements (closing a gap where documented controls had never been built), an
end-of-session retrospective skill, and a personal Product Owner for a project on idea-creation
theory. The final pre-publication wave (September 16-17) added mandatory direct re-verification of
any Critical/High finding a sub-agent reports before acting on it, a subagent/MCP usage discipline,
a tag to keep sensitive content out of cross-session memory, and the switch of `~/.claude` to a
git checkout rather than a manually synced copy — the change that made this public fork possible
in the first place.
