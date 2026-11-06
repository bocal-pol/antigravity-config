---
name: legal-pages
description: "Generates the published legal documents of a web project for an EU country (Belgium by default, France/Luxembourg/Netherlands/Germany/other EU country optional): cookie consent banner, privacy policy, legal notice, terms of service, terms of sale with 14-day withdrawal, refund policy, and consumer mediator. Auto-invoke on mention of: cookies, consent banner, legal notice, privacy policy, terms of service, terms of sale, privacy policy, cookie banner, publisher, host, consumer mediator, right of withdrawal, refund policy, form consent."
model: claude-sonnet-5
user-invocable: true
type: domain
priority: medium
scope: cross
dependencies:
  - compliance-officer
conflicts: []
---

# Legal Pages — Published Legal Documents

Produces the legal documents a website or web application must publish before going live —
distinct from the internal GDPR audit: this skill writes the **pages the end user reads**, not the
compliance register. Business owner: `compliance-officer` for substance (legal basis, retention
periods, DPO); this skill for the published form.

**Legal framework: European Union countries, Belgium by default.** The substance varies by
publication country chosen in Phase 1 — see [`references/jurisdictions.md`](references/jurisdictions.md)
for the full table (GDPR supervisory authority, consumer mediator, local e-commerce transposition
law, company identifier, withdrawal specifics). Three EU texts apply regardless of the chosen
country and must be cited by name in the produced documents:
- **GDPR (EU) 2016/679** — data protection, identical across the EU, only the competent supervisory
  authority changes by country.
- **e-Privacy Directive 2002/58/EC** — basis for cookie/tracker consent (Phase 3a banner),
  transposed differently by country but never to be reworded as a national rule.
- **Directive 2011/83/EU** — distance selling and 14-day withdrawal, transposed locally (national
  consumer code varies by country — see the jurisdictions table).

If no country is specified in Phase 1, the default behavior remains Belgium (CDE, APD, BCE,
Consumer Mediation Service) — zero change for projects that used this skill before multi-jurisdiction
support was added.

## Optional input (orchestrable)

If invoked from `compliance-officer` (standard or `--gdpr` mode) or from `frontend-agent` at the
end of a delivery, receive directly:
- The data processing activities and legal bases already settled (Phase R2 of `compliance-officer`)
- The designated DPO contact (pillar R-07)
- The list of processors / hosts / third-party tools already identified

If no context is provided, run Phases 1 through 3 to reconstruct it.

## Scope — what this skill does NOT do

- Does not calculate legal bases or retention periods: `compliance-officer` is the sole source. A
  project without a prior GDPR audit gets pages marked `TO BE DETERMINED — see compliance-officer`.
- Does not model cookie consent in the database or its technical persistence: that's handled by
  `frontend-agent`/`backend-agent` based on this skill (see Phase 4).
- Does not compute data minimization (which fields are actually necessary): `compliance-officer`
  remains the sole source (pillar R-02). This skill only publishes the consent text and flags
  collected fields with no stated purpose (Phase 2bis).

## Workflow

### Phase 1 — Scoping

If not provided as input, ask via **AskUserQuestion**:
0. **Publication country**: Belgium (default), France, Luxembourg, Netherlands, Germany, or Other
   EU country (in which case the exact country is asked explicitly). Determines the variant read
   from [`references/jurisdictions.md`](references/jurisdictions.md) for all Phase 3 documents —
   supervisory authority, mediator, company identifier, local transposition law. Without an
   explicit answer, default to Belgium.
1. Does the project have external (general public) users, or is it B2B/internal only?
   → determines whether terms of service/terms of sale are needed (skip if an internal tool with
   no external user accounts).
2. Does the site sell products/services to individuals (B2C), as a one-off purchase or a
   subscription/recurring payment?
   → determines whether terms of sale, 14-day withdrawal, a refund policy (Phase 3e), and a
   consumer mediator are needed.
3. Publisher / company name, host, publication director, contact details.
4. Designated DPO: name/department and contact (or `TO BE DESIGNATED` if not applicable under the
   GDPR threshold).

