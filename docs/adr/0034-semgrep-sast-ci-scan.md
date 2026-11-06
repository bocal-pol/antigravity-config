# ADR 0034 — Semgrep SAST + CI-Scan: security gates on PRs

- **Status**: accepted
- **Date**: 2026-08-21

## Context

Security vulnerabilities were caught late (manual review, external audit) or not at all. PRs were merged with no automatic scan. The `security-agent` skill needed a reproducible SAST tool.

## Decision

Integrate Semgrep SAST via Docker Compose + CI-Scan for PR automation:

### Mandatory rulesets

- `p/owasp-top-ten` — injection, XSS, auth, etc.
- `p/secrets` — hardcoded API keys, passwords
- `p/php` — Laravel patterns
- `p/typescript` — React/Angular patterns

### Workflow

- **Security audit Phase 6b**: local Semgrep via Docker Compose
- **`ci-scan` skill**: configures automated scans on the repo's PRs (falls back to Strix if Semgrep is unavailable)
- P0/P1 findings: block progress / merge
- P2/P3: listed, non-blocking

## Positive consequences

- Vulnerabilities caught before merge, not after deployment
- Standardized rulesets = comparable results across projects
- No dependency on manual review for common patterns

## Negative consequences / risks

- Docker required for local Semgrep
- Possible false positives — requires per-project ruleset calibration

## Alternatives considered

- **Manual scanning only**: not reproducible, forgotten in practice. Rejected.
- **ESLint/PHPStan alone**: code quality, not security. Complementary, insufficient alone.

## Scope

Security — all projects with code (backend, frontend, mobile).

## 2026-09-11 amendment — aligning the Strix fallback with upstream (v1.6.x)

- Fixed environment variables: `STRIX_LLM` (model, e.g. `openrouter/z-ai/glm-5.3`) + `LLM_API_KEY` replace `OPENAI_API_KEY`, which the CLI doesn't read.
- Fixed SARIF path: the run writes to `strix_runs/<run>/`, with no `latest` alias; the upload points to the directory.
- **Fail closed**: a step reads `strix_runs/*/run.json` and fails if `status != completed` (a scan stopped on budget otherwise returns exit `0`).
- Explicit diff scope: `--scope-mode diff --diff-base origin/main`.
- Richer managed option via the `strix cloud` CLI (login, `integrations install github`, `pr-reviews`, `scans start --source . --dry-run --show-files` then `--approve-sha256`, `scans sarif`), which appeared upstream on 2026-09-01.
- Not adopted: Strix's MCP support (2026-08-24, concerns pentest runs, not CI) and upstream's `application-security-testing` / target-specific skills (already covered by `pentest` and `appsec`).

## 2026-09-25 amendment — a standalone `strix` skill for local agentic pentesting

Strix (`usestrix/strix`, Apache 2.0, ~65k stars — a legitimate, active project, verified) had so far
only played a CI-fallback role inside `ci-scan`. Gap identified: unlike
Semgrep (which has a dedicated `semgrep` skill for local use), Strix was only invokable locally
through scattered mentions in the security audit workflow, with no skill of its own and no guardrail discipline.

- **New skill `skills/strix/SKILL.md`**: local/interactive use (one-off audits,
  security audit Phase 6b bis) — distinct from `ci-scan`, which stays the CI/PR use case.
- Flags confirmed against upstream documentation (docs.strix.ai): `--scan-mode`
  (`quick`|`standard`|`deep`, default `deep`), `--scope-mode` (`auto`|`diff`|`full`, default
  `auto`), `--max-budget` (cumulative USD, no default limit), `--max-turns` (default 500).
- **Documented security gap**: Strix offers **no dry-run for a local scan**
  (`--dry-run --show-files --approve-sha256` only exists for the cloud path, which previews
  the upload). A local scan starts agentic execution on invocation, with no application-level
  confirmation — only a documentation warning exists upstream. The `strix` skill compensates
  with an explicit guardrail step (authorization confirmation, verifying the target isn't
  production with no approved window, a mandatory `MAX_BUDGET`/`MAX_TURNS` cap before any real call).
- Invocation from the security audit workflow made **optional** (an `AskUserQuestion` prompt), not
  systematic like Semgrep: Strix is slower (default mode runs 1-4h) and billed in LLM usage.
