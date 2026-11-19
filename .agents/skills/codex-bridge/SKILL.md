---
name: codex-bridge
description: "Bridge to Codex (OpenAI, installed in WSL): checks that Codex is ready (WSL, installation, ChatGPT login, quota), tells the user how to log in when it is not, runs Codex with the user's consent, handles the fallback to the assistant when the quota is exhausted, and creates isolated worktrees. Single source of the call to Codex, used by codex-delegate, codex-review, codex-explore and transfer. Invoke on: codex, delegate to codex, codex is not logged in, log in to codex, codex quota, codex unavailable."
model: claude-sonnet-5-5
type: utility
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Codex Bridge — Call Codex without surprises

> **Unconfirmed in Antigravity.** This skill needs only a shell that can run `wsl.exe` and Node.js 18
> or later. Nobody has tested it under Antigravity. See `PORTING-NOTES.md`. If the shell cannot run
> `wsl.exe`, skip Codex and do the work with the assistant.

Codex is a second coding assistant, made by OpenAI. It saves the assistant's tokens on small tasks. It
also gives an independent second opinion. Codex is optional. If Codex is unavailable, the assistant
does the work itself.

This skill is the **only** definition of the call to Codex. The skills `codex-delegate`,
`codex-review`, `codex-explore` and `transfer` call it. They do not copy it.

## Why WSL

On native Windows, Codex cannot read or write files: its sandbox is blocked (observed). Codex
therefore runs **inside WSL** (Ubuntu), where it works. A Codex plugin for the host IDE is not used
for delegation: such a plugin starts the Windows build of Codex.

## Install and log in — read this before the first use

**Installing Codex is not enough. You must log in once, with a ChatGPT account.** The free plan is
enough, with limited quotas. A script cannot do this for you: the login is interactive.

1. **Open Ubuntu**: run `wsl`. If WSL is missing: run `wsl --install`, then restart Windows.
2. **Install Codex inside Ubuntu** (needs Node.js and npm in Ubuntu):
   `npm install -g --prefix "$HOME/.local" @openai/codex`
3. **Turn on device-code login in ChatGPT**: open *Settings → Security* and allow the device code for
   Codex. **Without this setting, the login fails** with a red message.
4. **Start the login** inside Ubuntu: `~/.local/bin/codex login --device-auth`. A code appears.
5. **Open the displayed address in your web browser. Type the code on the WEB PAGE, not in the
   terminal.** The terminal must only wait. Click *Continue*.
6. **Check**: `~/.local/bin/codex login status` must show `Logged in using ChatGPT`.

Never copy the file `~/.codex/auth.json` from Windows to WSL. Log in inside WSL.

**Privacy.** The code that you give to Codex goes to OpenAI. Each send needs your consent. Do not use
Codex on a repository that contains secrets or code that must not leave your machine.

Until the login is done, the `codex-*` skills say so, and the assistant works alone. To check the
setup: `bash .agents/skills/codex-bridge/scripts/codex-bridge.sh check`.

## Commands

Always run `bash .agents/skills/codex-bridge/scripts/codex-bridge.sh <command>`. Do not run
`node ...` directly: some shells do not expand `~` in that form.

| Command | Role |
| --- | --- |
| `check` | State: WSL, Codex installed, logged in, quota. JSON output |
| `exec --mode read\|review\|write --cwd <folder> --prompt-file <f> --out <f> --confirmed` | Runs Codex. `read` and `review` are read-only. `write` writes inside `--cwd` |
| `worktree --slug <name>` | Creates `.agents/worktrees/codex-<name>` and the branch `bugfix/codex-<name>` from `HEAD` |
| `worktree-clean --slug <name>` | Removes the worktree and the branch (merged branch only) |
| `state` / `reset` | Shows / clears the quota state |
| `selftest` | Checks the pure cases (error classification, paths, state). Needs no network |

Put the work files (prompt, output) in `.agents/tmp/` of the project. Git ignores this folder.
Git ignores `.agents/worktrees/` too (add it to `.gitignore` if it is missing).

## Exit codes → action

| Code | Meaning | Action |
| --- | --- | --- |
| 0 | Success | Read `--out`, continue |
| 2 | Consent missing | Ask the user, then run again with `--confirmed` |
| 10 | WSL or Codex absent | Show the **Login block** (below), then fall back |
| 11 | Codex not logged in | Show the **Login block** (below), then fall back |
| 12 | Quota exhausted, deadline not reached | Fall back, without calling Codex. Say until when |
| 20 | Quota reached during the call | Fall back: continue the work where Codex stopped |
| 21 | Authentication refused | Show the **Login block** (below), then fall back |
| 22 | Sandbox blocked | Fall back. Say that Codex cannot access the files |
| 23 / 24 | Other failure / timeout | Fall back. Quote the end of the error message |