#### Simplified case — showcase site with no form or tracker

If the project is a pure showcase site: no form (contact, signup), no user account, no third-party
script (analytics, pixel, chat), no sales — Phase 2 grep comes back empty and Phase 1 confirms it —
then:
- **Do not produce**: consent banner, terms of sale, consumer mediator mention.
- **Still produce**: legal notice + functional contact details (the only obligations that remain
  regardless of the site, CDE Book XII).
- Explicitly note in the final report:
  `⏭️ Cookie banner / terms of sale / mediator not produced — showcase site with no form or tracker
  detected (Phase 1 + Phase 2). To be redone as soon as a form, account, or third-party script is
  added.`

### Phase 2 — Cookie and third-party script inventory

Grep the project to detect already-integrated or planned third-party scripts:
`google-analytics`, `gtag`, `matomo`, `hotjar`, `facebook.*pixel`, `meta.*pixel`, `intercom`,
`hubspot`, `stripe`, `sentry`, `mixpanel`.

Classify each detected script into a category:

| Category | Consent required | Examples |
|---|---|---|
| Essential (session, auth, cart, language) | No — always active | session cookie, CSRF token, language preference |
| Analytics | Yes, off by default | Google Analytics, Matomo |
| Marketing | Yes, off by default | Meta Pixel, HubSpot |
| Personalization | Yes, off by default | Hotjar, recommendations |

If no third-party script is detected, still produce the banner (at minimum the Essential
category) — a project with no tracking today may add it tomorrow without having to rebuild the
banner from scratch.

### Phase 2bis — Consent and minimization in forms

