---
name: security-audit
description: "Plan and execute a full security audit via Opus (OWASP Top 10 reconnaissance, dependencies, config, dynamic tests) then appsec and pentest. Triggers: security audit, OWASP analysis, security planning."
model: claude-opus-5
user-invocable: true
type: orchestrator
priority: high
scope: security
dependencies: []
conflicts: []
---

# Security Audit — Planning and Orchestration (Opus)

Plans the full security audit of the current project, then orchestrates execution via the `appsec` and `pentest` skills.

## Coverage and gating discipline (source: `bocal-pol/security-audit-skill`, Cloudflare fork)

Principles adapted from this methodology, without reusing its strict OS sandbox framework
(file descriptors, anti-TOCTOU promotion) designed for an isolated hostile environment — here
the audit runs under local, user-supervised trust.

- **Deterministic coverage ledger**: before hunting for flaws, establish the list of coverage
  units (surface × boundary × attack class — e.g. "public API × authorization × IDOR",
  "SSO callback × CSRF"). Record for each unit a status: `planned` → `covered` /
  `candidate` / `blocked`. Never declare coverage complete while planned units
  remain without a verdict — an incomplete pass is reported as such (`incomplete run`), never as
  a clean audit.
- **Gating candidate → confirmed → to-validate**: a vector found by grep (Phase 3) is a
  **candidate**, not a finding. It becomes **confirmed** only after dynamic proof (Phase 6) or
  a complete source trace demonstrating a missing control. If it depends on a fact outside
  the repository (deployment behavior, proxy config, external IdP policy) that cannot be
  verified locally, it becomes **to-validate** — never classified with a severity, never presented
  as confirmed out of caution.
- **Separate priority from certainty**: severity can never exceed demonstrated impact. A
  `to-validate` candidate has no severity until it is resolved.
- **Stable fingerprint per root cause**: several entry paths sharing the same root
  cause (e.g. the same missing sanitizer exploited by 3 endpoints) are one single finding with
  its most complete trace, not three duplicated findings.
- **Anti-patterns to explicitly refuse** (report "not confirmed" rather than letting them
  through):
  - a deviation from a generic checklist presented as a vulnerability without an actually crossed
    trust boundary;
  - defense-in-depth advice without a reachable boundary violation;
  - guessing a provider/proxy/browser/identity behavior not present in the source code;
  - treating a self-inflicted action or intentional authority of the same principal as a
    boundary crossing;
  - reporting a stronger effect than what was actually observed (e.g. presenting a parser crash as
    code execution without proof);
  - writing the report before independent verification, or letting the prose and the evidence
    contradict each other.

## Workflow

### Phase 1 — Plan mode and context

Call `EnterPlanMode`. All following phases are read-only. Via `AskUserQuestion`, collect in a single question:
- Target URL(s) if the application is deployed
- Technical stack if not obvious
- Excluded scope (third-party services, external SSO, etc.)
- Cloud scope involved? (AWS / Azure / GCP / none)
- Regulatory constraints? (GDPR / ISO 27001 / NIS2 / none)
- Project structure: monorepo, microservices, or single application?
  - If monorepo → ask which services are in scope
  - Adapt the Phase 2 Glob accordingly: `services/auth/**/*`, `services/api/**/*`, etc.
- **Explicit confirmation**: "Do you confirm you have written authorization to test this target?"

> ⛔ If authorization is not confirmed, stop immediately and do not proceed to the dynamic phases (6).

### Phase 2 — Discovery

**Pass 1 — Structure mapping**: Glob `**/*` limited to 2 levels of depth to identify significant directories. Exclude: `node_modules/`, `vendor/`, `.git/`, `dist/`, `build/`, `coverage/`.

**Pass 2 — Targeted sensitive files**: Glob on specific patterns:
- Configs: `**/.env*`, `**/config.*`, `**/appsettings*.json`, `**/secrets.*`
- Credentials: `**/*.key`, `**/*.pem`, `**/*.pfx`, `**/*.p12`
- Entry points: `**/routes.*`, `**/controllers/**`, `**/handlers/**`

### Phase 2b — "Declared vs implemented control" matrix (mandatory)

> Audit lesson from 2026-09-09: a project had 22 complete ADRs and a complete STRIDE model; CSP, timeouts, SSO `state`, the `can_access` contract and Vault "without fallback" existed **only in documentation**. An ADR without proof is a hypothesis, not a protection.

