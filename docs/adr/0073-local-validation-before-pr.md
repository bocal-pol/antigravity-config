# ADR 0073 — Mandatory local validation before any Pull Request

- **Status**: accepted
- **Date**: 2026-10-30

## Context

The GitHub account used for this repo is a free account with no available CI credit: the "Skills,
agents and absolute paths" job (`.github/workflows/validate-frontmatter.yml`) systematically fails
with a billing-related error, regardless of the PR's content. In a single session, six consecutive
PRs failed for this reason, forcing an admin-override merge each time, with none of those PRs
actually having a real content problem.

Digging into the user's request to systematize a local check, the validation script itself
(`node .github/scripts/validate-frontmatter.mjs`) revealed a trap: run with no `git` available in the
call's PATH, it loses its filtering down to files tracked by git (`git ls-files`) and falls back to a
full disk scan — wrongly surfacing false positives on gitignored files (local settings, `memory/`).
The fallback was silent before this ADR.

## Decision

1. Before any `git push` of a branch destined for a PR, run the local checks equivalent to CI — for
   this repo, `node .github/scripts/validate-frontmatter.mjs` with `git` in the PATH.
2. Never push "to see if CI passes" when a local check exists and hasn't been run.
3. A CI bypass (an admin override) is only legitimate after a clean local check **and** explicit
   confirmation that the failure isn't content-related (e.g. a job that never started due to
   billing) — never assumed by default.
4. The validation script now explicitly warns when it falls back to degraded mode (a full disk scan)
   for lack of available `git`, instead of silently producing different results.

## Positive consequences

- A frontmatter or absolute-path problem is caught before the PR, not after a CI failure that then
  has to be told apart from a billing outage.
- The admin override stays traceable and justified — never a default reflex.
- The locally reusable script gets more reliable (no more silent false positives).

## Negative consequences / risks

- One more manual step before every push — a discipline cost, not automation (deliberately no
  `pre-push` hook added by this ADR: a hook that fails silently on a machine with a misconfigured
  Node setup would reproduce the very problem it claims to solve).
- Only covers projects that have a local equivalent to the CI check — a project without one stays
  dependent on CI, which should be flagged explicitly rather than giving a false sense of coverage.

## Alternatives considered

- **An automatic `pre-push` git hook**: harder to maintain correctly across machines (PATH, Node,
  permissions); the false positive discovered here (git missing from PATH) would have recurred
  silently in an unmonitored hook. Rejected in favor of an explicit discipline, revisable if a
  reliable hook is designed later.
- **Ignoring billing-related CI failures with no check**: the de facto practice before this ADR —
  risk of masking a real content problem behind a plausible but unverified billing excuse. Rejected.

## Scope

This repo first (a concrete script is available). The principle (check locally before pushing, never
assume a CI failure is unrelated to content) extends to any project with a local equivalent to its CI
check — complements [ADR 0020](0020-workflow-git-conventional-commits.md) (the global git workflow)
without replacing it.
