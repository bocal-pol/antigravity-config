# ADR 0069 — Multi-jurisdiction EU support for legal-pages

- **Status**: accepted
- **Date**: 2026-10-30

## Context

The `legal-pages` skill targeted exclusively one EU member state's law by original design choice, to
avoid mixing references across jurisdictions. This fixed framing became a blocker as soon as a
project targeted another EU country: the generated text cited the wrong country's consumer-code
articles and data-protection authority even for a French or Dutch project — a substantive error, far
worse than a cosmetic imprecision on a published legal document.

## Decision

`legal-pages` selects the publishing country in Phase 1 (one default country, or France,
Luxembourg, the Netherlands, Germany, or a generic template for another EU country) and reads the
corresponding variants (the data-protection supervisory authority, the consumer-mediation body, the
national transposition text, the business-identifier format) from
`skills/legal-pages/references/jurisdictions.md`. The three EU-wide texts that never vary (the
GDPR, the ePrivacy directive, and the Consumer Rights Directive) are cited by name in every
generated document, regardless of the chosen country. The default behavior (no country specified)
stays the original default country, with no regression for existing projects.

## Positive consequences

- A project targeting another EU country gets legally correct documents on first generation, with no
  manual review needed to fix national references.
- The shared EU foundations (GDPR, ePrivacy, the Consumer Rights Directive) are finally named
  explicitly, which was missing even for projects in the default country.
- The jurisdictions table is a single extension point — adding a country doesn't require touching
  the document templates.

## Negative consequences / risks

- Higher maintenance: every national regulatory change (a new authority, a new transposition text)
  must be reflected in `references/jurisdictions.md`, country by country.
- The generic "other EU country" template stays incomplete by design (placeholders to fill in) — a
  project in a country not explicitly covered gets partial documents, not ready to publish as-is.
- Risk of confusion if the country chosen in Phase 1 isn't clearly stated in the final report — worth
  watching in real use.

## Alternatives considered

- **Staying single-country by default, only adding the named EU foundations**: simpler to maintain,
  but doesn't solve the underlying problem for a project outside that country — rejected given an
  explicit request for multi-country coverage starting this iteration.
- **An external translation/adaptation service at generation time** (e.g. a systematic call to a
  local law firm): outside the scope of a bootstrap skill, and doesn't remove the need for a correct
  first draft.

## Scope

Applies to `skills/legal-pages/SKILL.md` and its new reference file. No effect on
`compliance-officer` (which stays jurisdiction-agnostic, since GDPR substance is identical across the
EU). Out of scope: non-EU countries, not covered by this skill.
