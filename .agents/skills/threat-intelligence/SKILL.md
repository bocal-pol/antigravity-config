---
name: threat-intelligence
description: "Security watch: detects OWASP Top 10 changes (new version, modified category) and new CVEs/security advisories affecting the technologies actually in use (current project's stack or the ecosystem's global list). Auto-invoke on: security watch, CVE watch, new flaw, what's new in security, new OWASP version, security advisory. Referenced by web-search as a consumer of contextual research."
model: claude-sonnet-5
user-invocable: true
argument-hint: "[project|ecosystem]"
type: utility
priority: medium
scope: security
dependencies:
  - web-search
  - version-checker
conflicts: []
---

# Threat Intelligence — OWASP & CVE Watch

Monitors two things that one-off audits (`appsec`, `pentest`, `security-agent`) don't cover,
because they analyze a frozen code state at a point in time: **the evolving OWASP reference**
(new Top 10 version, redefined category) and **newly published vulnerabilities** on
technologies the code hasn't changed but that became dangerous between two audits. A
project audited "clean" in January may be vulnerable in March without a single line of code
changing — this skill closes that gap.

Does not analyze code, does not score code-finding severity: that's `appsec`'s role.
Does not update dependencies: that's `dependency-updater`/`version-updater`'s role. This skill
**flags**, it doesn't fix.

## Optional Input (if invoked from `team-dev`)

If the project's stack is already known (output of `version-checker` or `architecture-agent`),
receive it directly and skip Phase 1.

## Two modes

- **`project`** (default if run from a project directory): detects the real stack via
  `version-checker` and cross-references it with recent advisories. Exact scope, never noise outside the project.
- **`ecosystem`** (default if run outside a project context, or explicitly requested): sweeps a
  fixed list of the technologies in this ecosystem (see Phase 1b), for an overview
  independent of any specific project.

## Workflow

### Phase 1 — Stack detection (`project` mode)

Invoke the `version-checker` skill on the current directory — reuse its Phase 1 manifest
detection (`composer.json`, `package.json`, `*.csproj`, `pubspec.yaml`, etc.) rather than
duplicating it. Get the list of detected stacks with their current version.

If no manifest is found: silently switch to `ecosystem` mode.

### Phase 1b — Reference list (`ecosystem` mode)

Fixed list, to be maintained as real projects are encountered — add a technology
as soon as a project uses it, never ahead of need:

```
Backend    : Laravel (PHP 8+), .NET 10+
Frontend   : Angular 21+, React 18+
Mobile     : Flutter, React Native
Infra      : Docker, Kubernetes, Nginx, Redis, RabbitMQ/Kafka
Auth       : Laravel Sanctum, generic OAuth2/OIDC, JWT (jsonwebtoken, firebase/php-jwt)
CI/CD      : GitHub Actions, GitLab CI
```

### Phase 2 — State of the last pass

Read `security/veille/.last-check.json` in the current project (`project` mode) or
`~/.claude/memory/threat-intelligence/.last-check.json` (`ecosystem` mode):

```json
{
  "owasp_top10_last_seen_version": "2021",
  "stacks": {
    "laravel": { "last_check": "2026-09-01", "cves_seen": ["CVE-2026-XXXXX"] },
    "jsonwebtoken": { "last_check": "2026-09-01", "cves_seen": [] }
  }
}
```

If the file doesn't exist: first pass, search window = rolling 90 days. Otherwise:
window = since `last_check` per stack, with a 7-day floor (to avoid missing an advisory published
just before the last pass and indexed late by the source).

### Phase 3 — OWASP Top 10 watch

Call the `web-search` skill with:
- `query`: "OWASP Top 10 latest version" + the currently known version (`owasp_top10_last_seen_version`)
- `context`: "check whether a new Top 10 version has been published, or whether an existing category's content has changed"
- Primary source: `owasp.org/Top10/` (official, versioned page)

If a new version exists (e.g. 2021 → 2025) or a category was redefined:
- Compare categories with those already covered by `architect` (Phase 2bis), `cadrage` (axis 6),
  `logging-architect` (Phase 5bis), `appsec`, `security-agent`, `security-audit`, `iam-engineer`.
- Produce a gap list: new categories not covered by the current ecosystem, renamed/merged
  categories whose existing coverage remains valid but mislabeled.