Grep the project for data-collection forms (beyond cookies): Blade/Filament Forms components,
React/Angular input components (`<form`, `useForm`, `FormGroup`, `Forms\Components\`), creation
endpoints (`store`, `POST /api/...`). For each form detected, list the collected fields.

If `intake/data-dictionary.md` exists (produced at bootstrap by the `data-dictionary` skill), cross-
reference each field with its **PII** column and necessity justification — same principle as
`compliance-officer` Phase R1: prioritize this structured source over a fallback grep. Otherwise,
limit to the list of detected fields with no necessity status (note `TO BE CHECKED — no
data-dictionary`).

For each form collecting data not essential to immediate execution (e.g. newsletter, profiling,
marketing preferences — not an account email or a shipping address required for the requested
service):
- Produce a consent text as a checkbox that is **never pre-checked**:
  `☐ I agree that my data be used for [precise purpose]. [Privacy policy link]`
- Produce the minimal GDPR Art. 13 information notice to display at the point of collection:
  purpose, legal basis, retention period, recipient, link to the full privacy policy.

Flag in the final report (Phase 5), without blocking the generation of the other documents, any
field collected with no stated purpose in `data-dictionary.md` or in the Phase 1 answers — this is
a minimization gap to pass on to `compliance-officer` (pillar R-02), not to fix yourself.

### Phase 3 — Document generation (5 possible, depending on applicability)

All documents go into `legal/` at the project root.

#### 3a — Consent banner (functional spec, not the component itself)

Write `legal/cookie-consent-spec.md`:

```markdown
# Cookie Consent Banner Specification

## Mandatory rules
1. Essential cookies always active, no consent required.
2. Non-essential cookies off by default, enabled only after explicit consent.
3. Granular consent by category (no standalone "Accept All").
4. Modifiable/revocable at any time via a "Cookie settings" link in the footer.
5. Persisted (a `consent_*` cookie or localStorage) to avoid re-asking on every visit.
6. No non-essential script loaded before the corresponding consent.

## Categories detected in this project
[Phase 2 table]

## Expected behavior
- First load with no recorded consent → banner shown, non-essential scripts blocked.
- Partial consent (e.g. Analytics yes, Marketing no) → only the Analytics scripts load.
- Consent withdrawn → scripts unloaded / not reloaded on the next refresh (verifiable in the browser's Network tab).

## Implementation
→ Component owned by `frontend-agent` (see Phase 4 of this skill for the hand-off).
```

#### 3b — Privacy policy

Write `legal/privacy-policy.md`, reusing, where available, the elements produced by
`compliance-officer` (legal bases from Phase R2, retention periods, rights):

```markdown
# Privacy Policy — [Project]

Last updated: YYYY-MM-DD

## Data controller
[Publisher / company name — Phase 1]

## Data Protection Officer (DPO)
[DPO contact — Phase 1, or "TO BE DESIGNATED — see compliance-officer pillar R-07"]

## Data collected and purposes
[Table from compliance-officer Phase R2, or "TO BE DETERMINED — GDPR audit required"]

| Data | Purpose | Legal basis | Retention period |
|---|---|---|---|

## Recipients and processors
[Host, third-party tools from Phase 2]

## Transfers outside the EU
[Reused from compliance-officer if available]

## Your rights
Access, rectification, erasure, portability, objection — contact: [DPO or data controller].
Response time: 1 month (Art. 12 GDPR).
Right to lodge a complaint with the competent supervisory authority — see
[`references/jurisdictions.md`](references/jurisdictions.md) for the chosen country from Phase 1
(**APD** by default if Belgium).

## Security
[Encryption measures — reused from compliance-officer pillar R-05 if available]

## Cookies
See [Cookie settings] — detailed banner in Phase 3a.

## Consent in forms
[If Phase 2bis detected non-essential forms: consent text and Art. 13 notice produced in Phase 2bis,
reused here or linked from each relevant form]
```

#### 3c — Legal notice

Write `legal/legal-notice.md`:

```markdown
# Legal Notice — [Project]

## Publisher
[Company name, legal form, company identifier (national business registry number, varies by
country — see `references/jurisdictions.md`), registered office address, contact — Phase 1]

## Publication director
[Name/role — Phase 1]

## Hosting
[Host name, address, contact — Phase 1]

## Contact details
Functional, monitored email — [contact@…], consistent with the one shown in the footer and in the
privacy policy (a single reference address across the whole site, not several diverging addresses
per page).

## Intellectual property
[Trademarks, content, licenses — standard, to adapt]

## Legal basis
General online information obligations — see `references/jurisdictions.md` for the national text
applicable to the country chosen in Phase 1 (CDE Book XII for Belgium by default).
```

#### 3d — Terms of Service (only if external users confirmed in Phase 1)

Write `legal/terms-of-service.md`:

```markdown
# Terms of Service — [Project]

## Purpose and acceptance
## Service access and user account
## User responsibilities
## Publisher responsibilities — limitations
## Account termination / suspension
## Governing law and jurisdiction
Law of the country chosen in Phase 1 (Belgian by default). Courts of the publisher's registered
office jurisdiction apply absent an amicable resolution.
```

If the project is an internal tool with no external users: skip explicitly, note
`⏭️ Terms of Service not produced — internal tool with no external users (confirmed Phase 1)`.

#### 3e — Terms of Sale (only if B2C sales confirmed in Phase 1)

Write `legal/terms-of-sale.md`:

```markdown
# Terms of Sale — [Project]

## Purpose and scope
## Products/services and pricing
Prices shown tax-included. [Detail — Phase 1]

## Order and payment
## Delivery / execution
[Timeframes, covered areas]

## Right of withdrawal
**14 calendar days** from receipt (goods) or contract conclusion (service) — local transposition
of EU directive 2011/83 (CDE Book VI for Belgium by default, see `references/jurisdictions.md` for
other countries). Standard withdrawal form provided as an appendix. Legal exceptions to the right
of withdrawal to be listed if applicable (customized goods, digital content supplied immediately
with express agreement, etc.).

## Refund policy
Beyond the legal 14-day withdrawal right above:
- **Subscription / recurring payment**: cancellation terms (notice period, effective at the end of
  the period or immediately), prorating calculation on mid-period cancellation, no refund for the
  period already consumed unless stated otherwise.
- **Digital content supplied immediately**: non-refundable once execution has begun with the
  consumer's express agreement and explicit waiver of their right of withdrawal (a condition to
  document at the time of purchase, not inferred after the fact).
- **Customized / made-to-order goods**: excluded from the right of withdrawal (legal exception), to
  be explicitly restated here rather than implying a possible refund.
- Any refund granted beyond these cases is the publisher's own commercial policy (timeframe,
  request channel) — to be filled in at Phase 1 if the publisher offers one.