1. Collect **declared** controls: Glob `**/docs/adr/*.md`, `**/ARCHITECTURE.md`, `**/SECURITY.md`, `**/CONTEXT.md`, "Security" / "STRIDE" / "Definition of Done" sections, integration contracts (`**/docs/contracts/*`, `shared/**/README.md`).
2. For **each** named control (header, timeout, throttle, sanitizer, `state` verification, revocation, encryption, purge, Vault secret…), produce a row:

| Declared control | Source (ADR/§) | Implementation found (file:line) or **ABSENT** | Dynamic proof (Phase 6) | Verdict Compliant / Partial / Absent |

3. A declared-and-absent control = **at least Medium** finding (false assurance), High if it's an access, session, or secret barrier.
4. Look for **dead security code**: sanitize/validate/verify methods defined but never called (`grep -rn "function sanitize\|function verify\|function assert"` then grep the call sites). A security method with no caller is a finding.
5. The matrix is reused as-is in the final report (Phase 11) and feeds Phase 6.

### Phase 2c — "SSO / IdP consumer" checklist (if the app delegates authentication)

Mandatory as soon as a central authentication service is consumed (Auth, Keycloak, Azure AD, Passport…). Read the **full contract** on the issuer side (`verify`/`userinfo` controller, access resolver, application seeder) **and** on the consumer side (provisioner, callbacks), then verify line by line:

| # | Checkpoint | Where to look | Typical flaw |
|---|---|---|---|
| S1 | **The entire** access block returned by the IdP is applied: `can_access`, `status` (suspended/pending), not just `role` | provisioner / callback | a suspended or profile-less user keeps access |
| S2 | Access decision precedes local **provisioning** (no `upsert` before refusal) | callback | ghost accounts, spaces created for rejected users |
| S3 | `state` / `nonce` anti-CSRF generated **server-side**, stored in session, verified **before** `Auth::login`; never "best-effort" on the SPA side | login route + callback | login-CSRF, fixation via forced login |
| S4 | Single-use exchange code + short TTL; `return`/`redirect_uri` restricted to an allowlist of **origins**, fixed path | callback | replay, open redirect |
| S5 | Explicit timeouts (connect ≤ 3s, total ≤ 10s) on `exchange`/`verify`, circuit breaker, no application-level retry | IdP HTTP client | self-inflicted DoS |
| S6 | **Central** revocation: back-channel logout receiver (HMAC + anti-replay) or periodic re-verification; local logout calls IdP logout; no `remember: true` on privileged accounts | logout, middleware | zombie session after IdP revocation |
| S7 | The locally cached application role is **re-resolved** (TTL or on every admin access), never fixed for the cookie's lifetime | admin/panel middleware | a revoked role stays active |
| S8 | GDPR erasure compatible with re-login: `auth_user_id`/`sub` nulled or partial index; test erase → relogin | erasure service + index | permanent 500 after `DELETE /me` |
| S9 | Authorization attributes (`is_super_admin`, `app_role`, `roles`) **outside** `$fillable` / mass-assignment; written only by the provisioner via `forceFill` | User model | escalation via a future `update($validated)` |
| S10 | Automated local revocation test (replayed cookie → 401) **and** IdP refusal test (missing / suspended profile → 401/403) | Feature / e2e tests | silent regression |

Every KO row becomes a finding with its proof (Phase 6: D-SSO-1 missing profile, D-SSO-2 suspended profile, D-SSO-3 callback without `state`, D-SSO-4 IdP logout then local API call, D-SSO-5 erase then relogin).

### Phase 3 — OWASP Top 10 static analysis

All Grep calls exclude: `node_modules/`, `vendor/`, `*.test.*`, `*.spec.*`, `dist/`, `build/`

Each row in the table below identifies a **candidate**, not a finding — its status only becomes
`confirmed` after dynamic proof (Phase 6) or a complete source trace demonstrating the absence of the
expected control. Log candidates in the coverage ledger (see methodology section
above) before moving to Phase 6.

