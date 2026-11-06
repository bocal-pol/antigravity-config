---
name: llm-fallback-free
type: utility
priority: medium
scope: cross
model: claude-haiku-4-5-20251001
dependencies: []
conflicts: []
description: >
  Detects that a Claude Code usage limit (quota/rate limit) has just been hit
  and proposes switching the current task to a free LLM via a direct API call
  (Groq, OpenRouter :free, Gemini free tier — all OpenAI-compatible). Never routes
  automatically: always presents the choice via AskUserQuestion. No proxy/MITM —
  deliberately ruled out after review (OmniRoute, 2026-09-25): local TLS
  interception judged disproportionate for a simple quota fallback.
---

# LLM Fallback Free — Switching to a free LLM when a limit is hit

Detects the signals of a reached Claude Code limit (exhausted API quota, rate limit,
forced end-of-session message) and proposes — never automatically executes — a
switch to a free LLM via a direct API call to continue the current task.

## Why not a proxy (OmniRoute and similar tools)

A tool like OmniRoute routes transparently by intercepting requests (local "stealth"/MITM
TLS) — undetectable to the user once configured, and it exposes every project's prompts/keys
to an unaudited third-party piece of software. Ruled out on 2026-09-25 after review: the risk
(interception of all LLM traffic, including on sensitive projects) is disproportionate to the
actual need (continuing a one-off task when the quota is exhausted).

This skill does the opposite: **a direct, explicit, visible API call**, decided case by
case by the user — never a silent, permanent routing.

## Detection

**No official Claude Code hook exists for "quota reached"** (verified: the documented hook
events — `SessionStart`, `PreToolUse`, `PostToolUse`, `Stop`, `PreCompact`,
etc. — don't cover usage limits). Detection therefore relies on the **textual
signal** the user or the session receives:

- An error message containing `rate_limit`, `usage limit`, `quota`, `429`, "you've
  reached your limit", "Claude usage limit reached"
- A forced end-of-session from the harness with a limit/quota-type message

**Invocation**: this skill is invoked when the user explicitly reports hitting their
limit ("Claude Code is blocked", "I've hit my limit", "quota exhausted"), or when an
agent/hook spots one of the patterns above in a recent error message and flags it to
the user before suggesting this skill — never silently.

**Wiring recommendation** (to enable via the `update-config` skill if desired, not
done by default here): a `PostToolUse` or `Stop` hook that greps the last visible
error message for these patterns and displays a simple info line suggesting
`/llm-fallback-free` — never a hook that switches on its own.

## Workflow

### Phase 1 — Confirming the need

Via `AskUserQuestion`:
```
Claude Code limit reached (or reported). Switch the rest of this task to a
free LLM via a direct API call?
→ "yes, Groq" | "yes, OpenRouter" | "yes, Gemini" | "no, I'll wait for the quota to reset"
```

If "no": stop here, configure nothing.

### Phase 2 — Provider selection

The three chosen providers are all **OpenAI-compatible** (same call shape:
`base_url` + `api_key` + `model`) — a single generic call code is enough,
parameterized per provider:

| Provider | `base_url` | Key | Recommended code model | Free quota |
|---|---|---|---|---|
| **Groq** (default) | `https://api.groq.com/openai/v1` | console.groq.com, free, no CC | `openai/gpt-oss-120b` (or `llama-3.3-70b-versatile`) | ~30 RPM / 14-30K TPM depending on model — generous, instant signup |
| **OpenRouter** (backup) | `https://openrouter.ai/api/v1` | openrouter.ai, free, no CC | `qwen/qwen-2.5-coder-32b-instruct:free` or `deepseek/deepseek-chat-v3-0324:free` | 20 req/min; 50 req/day (1000/day after $10 of unspent historical credit) |
| **Gemini** (alternative) | `https://generativelanguage.googleapis.com/v1beta/openai/` | aistudio.google.com, free, no CC | `gemini-2.5-flash` | ~10-15 RPM depending on model, a few hundred to 1500 req/day |

Default recommendation: **Groq** (simplest signup, most generous throughput for
interactive use). **OpenRouter** as a backup if Groq is also rate-limited (alternative
`:free` models, different model families). OpenRouter's `:free` model names
change — if the recommended model no longer exists, query `GET /models` and
filter on the `:free` suffix rather than failing on a fixed name.

### Phase 3 — Getting the key

If the chosen provider's key isn't already in the environment:
- Redirect the user to the key-creation page (console.groq.com/keys,
  openrouter.ai/keys, or aistudio.google.com/apikey) — **never** ask the user
  to paste the key in plaintext into the conversation; tell them to put it into an
  environment variable (`GROQ_API_KEY`, `OPENROUTER_API_KEY`, `GEMINI_API_KEY`) before
  continuing.
- Never write the key into a file in the project or in the `claude-config`-equivalent
  repo (Secrets rule in AGENTS.md).

### Phase 4 — Switching for the current task

The fallback does **not** replace Claude Code itself (no agentic tool, no
file/Bash access) — it's used to get a one-off answer (code generation, explanation,
review) via a direct API call while the Claude Code quota is exhausted:

```bash
curl "$BASE_URL/chat/completions" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "CHOSEN_MODEL",
    "messages": [{"role": "user", "content": "PROMPT"}]
  }'
```

Or via the OpenAI SDK in the project's language, pointing `base_url` at the
chosen provider — this is an isolated API call, not a Claude Code session: no
tools, no memory, no directly modified files. The user pastes the response into
their editor, or re-runs this skill for the next prompt.

### Phase 5 — Returning to Claude Code

Remind that this fallback is temporary: as soon as the Claude Code quota resets,
resume the task normally (the fallback had no tool access, so it may have
hallucinated code that hasn't been checked against the real project — review it
before applying it, don't paste it blindly).

## ⚠️ Fallback (if no provider is reachable)

If all three providers are unavailable (missing key, service down, free quota
also exhausted): display `⚠️ No free LLM available — wait for the Claude Code
quota to reset or provide an API key` and stop, without hallucinating a response.
