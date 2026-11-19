---
name: codex-review
description: "Read-only review by Codex (OpenAI) that produces an inconsistency report. The assistant verifies each finding, then fixes it. Three modes: report (review of the changes or of a folder), second-opinion (independent adversarial review before opening a PR), docs (audit of documentation against code: paths, commands, counters, rules that are declared but absent). If Codex is unavailable, the assistant does the review itself and says so. Invoke on: have codex review, codex second opinion, inconsistency report, docs vs code audit, review before PR, codex review."
model: claude-sonnet-5-5
type: utility
priority: medium
scope: cross
dependencies:
  - codex-bridge
  - code-reviewer
conflicts: []
---

# Codex Review — A second look, then the assistant fixes

> **Unconfirmed in Antigravity.** Needs a shell that can run `wsl.exe` and Node.js 18 or later. Not
> tested under Antigravity. See `PORTING-NOTES.md`.

Codex reads and reports. **It changes nothing.** The assistant verifies each point, then fixes what is
confirmed. The value of this skill is **independence**: another model reads what the assistant wrote.

## Optional input (when invoked from another skill or agent)

Receive: the **mode** (`report`, `second-opinion`, `docs`) and the **scope** (current changes, branch
against `develop`, or a folder). Do not ask these questions again. Consent stays mandatory. Return
the table of verified findings, without writing a file.

## The three modes

| Mode | Default scope | What Codex looks for |
| --- | --- | --- |
| `report` | Uncommitted changes, otherwise the last commit | Real bugs, inconsistencies between files, rules that contradict each other |
| `second-opinion` | Current branch against `develop` (before a PR) | Adversarial review: what would break in production, edge cases, security |
| `docs` | README, ADRs, install guide, instruction files against the code | A path, command, flag, counter or control that is **declared but does not exist** |

## Procedure

1. **Preflight**: run `bash .agents/skills/codex-bridge/scripts/codex-bridge.sh check`. Use the exit
   code table of the skill `codex-bridge`. Code 10, 11, 21: show the full Login block. **Fallback**
   (codes 10, 11, 12, 20, 21, 22, 23, 24): invoke the skill `code-reviewer` and say so. Say that the
   opinion is **no longer independent** of the assistant (it reviews its own work).
2. **Consent** (`AskUserQuestion`): "Codex (OpenAI) will read the whole repository, read-only. Send?"
   If no: fall back.
3. **Prompt** (`.agents/tmp/codex-review-<date>.md`), with: the mode and the scope; the useful read
   commands (`git diff`, `git diff develop...HEAD`, `git log`); the exclusion of `node_modules/`,
   `vendor/` and `*.test.*` from pattern searches; the prohibitions of the skill `codex-bridge`; and
   the **required output format**: one line per finding —
   `severity | file:line | exact quote | why it is wrong | proposed fix` — sorted by severity, with
   "clean" if nothing is found. Forbid style remarks that have no consequence.
4. **Run**: `codex-bridge.sh exec --mode review --cwd . --prompt-file <prompt> --out .agents/tmp/codex-review-<date>.out.md --confirmed`.
   Code 20 (quota) or another failure: fall back as above.
5. **Verify each finding** (rule "Agent findings verification"): take no action on an unverified
   finding. For each one: read the quoted `file:line`, **replay the proof** (command, grep, test).
   Classify it as **confirmed**, **not confirmed** or **out of scope**. Do not take the Codex severity
   as it is. If a high severity does not hold after reading, say so.
6. **Report**: write `reports/codex-review/YYYY-MM-DD_<mode>.md` (table of findings with their verdict
   and the proof). Then summarize in a few lines: how many confirmed, how many rejected and why.
7. **Fix**: propose the list of fixes for the **confirmed** findings. Apply them after the user
   agrees (one commit per intention, whole test suite run again). Do not fix a rejected finding.

## Limits to state

- Codex does not replace tests. A "clean" result is not a proof.
- Its severity is sometimes inflated (a P1 was already downgraded after reading). This is why step 5
  is mandatory.
- On fallback, the opinion comes from the assistant. It is less independent. Do not present it as a
  second look.

⚠️ Fallback: if `codex-bridge` is unavailable, invoke the skill `code-reviewer`.