## Login block — show it in full, never summarize it

The login is the step that users miss. When the exit code is 10, 11 or 21, show **this complete
message** as it is. Do not shorten it:

> ⚠️ **Codex is not ready: you must log in once (about 2 minutes).**
>
> **What it is**: Codex is a coding assistant made by OpenAI. You need a **ChatGPT account** (the free
> plan is enough, with limited quotas). **The code that you give to Codex goes to OpenAI.**
>
> **Steps** (in a terminal):
> 1. Open Ubuntu: `wsl`. If it is not installed: `wsl --install`, then restart.
> 2. Install Codex inside Ubuntu: `npm install -g --prefix "$HOME/.local" @openai/codex`
> 3. **Turn on device-code login** in ChatGPT: *Settings → Security*. Allow the device code for Codex.
>    **Without this setting, the login fails** with a red message.
> 4. Inside Ubuntu: `~/.local/bin/codex login --device-auth`. A code appears.
> 5. Open the displayed address **in your web browser**. Type the code **on the web page**, not in the
>    terminal. The terminal must only wait. Click *Continue*.
> 6. Check: `~/.local/bin/codex login status` must show `Logged in using ChatGPT`.
>
> Tell me when it is done: I check. **Until then, I do the work myself.**

Rules for the block:

- Change only the state line at the top (what is missing: WSL, installation or login). Keep all steps.
- Never start the login for the user. **Never copy** the Windows authentication file (`auth.json`) to
  WSL. The user logs in once, by himself or herself.
- After "it is done", run `check` again and report the result. If it fails, repeat only the step that
  failed, not the whole block.
- Do not repeat the full block for each task in the session. Show it once. After that, use one line
  ("Codex is still not logged in, I do the work myself").

## Consent — before each send

Everything that Codex reads goes to OpenAI. Before **each** `exec`, ask the user one question with
`AskUserQuestion` (or the interactive confirmation of your IDE). The question names exactly **what
Codex can read** (the `--cwd` folder, so the whole repository or worktree) and **what Codex can
write** (nothing in `read` and `review`, the worktree in `write`). If the answer is "no" or there is
no answer, do not call Codex. Do the work yourself.

In an unattended session, the user gives consent **once, at the start**. That consent covers only the
worktree of that session.

In the prompt that you send to Codex, always write these rules: do not read or quote `.env`, keys,
certificates or secret files. Do not run `git commit`, `git push` or any network command.

## Fallback when Codex is unavailable

The bridge keeps a local state (`~/.agents/codex/state.json`, outside the repository):

1. **Before** a delegation, `check` reads the state. If the quota is exhausted **and** the known
   return time has not passed: code 12. The assistant does the task alone and says so in one line.
2. Otherwise (healthy state, time passed, or time **unknown**): **try** Codex. This is the recheck at
   the next use. A success clears the state.
3. **If Codex fails for quota** (code 20): the bridge saves the state. The assistant **continues the
   task at once**. First, it reads what Codex already changed in the worktree.
4. One try per use. Never retry automatically in a loop.
5. A failure that is not a quota failure (login, sandbox, outage) is reported as such. Never present
   it as a quota failure.

Known limit: the exact format of the Codex quota message was never observed (it cannot be caused on
purpose). The bridge recognizes `usage limit`, `quota`, `rate limit` and `429`. At the first real
overrun, check that the fallback started. If it did not, adjust `classify` in the script and add the
case to `selftest`.

## Isolated worktree

Codex always writes in a worktree. It never writes in the working repository:

1. Run `worktree --slug <name>`.
2. Run `exec --mode write --cwd .agents/worktrees/codex-<name>`.
3. The assistant reads the diff and runs the tests again. It **commits itself** (Conventional Commits,
   one author, no `Co-Authored-By` trailer). Then it merges into the working branch and runs
   `worktree-clean`.

Codex never commits.

## Optional input (when invoked from another skill)

Receive: the **mode** (`read`, `review`, `write`), the working **folder**, the **prompt file** and the
**output file**. Do not ask the framing questions again. **Consent** stays mandatory (unless the user
already gave it for this session). Return: the exit code, the path of the output and, for a fallback,
the reason in one line. No cross-session memory in orchestrated mode.

⚠️ Fallback: if `node` or `wsl.exe` is unavailable, do not call Codex. Say why and do the work with
the assistant.