## Legal warranties
Conformity warranty — 2 years for goods sold to a consumer (CDE Book VI for Belgium by default, see
`references/jurisdictions.md` for other countries).

## Consumer mediator
In case of an unresolved dispute, the consumer may refer the matter to the consumer mediator
competent for the country chosen in Phase 1 — see `references/jurisdictions.md` (**Consumer
Mediation Service**, the Belgian federal mediator approved by the Economy Ministry,
https://mediationconsommateur.be, by default if Belgium) or an approved sector-specific mediator if
one exists for the sector. [The publisher's prior membership must be verified before publication —
a mediator can only be cited if the publisher has actually joined it.]

## Governing law and jurisdiction
Law of the country chosen in Phase 1 (Belgian by default).
```

If the project doesn't sell anything to individuals (B2B only, or no sales): skip explicitly, note
`⏭️ Terms of Sale not produced — no B2C sales confirmed (Phase 1)`.

#### 3f — Content checks (checklist, not a dedicated file)

Check and flag in the final report, without blocking document generation:
- **Customer reviews**: if the site displays reviews, verify they're real and not fabricated —
  an unfair commercial practice sanctioned under CDE Book VI.
- **Quantified claims** (%, timeframes, savings, performance): must be backed by verifiable proof,
  otherwise reword or remove.
- **Image rights**: images/visuals used must be licensed or have documented usage rights — flag if
  the origin isn't tracked in the project.
- **Contact consistency**: same email/address everywhere (legal notice, footer, privacy policy,
  terms of sale) — a mismatch is a classic sign of non-compliance.

### Phase 3g — Filament admin interface (if a Laravel stack is detected)

If the project is Laravel (detection: `composer.json` contains `laravel/framework` and
`filament/filament`), the Phase 3 documents don't stay as plain Markdown files frozen at generation
time: they become the **initial seeded content** of an editable table, so the user (or the AI, on
explicit request) can revise them without going back through this skill.

Pattern to scaffold — **documented here only**, a single source referenced (never duplicated) from
`skills/laravel-developer/SKILL.md` and `agents/backend-agent.md`:

- **Migration** `legal_documents`: `type` (enum `privacy-policy`, `terms-of-service`,
  `terms-of-sale`, `cookies`, `legal-notice`), `country` (the country chosen in Phase 1), `content`
  (long text, Markdown or HTML), `version` (incrementing integer), `published_at` (nullable — draft
  until published), `is_current` (boolean, only one current record per `type` + `country`).
- **Model** `LegalDocument` with a `current()` scope (`type` + `country` + `is_current = true`) —
  this is the scope the front end should consume to display the published page, never a static file.
- **Filament Resource** `LegalDocumentResource`: a `RichEditor` or `MarkdownEditor` field for the
  content, a list with version history (each publication **creates a new versioned row** instead of
  overwriting the previous one — traceability of terms of service/privacy policy changes, useful in
  case of a dispute). A "Publish" action switches `is_current` to the new version and removes it
  from the old one, with an `published_at` timestamp.
- **Initial seed**: a seeder (or a dedicated Artisan command) inserts the Markdown content produced
  in Phase 3 as the first version (`version = 1`, `is_current = true`) for each applicable document
  — this skill doesn't write that seeder itself, it describes it in the Phase 4 hand-off for
  `backend-agent`.

**⚠️ Fallback**: if the project isn't Laravel/Filament, skip this phase and leave the Phase 3
documents as static Markdown files — to be published through the content mechanism native to the
detected stack (CMS, static route, etc.), without imposing Filament outside its context.

### Phase 4 — Technical hand-off

Produce a summary of implementation obligations to pass to `frontend-agent` /
`backend-agent`:

```markdown
## Implementation hand-off — legal-pages

- [ ] Consent banner compliant with `legal/cookie-consent-spec.md`
- [ ] Non-essential scripts conditioned on consent (deferred or blocked loading)
- [ ] "Cookie settings" link accessible from every page (footer)
- [ ] `legal/privacy-policy.md`, `legal/legal-notice.md` (and `terms-of-service.md`/`terms-of-sale.md`
      if applicable) pages published and linked from the footer
- [ ] Consent withdrawal verified in the browser's Network tab (manual or Playwright test)
- [ ] Phase 2bis consent texts and Art. 13 notices integrated into every relevant form,
      checkbox never pre-checked
- [ ] If Laravel/Filament stack: migration + `LegalDocument` Model + Resource + Phase 3g seeder
      scaffolded, front end consuming `LegalDocument::current()` rather than a static file
```

**⚠️ Fallback**: if `frontend-agent`/`backend-agent` are unavailable, leave this hand-off in the
final report — don't block the generation of the legal documents.

**Automatic invocation — accessibility**: as soon as this skill produces a consent banner
(Phase 3a) or a form consent text (Phase 2bis), **call the Skill tool with
`accessibility-lead`**, passing it these components (contrast, keyboard navigation,
screen reader announcement of the banner — an accessibility defect on a consent component is a
frequent complaint, not a mere documentary hand-off). **⚠️ Fallback**: if `accessibility-lead`
is unavailable, note in the final report `⚠️ accessibility-lead unavailable — consent banner/
forms not audited, manual WCAG 2.1 AA check required before going to production`.

**Out of scope — handed off to other skills** (to mention in the report, never duplicated
here):
- General UI accessibility (beyond the consent banner/forms, already covered above) → the
  `accessibility-lead` skill. Reference standard: WCAG 2.1 AA, and the European
  Accessibility Act (EU) 2019/882, which makes it legally mandatory for certain B2C
  digital services in the EU.
- Accessibility to AI engines (`llms.txt`, semantic structuring, `robots.txt` openness) →
  the `seo-geo` skill.

### Phase 5 — Report and persistence

- **Standalone**: create the directory via Bash (`mkdir -p legal`), write the Phase 3 files +
  a summary `legal/README.md` listing the produced documents and their status (complete /
  `TO BE DETERMINED` pending a GDPR audit).
- **Orchestrated from `compliance-officer`**: return the Markdown content of the produced documents
  + the Phase 4 hand-off; persistence stays with the caller if it already centralizes
  the writing (otherwise write directly into `legal/`).
- **Orchestrated from `project-bootstrap-agent` (bootstrap, Phase 6b)**: produce the same documents
  but explicitly mark them **draft** (header `> 📝 Bootstrap draft — finalize via
  team-dev --full before going live`) — the legal bases are not yet thoroughly
  audited at this stage.

## Completion criterion — definition of "done" for a web delivery

Reused from the cross-cutting rule in AGENTS.md ("Legal pages & consent" section): a web delivery
is only done when
1. the consent banner is present and functional,
2. non-essential scripts are conditioned on consent,
3. withdrawing consent effectively disables the scripts (verifiable on the network),
4. a "Cookie settings" link is accessible from every page,
5. every form collecting non-essential data shows an explicit, **never pre-checked** consent and
   the corresponding Art. 13 notice (Phase 2bis),
6. no collected field lacks a stated purpose (minimization flagged otherwise),
7. the consent banner and forms have been audited by `accessibility-lead` (or the gap is explicitly
   flagged if the skill was unavailable).

A project that produces this skill's documents but hasn't checked these 7 points on the frontend
side isn't "done" — the final report must say so explicitly rather than reporting success.

## Skip memory

The `legal/*.md` documents are versioned project deliverables, not memories — don't record them in
`~/.claude/memory/`.
