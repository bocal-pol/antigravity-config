---
name: visiteurs
description: "Simulates AI visitors testing a web application before it goes to production: a first screenshot glance (understood in 5 seconds, spots the action button), then real navigation (clicks, form, scrolling) on a representative sample, following a profile and patience level specific to each persona. Produces an aggregated UX feedback report (comprehension, friction, conversion). Auto-invoke on mention of: user test, visitor test, simulate visitors, crowd test, pre-launch UX feedback, 5-second first glance, conversion test, usability test, pre-launch UX feedback."
model: claude-sonnet-5
user-invocable: true
type: domain
priority: high
scope: frontend
dependencies: []
conflicts: []
---

# Visiteurs — AI Visitor Simulation Before Production

Has an application tested by AI-simulated visitors before showing it to real
people: a blind first glance on a screenshot, then real navigation on a
representative sample. Produces a friction and conversion report — **these are AI
opinions, not real users**, a first filter, never a replacement for real tests.

## Optional Input (orchestrable)

If invoked from `team-dev` (Phase D, step D1.7) or any other agent, receive directly:
- The URL of the application to test (local dev server or staging environment)
- The main goal of the tested page/app (signup, purchase, contact...) — read
  `intake/app-spec.md` first if available rather than re-asking
- The detected stack (to adapt navigation selectors in Phase 5)
- The number of personas if specified (otherwise Phase 1 default)

If no context is provided, run Phase 1 to reconstruct it.

## Scope — what this skill does not do

- Does not replace real user tests — AI-generated feedback remains a hypothesis to
  verify, never a definitive validation. The report (Phase 8) explicitly reminds of this.
- Does not perform in-depth accessibility auditing (contrast, ARIA, screen reader, keyboard
  navigation): delegated to the `accessibility-lead` skill (Phase 6), never reimplemented here.
- Does not test pages behind complex authentication (SSO, MFA) without a session already
  provided as input — flag the gap rather than attempt a workaround.

## Workflow

### Phase 1 — Framing (if not provided)

If not provided as input, ask via **AskUserQuestion**:
1. URL to test (`http://localhost:3000` by default, or staging URL).
2. Main goal of the page: what a visitor should understand and do first.
3. Number of personas: **100 by default** (reference for pre-production
   validation) — offer `--quick` (20 personas) for a less costly iteration during
   development.
4. Profiles to overrepresent if relevant (e.g. mobile only, senior B2B audience) — otherwise
   automatic generation covering desktop/mobile and the three categories of Phase 2.

⚠️ Explicitly warn about the token cost before launching 100 personas — proportional to the
number of subagent waves in Phase 4 (5 batches of 20 for N=100).

### Phase 2 — Persona generation

Generate N varied profiles, each with: age, occupation, reason for visiting the site, device
(desktop/mobile), technical level, patience (low/medium/high), and one of three categories:

| Category | Approximate share | Role |
|---|---|---|
| Target audience | ~60% | Matches exactly the product's target |
| Curious | ~25% | Could convert but not yet convinced |
| Off-target | ~15% | Shouldn't convert — checks the page doesn't mislead anyone |

### Phase 3 — Initial capture

Via `mcp__playwright__browser_navigate` on the target URL, then `mcp__playwright__browser_take_screenshot`
in desktop viewport, then `mcp__playwright__browser_resize` (mobile viewport) followed by a second
capture. Keep both images for Phases 4 and 7.

**⚠️ Fallback**: if the `mcp__playwright__*` tools are unavailable in the execution
environment, continue with static capture only (Phase 4) and skip Phase 5 (real
navigation) — note the limitation in the final report rather than failing silently.

### Phase 4 — Wave 1: first glance (all personas, on the screenshot)

Split the N personas into batches of 20 (5 batches for N=100, 1 batch for `--quick`) and launch one
subagent per batch **in parallel** (a single level of orchestration, per the subagent discipline in
the orchestration guidance). Each subagent receives its batch of personas and the two
captures, and answers for each:
- Understood in 5 seconds: yes/no + what they understood
- Finds the main action button: yes/no
- Would read further / would act based on their patience: yes/no
- A verbatim quote of their first reaction

### Phase 5 — Wave 2: real navigation (representative sample)

Select ~10% of the personas (10 of 100, minimum 5 for `--quick`), prioritizing: any
"off-target" persona who nonetheless says they want to convert (a signal of a misleading page to
check), a mix of high/low patience, and a desktop/mobile balance. For this sample, actually
navigate via `mcp__playwright__browser_click`, `browser_type`, `browser_fill_form`,
`browser_press_key`, `browser_wait_for` — up to the target action or abandonment (patience exhausted).
Note the number of steps before abandonment and the exact blocking point (selector, label).

`--full-navigation` parameter: extend Phase 5 to all personas rather than a
sample — only on explicit request, significantly higher cost.

### Phase 6 — Complementary checks

- **Accessibility**: call the Skill tool with `accessibility-lead` on the tested page (contrast,
  keyboard navigation, ARIA, screen reader). **⚠️ Fallback**: if unavailable, note the gap in
  the final report rather than improvising a partial check.
- **Technical**: perceived load time (Phase 3/5), broken links detected during Phase 5,
  visibility of prices and social proof (reviews, client logos) in the Phase 3 capture.

### Phase 7 — Variant testing (optional)

If the Phase 1 goal concerns a title/tagline that converts poorly in Phase 4, propose 2-3
alternative variants and have them judged by a sub-sample of 10 personas (same method as
Phase 4, capture modified only on the tested title).

### Phase 8 — Report

Aggregate the results of Phases 4, 5, 6 and 7 (if run). Calculate:
- % understood in 5 seconds, % find the action button, % would go through / convert
- Most cited friction points, grouped, with the number of personas concerned
- Most representative verbatim quotes
- Results by profile (desktop/mobile, target audience/curious/off-target)
- 5 priority fixes, each backed by a number (e.g. "42/100 can't find the
  button — move it above the fold")

Write:
- `ux-tests/visiteurs/YYYY-MM-DD_visiteurs.md` — structured report with a synthetic
  ✅/⚠️/❌ status at the top of the file, consumable by `memory-rituel` and by `team-dev`'s master report
- `ux-tests/visiteurs/YYYY-MM-DD_visiteurs.html` — standalone visual report (inline CSS, no
  external dependency), same indicators presented as cards

Systematic reminder at the top of both reports: **"AI-simulated opinions, not real
users — a first filter, not a replacement for real user testing."**

**⚠️ Orchestration fallback**: if invoked from `team-dev` on a project with no publicly
exposed interface (pure API, internal tool with no front): explicit skip from Phase 1, note
`⏭️ visiteurs not run — no exposed user interface`.

## Skip memorization

The `ux-tests/visiteurs/*.md`/`.html` report is a versioned project deliverable, not a memory — don't
log it in `~/.claude/memory/`.