| Vector | Targeted patterns | Target files |
|---------|----------------|-----------------|
| Incomplete IdP contract | `can_access`, `status`, `app_access`, `panel_access` → verify they are **read** (not just commented) | SSO provisioner, callbacks |
| Dead sanitizer | `function sanitize\w*` then grep call sites; `Sanitizer::` with no call-site | services, FormRequests, controllers |
| Unbounded `array` validation (Laravel) | `'array'` / `'sometimes\|array'` **without** an associated `field.*` rule; `array_merge(.*settings\|preferences`; `setTranslations\(` | controllers, FormRequests |
| Authorization mass-assignment | `\$fillable` containing `is_super_admin\|is_admin\|app_role\|roles\|permissions` | models |
| Plaintext secrets outside `.env` | `TOKEN:\s*'[^$]`, `PASSWORD:\s*'[^$]`, `TLS_SKIP_VERIFY:\s*'true'`, `dev-root-token` | `compose*.y*ml`, `docker-compose*`, `Dockerfile`, `*.tfvars`, CI yaml |
| Silent secrets fallback | `fallback .env`, `keeping .env`, `catch (Throwable` around a Vault/KMS client | secrets providers |
| SQL injection | `\.query\(.*\+`, `\.execute\(.*\+`, `\.raw\(`, `INTERVAL '\{\$` (interpolation in `whereRaw`) | Backend only (`src/`, `api/`, `server/`, `app/`) |
| XSS | `innerHTML\s*=`, `dangerouslySetInnerHTML`, `document\.write\(`, `eval\(` | Frontend + templates |
| Hardcoded secrets | `password\s*=\s*["']`, `api_key\s*=\s*["']`, `secret\s*=\s*["']` | Everything except `.env.example` |
| Auth/Session | `verify\s*:\s*false`, `httpOnly\s*:\s*false`, `secure\s*:\s*false` | Auth config, middlewares |
| JWT `alg:none` / algorithm confusion | `jwt\.verify\(` without an explicit 2nd `algorithms:` argument; `JWT::decode\(` without a single-algorithm 3rd argument; `TokenValidationParameters` without `ValidAlgorithms` | JWT verification, auth middlewares — see `iam-engineer` Phase 2 for library-specific detail |
| IDOR | `/:[a-z]*id\b` without an adjacent auth middleware | Route files |
| SSRF | `fetch\(req\.`, `axios\.get\(req\.`, `http\.get\(.*req\.` | Backend only |
| Upload | `mimetype`, `extension` absent in upload handlers | Upload handlers |
| Prototype pollution (Node/JS) | `_.merge\(\|_.defaultsDeep\(\|_.extend\(` or `Object.assign\(\|\.\.\.` on `req.body\|req.query\|req.params` **before** schema validation; a homemade merge function with no `__proto__\|constructor\|prototype` key filter | Backend Node — see `appsec` Phase 1 for detail |
| XXE | PHP `simplexml_load_\|new DOMDocument` without `LIBXML_NONET` or with `LIBXML_NOENT`; .NET `XmlDocument\|XmlReader.Create\(` without `DtdProcessing.Prohibit`+`XmlResolver = null`; Java `DocumentBuilderFactory` without `disallow-doctype-decl`; Node XML parsers with external entities enabled | Any XML parsing coming from a request — see `appsec` Phase 1 for stack-specific detail |
| Weak crypto | `md5\(`, `sha1\(`, `createCipher\b`, `DES\|RC4` | All |
| MAC vulnerable to length extension | `hash\(.*secret.*\.\|md5\(.*\$secret\s*\.\|createHash\(.*\)\.update\(.*secret` (secret+message concatenation) **without** `hash_hmac\|createHmac\|hmac\.new` present elsewhere for the same check | Homemade token signature/verification functions — see `appsec` Phase 1 for detail |
| ReDoS | regex on user input (`\.test\(\|\.match\(\|preg_match\(\|Regex\.`) with a nested quantified group (`(a+)+\|(a*)*\|([a-zA-Z]+)*`) or overlapping alternation — often a homemade email/URL validator | Backend/frontend — see `appsec` Phase 1 for detail |
| Origin spoofing (HTTP header) | access control/rate-limit based on `X-Forwarded-For\|X-Real-IP\|Host` without rewriting by a trusted proxy; unrestricted Express `trust proxy`; .NET `ForwardedHeadersOptions` without `KnownProxies` | Debug/admin/metrics routes, network trust middlewares — see `appsec` Phase 1 for detail |
| Sensitive logging | `console\.log\(.*pass`, `console\.log\(.*token`, `logger\.\w+\(.*secret` | All |

### Phase 4 — Manifest inventory

Identify and list only the manifests present — actual dependency auditing is delegated to the `pentest` skill:

| Manifest found | Tool to be used |
|-----------------|----------------------|
| `package.json` | `npm audit` |
| `composer.json` | `composer audit` |
| `requirements.txt` / `Pipfile.lock` | `pip-audit` |
| `pom.xml` / `build.gradle` | OWASP Dependency-Check |

