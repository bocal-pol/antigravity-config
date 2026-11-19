---
name: codex-explore
description: "Read-only exploration of a large repository by Codex (OpenAI): answers a question (where is X, who calls Y, how does Z work) and returns a short summary with file:line references, to keep the assistant's context light. The assistant verifies the quoted references before relying on them. If Codex is unavailable, the assistant explores itself. Invoke on: ask codex where is, codex explore this repository, find with codex who calls, map this code without loading my context."
model: claude-sonnet-5-5
type: utility
priority: low
scope: cross
dependencies:
  - codex-bridge
conflicts: []
---

# Codex Explore — Read a lot, bring back little

> **Unconfirmed in Antigravity.** Needs a shell that can run `wsl.exe` and Node.js 18 or later. Not
> tested under Antigravity. See `PORTING-NOTES.md`.

When the answer needs many files, Codex reads instead of the assistant and brings back only a
summary. The context of the assistant stays light. The assistant does not spend its tokens on reads.

## Optional input (when invoked from another skill or agent)

Receive: the **question** and, if useful, the **folder** to explore. Do not ask these questions
again. Consent stays mandatory. Return the verified summary, without writing a file.

## When not to use it

For one known file or a search for one pattern, use a direct grep or read. It is faster and free. This
skill is useful only for a question that forces a scan of a lot of code.

## Procedure

1. **Preflight**: run `bash .agents/skills/codex-bridge/scripts/codex-bridge.sh check`. Use the exit
   code table of the skill `codex-bridge` (full Login block for 10, 11, 21). **Fallback**: explore
   yourself with grep, glob and read (or an exploration agent if the search is very wide). Say so in
   one line.
2. **Consent** (`AskUserQuestion`): "Codex (OpenAI) will read the folder <folder>, read-only. Send?"
   If no: fall back.
3. **Prompt** (`.agents/tmp/codex-explore-<date>.md`): the question; the folder; the exclusion of
   `node_modules/`, `vendor/` and `*.test.*`; the prohibitions of the skill `codex-bridge`; and the
   format: an answer of **ten lines at most**, each statement followed by `file:line`, then "what I
   could not establish".
4. **Run**: `codex-bridge.sh exec --mode read --cwd <folder> --prompt-file <prompt> --out .agents/tmp/codex-explore-<date>.out.md --confirmed`.
5. **Verify before relying on it**: open **at least the two most structuring references**. Confirm that
   the quote exists at the given place. If a reference is false, reject it and say so. If several are
   false, redo the exploration yourself.
6. **Report**: give the summary. Mark what is **verified** and what is not.

⚠️ Fallback: if `codex-bridge` is unavailable, explore with grep, glob and read.
