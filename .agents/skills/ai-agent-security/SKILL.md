---
name: ai-agent-security
description: "Security audit of LLM/agent-based systems: indirect prompt injection, tool abuse (tool-argument injection), excessive trust granted to a sub-agent or MCP server, role/provenance confusion in context, persistent memory poisoning, user-approval binding. Auto-invoke on: prompt injection, AI agent security, MCP security, LLM tool abuse, confused deputy agent, RAG security, sub-agent security, Claude skill security audit."
model: claude-sonnet-5
user-invocable: true
type: framework
priority: high
scope: security
dependencies: []
conflicts: []
---

# AI Agent Security — LLM, Tool, MCP, Sub-agent Audit

Audits any system where an LLM participates in a trust-sensitive decision: chatbot, RAG pipeline,
persistent agent memory, agent/tool-calling loop, MCP server or client, code that builds a prompt
from untrusted input, code that consumes a model output and acts on it. The at-risk data flow:
**untrusted content → model or memory → capability, authority, or sink**.

**Origin**: methodology adapted from
[`bocal-pol/security-audit-skill`](https://github.com/bocal-pol/security-audit-skill) (a Cloudflare
fork), whose per-attack-domain technical content was reused and reworded; the original's sandboxed
multi-agent orchestration framework (ledger, anti-TOCTOU file promotion) was not transposed — this
repository audits under locally-supervised trust, not an isolated hostile environment.

## Status: usable alone or alongside `security-audit`/`appsec`

This skill fills a blind spot in the existing security skills (`security-audit`, `appsec`,
`pentest`, `iam-engineer`): none of them cover the model-specific delegation layer. Classic controls
(transport, authz, request construction, filesystem usage, output rendering) remain the
responsibility of those skills — this skill adds the model layer on top, it doesn't replace them.

**Direct relevance to this repository**: this configuration repository is itself a multi-agent
system (skills that invoke each other, an orchestrator that delegates to sub-agents, MCP servers
for docs/sequential-thinking/playwright/image/video generation). This skill also applies to
auditing the repository itself, not only the projects it helps build.

## Optional input (when invoked from `security-audit`/`appsec`/the security agent)

- Auth/Session findings already identified (to avoid double coverage with `iam-engineer`)
- Scope: list detected LLM integrations (Claude/OpenAI SDK, LangChain, MCP servers,
  agent/sub-agent configuration) before starting

## Guiding principle