Pass the list of detected manifests to the `pentest` skill via context.

### Phase 5 — Configuration, headers, infrastructure secrets

- Analyze: `nginx.conf`, `.htaccess`, `web.config`, `Dockerfile`, **all infra `compose*.yaml` / `docker-compose*.yml`**, `.github/workflows/*`.
- Check: wildcard CORS `*` **and dev fallbacks in prod** (`env('CORS_ALLOWED_ORIGINS', 'http://localhost…')`), absence of CSP, X-Frame-Options, HSTS, Referrer-Policy.
- **If no reverse proxy serves the application** (grep the port / service name in `nginx/`, `Caddyfile`, `traefik`): headers must come from an application middleware — check it exists (`grep -rn "X-Frame-Options\|Content-Security-Policy" app/ src/`). Absence = High finding.
- Detect: committed `.env`, active debug modes (`DEBUG=true`, `NODE_ENV=development`), **dev image shipped as runtime** (`CMD ["npm","run","dev"]`, `vite --host`), `npm ci || npm install`, missing `.dockerignore`, missing versioned lockfile (`composer.lock`, `package-lock.json`).
- Infra secrets: root tokens, `TLS_SKIP_VERIFY`, literal passwords in compose files (the "password in `.env`" rule extended to versioned compose files). Verify **expected secrets actually exist** in the manager (e.g. `vault kv list secret/<project>/`) and that a missing secret **fails at startup** outside `local` (no silent fallback).
- Support services declared essential (queue worker, scheduler, cache): verify they **are running** (`docker compose ps` healthy) — a worker stuck in a restart loop makes GDPR erasures and notifications inert.
- **Cache poisoning / deception** (if a reverse proxy/CDN/application cache is present): verify the
  cache key (nginx `proxy_cache_key`, `Vary` rule) includes every header the backend reads to
  build the response (`X-Forwarded-Host`, `X-Forwarded-Scheme`) — otherwise a request with a
  forged header can poison the response served afterward to all visitors. Also verify no
  extension-based cache rule (`location ~* \.(js|css|json)$`) applies to a protected route prefix
  (`/account/`, `/api/`, `/admin/`) without a forced `Cache-Control: private, no-store` at the application level.

### Phase 6 — Dynamic tests (if authorization confirmed)

If no deployed URL is provided but a local stack exists (compose), **start the stack** and test `localhost` with `curl` (not just WebFetch: raw headers, cookies, replays are needed). Create dedicated test accounts per role (member, moderator, admin, **no profile**, **suspended**).

Each scenario that confirms a Phase 3 candidate moves its status to `confirmed` in the
ledger, with severity calibrated on the **actually observed** impact (never beyond): a
candidate whose dynamic test fails to reproduce the impact drops in severity or goes back to
`to-validate` if a fact outside the repository (proxy/external IdP behavior not observable here) blocks
the conclusion — it is never left at the initial default severity of the grep.

**Mandatory** scenarios (each row = one command + one expected HTTP code in the report):