- **Do not automatically modify skills** — the gap is a finding to report (Phase 5), the
  skill update remains a human decision via a dedicated session.

If no change is detected since the last pass: note `OWASP Top 10: no change (version X still in effect)`.

### Phase 4 — CVE watch per technology

For each stack from Phase 1/1b, call the `web-search` skill with:
- `query`: "CVE <tech> <version>" + "security advisory <tech>"
- `context`: "CVE published since <Phase 2 window date>, severity, affected versions, available fix"
- Sources, in this order of preference:
  1. **GitHub Advisory Database** (`github.com/advisories?query=ecosystem%3A<npm|composer|nuget|pip>`) — covers most package ecosystems.
  2. **NVD** (`nvd.nist.gov/vuln/search`) — official CVE reference, useful for non-package CVEs (OS, engine, protocol).
  3. **Official changelog/release notes** of the project (`github.com/<org>/<repo>/releases`) — catches security fixes published before a formal CVE is assigned; look for "security", "CVE", "vulnerability" mentions in release notes within the window.

For each CVE/advisory found, extract: identifier (CVE-XXXX-XXXXX or GHSA-xxxx), severity (CVSS if
available), affected versions, fixed version, one-sentence summary, source link.

**Mandatory filtering before reporting**: a CVE is only relevant if the affected version range
overlaps the version actually used by the project (Phase 1) — never report a CVE on a
version range already superseded by the installed version. Compare explicitly.

### Phase 5 — Report

`project` mode: create the folder via Bash `mkdir -p security/veille`, write
`security/veille/YYYY-MM-DD_veille.md`:

```markdown
# Security Watch — YYYY-MM-DD

## OWASP Top 10
[No change | Gap detected: see below]

### Coverage gap (if applicable)
| OWASP Category | Status | Skills to update |
|---|---|---|

## CVE / advisories per technology

### [Tech] [installed version]
| ID | Severity | Affected versions | Fixed in | Summary | Source |
|---|---|---|---|---|---|

[Repeat per detected tech]

## No new alerts
[Technologies checked with no result, to trace that the watch covered the scope]
```

`ecosystem` mode: write `~/.claude/memory/threat-intelligence/YYYY-MM-DD_veille-ecosysteme.md`,
same structure, with no backlog section (no project to attach it to).

### Phase 6 — Backlog entry (`project` mode, mandatory if an active CVE is found)

Any CVE whose affected version range overlaps the installed version is an **active**
CVE — same severity rule as `appsec` findings: it's entered into the project's
`BACKLOG.md`, at the top of the overview (`## SEC — Security (priority 0)` section, `SEC-nn` rows), with:
- The CVE's summary and source link
- "Done when" = fixed version installed + `composer audit`/`npm audit` no longer shows it
- Priority `High (priority 0)` if CVSS ≥ 7 or if actively exploited publicly (mention "actively exploited"
  in the source), otherwise `Medium`.

Never enter an OWASP coverage gap (Phase 3) into the project backlog — that's an
ecosystem topic, not a defect of the audited project; noting it in the report is enough.

### Phase 7 — State update

Rewrite the state file (Phase 2) with `last_check` = today's date for each checked stack, and
`cves_seen` enriched with the found identifiers (to avoid re-reporting them identically in the
next pass — only **changes** to an already-known CVE, like a CVSS severity update,
are re-flagged in that case, not the CVE itself).

## Invocation from `team-dev`

- **`--full`**: invoke in Phase C (quality loop), alongside `security-agent`, or just before —
  active CVEs join the same P0/P1 correction dispatch mechanism (C4).
- **`--audit`**: invoke as a complement to `security-agent` in the relevant-profile selection
  (Phase A), systematically if a stack is detected.

## Fallback

If `web-search` is unavailable: note `⚠️ Watch not run — web-search unavailable` in the
report, keep the old state file unchanged (don't advance `last_check` without an actual
search, to avoid creating a silent hole in the watch window).

## Memorization

If a critical CVE (CVSS ≥ 9) or an OWASP version change is detected: log it in
the project's `.claude/security-knowledge.md` (`project` mode) or in `hindsight.md` if the lesson goes
beyond a single project (e.g. an entire ecosystem technology facing accelerated deprecation).