A prompt injection **alone** is not a finding. Require a boundary failure at the code level: the
content reaches another principal's context, invokes authority the requester doesn't have,
discloses data it can't read, or drives a sink it can't reach directly. A prompt guardrail ("never
do X") is not a security boundary — only count deterministic controls: resource-scoped
authorization, isolation, binding, constrained credentials.

## Workflow

### Phase 1 — Mapping

Via Glob/Grep, identify:
- **Untrusted content entry points**: RAG documents, indexed pages, uploaded files, email bodies,
  issue/ticket bodies, tool responses, MCP tool metadata
- **Persistent memory**: any storage a later session re-reads (embeddings, conversation history,
  prompt cache, memory files such as `MEMORY.md`)
- **Tool dispatch**: tool-calling schemas, handlers that execute an action from a model-produced
  argument
- **MCP servers/clients**: MCP config files, connection code, tool/server name resolution
- **Sub-agents/delegation**: any mechanism that launches a delegated task with a subset (or all) of
  the calling session's context/credentials

### Phase 2 — Attack classes

For each mapped entry point, check the following classes. Each line requires proof of a crossed
boundary, not mere theoretical possibility.

**Context, retrieval, and memory**

- *Indirect injection via ingested content*: an attacker can write a RAG document, indexed page,
  file, email, ticket body, or tool metadata that enters **another** principal's model context.
  Trace who can write each source, how retrieval scope filters it, which session consumes the
  result, and what capability that activates. Check isolation, per-resource authorization, and
  binding to the consuming principal's intent separately — the defect is a missing deterministic
  control, not the persuasive text itself.
- *Cross-session or cross-tenant context leakage*: conversation history, embeddings, retrieval
  results, or prompt cache scoped too broadly. Check tenant/ACL filters in the query itself and in
  every cache key — a tenant field stored on an object is not control enforcement if an alternate
  query, a shared cache, or a batch path omits it.
- *Persistent memory poisoning*: attacker-controlled content or a model summary is written into a
  memory that later influences another task, another user, or a privileged session. Review who can
  create/modify/merge/delete memory, its provenance and tenant scope, whether a low-confidence
  observation becomes a durable instruction or fact, and whether retrieval distinguishes user
  preference from tool policy.
- *Role/provenance confusion in the prompt*: prompt assembly lets untrusted text impersonate a
  system message, a prior turn, a tool result, a policy, or a memory record — string concatenation,
  untyped history, a caller-controlled role field, a serialization round-trip that loses the source
  label. Confirm the forged provenance changes a deterministic trust decision or reaches a real
  capability.

**Tools and actions**

- *Tool-argument injection to a downstream sink*: model-produced arguments reach SQL, shell, file,
  URL fetch, or a privileged API without handler-side validation. The tool schema is input parsing,
  not authorization — trace every field of the decoded call to the sink.
- *Excessive agency / confused deputy*: the agent uses a service identity or a broad credential, and
  the tool handler doesn't re-check the requesting principal's permission on the named resource.
  Check the effective execution identity and whether the caller could perform the same operation via
  the normal product interface.
- *Approval/confirmation binding*: a user approves a described action, but execution can use
  modified arguments, a different resource, a different principal, or a later model turn. Check
  whether the intent/confirmation binds the normalized tool name, the full arguments object, the
  requester, the target, the amount, the expiry, and batch membership — including across retries and
  resumed sessions.
- *Schema/dispatcher disagreement*: the schema accepts aliases, extra fields, duplicate keys,
  coercions, nested free-form objects, or out-of-range values that the dispatcher or handler
  interpret differently.
- *Unbounded delegated action loops*: a bounded request can trigger repeated spend, send, mutation,
  or external API calls without a per-request budget, per-action authorization, cancellation, or
  idempotency control.

**MCP and sub-agents**

- *Sub-agent/MCP trust inheritance*: a delegated task receives the full session, credentials,
  memory, or capabilities rather than the least authority needed. Check the principal and tenant
  passed to each call, capability narrowing, credential audience, and whether delegated results are
  treated as untrusted on return.
- *MCP server/tool identity confusion*: calls or results are routed by a server name, tool name,
  request ID, resource URI, or model-chosen alias that an attacker can influence, rather than by the
  authenticated connection and the pending request.
- *MCP metadata/schema treated as policy*: tool descriptions, resource metadata, prompts, or schemas
  supplied by an MCP peer are treated as policy or authorization. These fields may guide the model
  but cannot grant capability — find the deterministic allowlist, server identity check, and
  handler-side authorization that remain authoritative in case of conflict with the metadata.

**Output and disclosure**

- *Unsafe output rendering*: model output reaches an HTML, Markdown, template, URL, or command
  execution sink without the encoding and policy the sink requires.
- *Sensitive context extraction*: the assembled context contains credentials, another user's data,
  private source, or policy values that themselves grant access, and a user-influenced output
  exposes them.

### Phase 3 — Validation

Each candidate must name: the attacker, the affected principal or shared resource, the execution
identity, the target, and the unauthorized/unrequested action or disclosure.

- For a confused-deputy claim: prove the tool lacks requester+resource authorization and that the
  attacker cannot perform the same action normally.
- For an action-binding claim: prove that attacker-controlled content caused an action under the
  affected principal's authority, which that principal neither requested nor intentionally approved
  — a valid generic authorization does not establish this intent.
- For memory/retrieval: cite both the attacker-controlled write and the later privileged
  cross-principal read or decision. A shared record with no reachable consumer is not sufficient.
- For MCP identity: check the authenticated connection, request correlation, tool namespace, and
  effective credential.
- Classify `confirmed` only with a complete source trace and a bounded local result establishing the
  boundary. Use `needs validation` when a vendor, deployment, model, rendering engine, or identity
  behavior isn't locally observable.

### Phase 4 — Report

Fold findings into the calling skill's expected format (`security-audit`, `appsec`) or, in
standalone use, produce `ai-agent-security-findings-YYYY-MM-DD.md` with: mapped context (Phase 1),
findings by attack class with source trace + proof, and for each finding the smallest source fix
that enforces the missing invariant at the trust decision point closest to execution.

## ⚠️ Fallback

If invoked with no LLM/agent context detected in Phase 1 (no SDK, no MCP server, no agent
configuration): print `⚠️ no LLM/agent surface detected — ai-agent-security not applicable` and
stop without producing an empty report.