| # | Scenario | Expected |
|---|---|---|
| D-HDR | `curl -sI` on API, admin, SPA | CSP, XFO, nosniff, Referrer-Policy present |
| D-SSO-1 | login with an IdP account **with no app profile** | refusal (401/403 + 3-field message) |
| D-SSO-2 | login with a **suspended** IdP account (admin role) → `/admin` | refusal |
| D-SSO-3 | callback with a valid code **without `state`** | no session |
| D-SSO-4 | **IdP** logout then local API call with the cookie | 401 |
| D-SSO-5 | `DELETE /me` (GDPR) then IdP re-login | clean reconnection, no 500 |
| D-REV | local logout then replay of the captured cookie | 401 |
| D-JWT | if JWT used: forged `{"alg":"none"}` token, empty signature, from a captured payload; if RS256 in place, a second token signed HS256 using the RS256 public key as secret | 401 on both — success is CRITICAL (A02+A07) |
| D-PROTO | if Node backend: JSON body `{"__proto__":{"polluted":true}}` on every endpoint accepting an arbitrary body, then an unrelated neutral request (`/health`) to check for cross contamination | no trace of `polluted` anywhere else — success is CRITICAL (A03+A08), PoC = both requests |
| D-HASHEXT | if a homemade MAC is detected (Phase 3): capture a legitimate `(message, signature)`, run `hashpump -s <signature> -d <message> -a <data> -k <secret_length>` (test 16/32/64), replay the forged message + forged signature | rejection (invalid signature) — success (server processes the extended message) is CRITICAL (A02+A08), PoC = hashpump command + forged message/signature + server response. Skip if HMAC confirmed (immune by construction) |
| D-IPSPOOF | if an IP/host control is detected (Phase 3): `curl -H "X-Forwarded-For: 127.0.0.1"` (then `X-Real-IP`, `Host: localhost`, duplicated header `<attacker_ip>, 127.0.0.1`) from outside toward the restricted route | unchanged refusal — success (access granted or rate-limit bypassed) is CRITICAL (A01+A05), PoC = curl command + response |
| D-REDOS | if a candidate regex is detected (Phase 3): growing backtracking payload (15→35 valid characters + 1 invalid, adapted to the pattern), measure response time at each size — **start small, increase progressively, never a maximal payload upfront** | stable response time — exponential growth with size is CRITICAL if single-threaded/shared process or public endpoint without auth, High otherwise; PoC = payload + measured times per size |
| D-XXE | if an XML endpoint exists (upload/webhook/SOAP/SAML/import): external entity `file:///etc/passwd` (or `C:/Windows/win.ini` under IIS); if cloud detected, entity targeting `169.254.169.254` (IAM metadata) | file/metadata absent from the response and the logs — success is CRITICAL (A05+A10), PoC = XML payload + exfiltrated content |
| D-CACHE | if a reverse proxy/CDN exists: request with `X-Forwarded-Host: evil-poc.test` on a cached URL, then replay by a clean client with no injected header; separately, an authenticated URL with a fake static extension (`/account/profile.json`) replayed without a cookie | the `evil-poc.test` marker never appears for the second client; private content is never served without auth — success is CRITICAL (A05, +A01 for deception), mass impact |
| D-IDOR | per role: GET/PATCH/DELETE on a resource in another scope (real uuid) | 404 opaque, identical to a nonexistent uuid |
| D-ESC | weak role → every higher-role action | 403 |
| D-ENUM | invalid tokens/invitations (nonexistent, expired, revoked, exhausted) | **byte-identical** responses + 429 after quota |
| D-XSS | `<script>`, `<img onerror>`, `[l](javascript:)`, `<svg onload>`, `data:`, double encoding, control characters, on **every** free-text field (including patterns/comments/reasons) | stored and neutralized |
| D-JSON | JSON payload with unknown keys and 50KB values on every `array`/jsonb field | 422 |
| D-CSRF | POST without a CSRF token with a valid cookie | 419 |
| D-CORS | `Origin: http://evil.tld` (simple + preflight) | no `Access-Control-Allow-Origin` |
| D-RATE | exceed every declared limit (read, write, public) | 429 + 3-field message |
| D-ANON | if anonymity/pseudonymity exists: reading by every role (detail, list, history, notifications, GDPR export, base) | no author identifier |

Via WebFetch/curl on each target URL, additionally:
- Access to sensitive resources: `/.env`, `/admin`, `/api/docs`, `/swagger`, `/actuator`, `/.git/config`
- Cookie security flags (`Secure`, `HttpOnly`, `SameSite`)
- Error messages (information disclosure, exposed stack traces)

### Phase 6d — Test suite and CI health

- Run existing suites (`php artisan test`, `npx vitest run`, Playwright if accounts are provided). A **red** suite or a test file with a syntax error is a finding (the protections tested are no longer verified).
- Verify a CI workflow **covers this project** (paths/matrices): test, lint, `composer audit`, `npm audit`, SAST. A submodule outside CI = Medium finding.
- Verify the presence of tests required by the ADRs (XSS payload set per vector, headers, CSRF, throttle, revocation, IdP refusal).

### Phase 7 — Exit plan mode

Call `ExitPlanMode`. Present the structured findings plan (identified vectors, attack surfaces, priorities), then proceed directly to execution.

### Phase 8 — AppSec execution

Invoke the `appsec` skill with:
- **Expected input**: Phase 3 findings list, suspect file paths
- **Expected output**: static review report classified under OWASP Top 10:2021 + threat model

> ⚠️ If `appsec` is unavailable: document the raw Phase 3 findings in a `## Static Analysis (not deepened)` section of the final report and continue.

### Phase 9 — Pentest execution

Invoke the `pentest` skill with:
- **Expected input**: manifest list (Phase 4), target URL(s), collected headers (Phase 6)
- **Expected output**: consolidated report `security-audit-report-YYYY-MM-DD.md`

