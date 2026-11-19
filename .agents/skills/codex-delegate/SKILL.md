---
name: codex-delegate
description: "Delegates a small coding task to Codex (OpenAI) to save the assistant's tokens: a local bug, a broken test, boilerplate unit tests to write. Codex works in an isolated worktree. The assistant reads the diff, runs the whole test suite again, commits as the single author and merges. If Codex is unavailable (not logged in, quota exhausted), the assistant does the task itself. Invoke on: delegate to codex, codex fix this bug, have codex fix this test, codex write the tests, save my tokens on this task."
model: claude-sonnet-5-5
type: utility
priority: medium
scope: cross
dependencies:
  - codex-bridge
  - fix-until-green
conflicts: []
---

# Codex Delegate — Give a small task to Codex

> **Unconfirmed in Antigravity.** Needs a shell that can run `wsl.exe` and Node.js 18 or later. Not
> tested under Antigravity. See `PORTING-NOTES.md`.

The principle: Codex does the mechanical, bounded work. The assistant keeps the judgment (read, test,
commit). If Codex cannot do the task, the assistant does it. A delegation never blocks the work.

## Optional input (when invoked from another skill or agent)

Receive: the **task**, the **success criterion** (a test command) and the **scope** (files or folders
that Codex may change). Do not ask these questions again. Consent to the send stays mandatory. Return
the report (see "Report") without writing a file. No cross-session memory.

## What to delegate — and what to keep

| Delegated to Codex | Kept by the assistant |
| --- | --- |
| A local bug that a command reproduces | Anything about authentication, permissions, secrets or billing |
| A broken test whose cause is in the product | An architecture or product decision |
| Boilerplate unit tests for existing code | Anything that needs several exchanges with the user |
| A small, bounded, mechanical refactoring | A task without a verifiable success criterion |

Size rule: the task fits in a few files and one command verifies it. If not, do it yourself. A
delegation saves nothing if the assistant must redo everything.

## Procedure

1. **Preflight**: run `bash .agents/skills/codex-bridge/scripts/codex-bridge.sh check`. Apply the table
   "Exit codes → action" of the skill `codex-bridge` (code 10, 11 or 21: show the full Login block;
   code 12: fall back). **On fallback, do the task yourself, without more ceremony.**
2. **Frame**: write the task in one sentence, the test command and the files concerned. Run the
   command **before** the work. Note the starting failure (the baseline). If no failure is
   reproducible, do not delegate.
3. **Consent** (`AskUserQuestion`): "Codex (OpenAI) can read the whole repository in an isolated
   worktree and write there. It will not commit or push. Send?" If no: do the task yourself.
4. **Worktree**: run `codex-bridge.sh worktree --slug <short-name>`.
5. **Prompt** (`.agents/tmp/codex-<name>.md`): include the task, the success criterion, the allowed
   files, "do not change existing tests" (except for a test-writing task), the minimal-code
   discipline, the prohibitions of the skill `codex-bridge` (secrets, `git commit` and `git push`,
   network), and a request for a short summary of what changed and why.
6. **Run**: `codex-bridge.sh exec --mode write --cwd .agents/worktrees/codex-<name> --prompt-file <prompt> --out .agents/tmp/codex-<name>.out.md --confirmed`.
7. **According to the exit code**:
   - **0**: go to the verification.
   - **20** (quota): read `git -C <worktree> diff`. **Continue from that diff**, or restart from zero
     if the diff is unusable. Finish the task yourself. Say "Codex reached its limit, I continue; I
     will try again at the next use".
   - **22** (sandbox) or **23/24**: fall back, with the cause in one line.
8. **Verify — do not trust Codex on its word**:
   - read the **whole** diff (`git -C <worktree> diff`): no file outside the scope, no secret, no test
     deleted, disabled or weakened (the integrity guard of `fix-until-green` checks this);
   - invoke the skill `fix-until-green`, and pass it the **whole suite** and the worktree as scope.
     Green means the whole suite, not only the target test;
   - if the diff raises a doubt, correct it or reject it. Never merge it "because it passes".
9. **Close**: commit in the worktree (Conventional Commits, one commit = one intention, **no**
   `Co-Authored-By` trailer, the user is the only author). Add a `CHANGELOG.md` entry. Merge into the
   working branch (`git merge --ff-only bugfix/codex-<name>`, otherwise `git merge --no-ff`). Then
   run `codex-bridge.sh worktree-clean --slug <name>`. Never merge into `develop`. Never push.

If the suite is not green at the end of the `fix-until-green` limits: merge nothing, leave the
worktree, say so, and offer to continue by hand.

## Report (3 to 6 lines)

Who did what (Codex or assistant fallback, and why), files touched, result of the whole suite
(**green / not green**), commit created, what was removed from the Codex diff.

⚠️ Fallback: if `codex-bridge` is unavailable, do the task with the assistant and say so in one line.
