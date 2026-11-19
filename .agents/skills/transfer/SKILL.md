---
name: transfer
description: "Transfers the current work to Codex (OpenAI) when the assistant is close to its token limit: writes a handoff file (goal, plan, repository state, decisions, next step, test commands), then either runs Codex in an isolated worktree or prepares an interactive resume inside WSL. Human-only. Invoke on: /transfer, transfer to codex, I am close to the limit, hand over to codex, continue with codex."
model: claude-sonnet-5-5
type: utility
priority: medium
scope: cross
disable-model-invocation: true
dependencies:
  - codex-bridge
conflicts: []
---

# Transfer — Hand the work over to Codex

> **Unconfirmed in Antigravity.** Needs a shell that can run `wsl.exe` and Node.js 18 or later. Not
> tested under Antigravity. See `PORTING-NOTES.md`.

Human-only (`disable-model-invocation: true`). A transfer sends the code to OpenAI. The user decides
it. It never starts by itself.

A Codex plugin for the host IDE is not used here. Such a plugin starts the Windows build of Codex,
whose sandbox is blocked. Here, Codex runs inside WSL.

## Procedure

1. **Preflight**: run `bash .agents/skills/codex-bridge/scripts/codex-bridge.sh check`. Code 10, 11 or
   21: show the **Login block** of the skill `codex-bridge` in full, **then stop**. Until Codex is
   logged in, there is nothing to transfer. Code 12 (Codex quota exhausted): say so, with the return
   time. Offer to write the handoff file anyway, for a later resume.
2. **Handoff file**: write `.agents/tmp/transfer-YYYY-MM-DD.md` (git ignores it). It must be complete
   enough for an assistant without memory of the session to resume:
   - **Goal**: the real problem and the expected result, in two sentences;
   - **Plan**: the steps, with what is **done**, **in progress**, **to do**;
   - **Repository state**: branch, `git status`, summary of `git diff --stat`, last commits;
   - **Decisions taken** and their reason, **pitfalls met**;
   - **Next step**, precise, and the **test command** that tells if the work is finished;
   - **Constraints**: repository conventions to follow, prohibitions (no `git commit`, `git push`,
     secrets, network).
3. **Choose** (`AskUserQuestion`):
   - **Codex continues alone, in an isolated worktree** (non-interactive);
   - **Interactive resume**: the assistant prepares the command. The user opens Codex inside WSL.
4. **Consent** (for the first option, `AskUserQuestion`): "Codex (OpenAI) can read the whole
   repository in an isolated worktree and write there. Send?" If no: stay on the interactive resume,
   or stop.
5. **First option**: run `codex-bridge.sh worktree --slug transfer-<date>`, then
   `codex-bridge.sh exec --mode write --cwd .agents/worktrees/codex-transfer-<date> --prompt-file <handoff> --out .agents/tmp/transfer-<date>.out.md --confirmed`.
   Report the result with the exit code table of the skill `codex-bridge` (20: quota reached during
   the call, say that the work goes back to the user; other failures: quote the cause). On return,
   **merge nothing without reading**: follow the verification procedure of `codex-delegate` (diff,
   whole suite, commit as the single author).
6. **Second option**: give the exact command. The user runs it in a terminal:

   ```bash
   wsl
   cd <project path under /mnt/c/...>
   ~/.local/bin/codex "$(cat .agents/tmp/transfer-<date>.md)"
   ```

   Remind the user that Codex then reads the repository with its own rights. Read what it proposes
   before you accept it.
7. **Last word**: say what is transferred, where the handoff file is, and that **the assistant takes
   over again** (diff review, tests) when its limit is lifted.

## Limits to state

- Codex does not resume the conversation of the assistant. It knows only the handoff file. A more
  precise file gives a better resume.
- The free plan of Codex has its own quotas. A transfer can fail for lack of quota. The bridge
  detects it and the work goes back to the user.

⚠️ Fallback: if `codex-bridge` is unavailable, write the handoff file anyway and give it to the user
for a manual resume.