> ⚠️ If `pentest` is unavailable: generate the report directly from phases 3-5-6 with a `## Dependencies (audit not run — re-run manually)` section.

### Phase 9b — Cloud Security (if cloud scope confirmed in Phase 1)

Invoke the `cloud-security` skill with:
- **Expected input**: Phase 5 config findings (`.env`, `Dockerfile`, detected cloud configs), Phase 6 headers
- **Expected output**: `cloud-security-findings.md` report with IAM, network, secrets findings

> ⚠️ If `cloud-security` is unavailable or cloud scope = "none": note "cloud-security not run" in the final report.

### Phase 9c — IAM Review (if Auth/Session findings detected in Phase 3)

Invoke the `iam-engineer` skill with:
- **Expected input**: Phase 3 Auth/Session findings (`verify: false`, `httpOnly: false`, IDOR patterns), identified suspect files
- **Expected output**: `iam-findings.md` report with JWT, OAuth, RBAC, Session findings

> ⚠️ If `iam-engineer` is unavailable or no Auth/Session finding: note "iam-engineer not run" in the final report.

### Phase 9d — Compliance (if regulatory constraints confirmed in Phase 1)

Invoke the `compliance-officer` skill with:
- **Expected input**: analyzed surface (modules, services, data types processed), critical findings from phases 3-5
- **Expected output**: `compliance-gaps-YYYY-MM-DD.md` report with a gap matrix and remediation roadmap

> ⚠️ If `compliance-officer` is unavailable or constraints = "none": note "compliance-officer not run" in the final report.

### Phase 9f — AI/Agent Security (if LLM/agent surface detected in Phase 2)

**Condition**: LLM SDK (Claude/OpenAI/other), MCP server or client, agent/sub-agent configuration,
RAG pipeline detected in Phase 2.

Invoke the `ai-agent-security` skill with:
- **Expected input**: LLM/agent surface identified in Phase 2, Phase 3 Auth/Session findings (to avoid double coverage with `iam-engineer`)
- **Expected output**: `ai-agent-security-findings-YYYY-MM-DD.md` — prompt injection, tool abuse, MCP/sub-agent trust, findings classified confirmed/to-validate

> ⚠️ If `ai-agent-security` is unavailable or no LLM/agent surface detected: note "ai-agent-security not run" in the final report.

### Phase 9e — Vulnerability Management

Invoke the `vulnerability-management` skill with:
- **Expected input**: all findings from appsec (Phase 8) + pentest (Phase 9) + cloud-security (Phase 9b) + iam-engineer (Phase 9c) + ai-agent-security (Phase 9f)
- **Expected output**: `vuln-roadmap-YYYY-MM-DD.md` report with CVSS 3.1 scoring and a per-sprint remediation roadmap

> ⚠️ If `vulnerability-management` is unavailable: note "vulnerability-management not run" in the final report.

### Phase 9f — Priority-0 backlog (mandatory)

Every finding **must** be entered into the audited project's backlog, at the top, before any other entry:

- If the project has a `BACKLOG.md`: add `SEC-nn` rows **above** the first row of the "Overview" table and a `## SEC — Security (priority 0)` section **before** the first functional section, in the file's format (`Why / What / Tasks / Done when` + `CHECK` command). Priority `High (priority 0)`; a SEC item is only checked off with its green command.
- If the backlog is in Notion / a tracker: create a "Security — priority 0" sprint at the top.
- Findings whose remediation belongs to **another** repository (IdP, infra, shared) are entered as one line in that repo's backlog **and** referenced in the project's own (as a dependency).
- The final report (Phase 11) references the backlog section; the backlog references the report.

### Phase 10 — Memory consolidation

Invoke the `memory-rituel` skill with:
- **Expected input**: list of identified CVEs/flaws, recurring patterns detected
- Cloud-security findings: IAM misconfigurations, network exposures, detected secrets (Phase 9b)
- Compliance-officer gaps: GDPR/ISO27001/NIS2 deviations and maturity level (Phase 9d)
- Vulnerability-management roadmap: consolidated CVSS scoring, prioritized remediation sprints (Phase 9e)
- **Expected output**: update of `.claude/security-knowledge.md`

> ⚠️ If `memory-rituel` is unavailable: manually append a `## Session YYYY-MM-DD` block to `.claude/security-knowledge.md` (create the file if absent).
