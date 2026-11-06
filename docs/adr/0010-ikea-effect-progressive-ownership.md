# ADR 0010 — Ikea effect: progressive ownership in consumer-facing projects

- **Status**: accepted
- **Date**: 2026-08-24

## Context

Projects with end consumers suffer from a weak sense of ownership over the tool. The user is using a generic product, not "their" product. This reduces adoption and accelerates churn. The psychological principle known as the "Ikea effect" (Norton, Mochon, Ariely 2012) shows that people value more highly what they've partially built or configured themselves.

## Decision

Every consumer-facing (B2C) application must expose a progressive customization surface, broken into three layers:

1. **Visual identity** (avatar, theme, colors)
2. **Content & data** (favorites, shortcuts, widgets)
3. **Behavioral** (language, notifications, density)

Triggered via an optional onboarding (1–3 skippable steps) complemented by contextual nudges. Customization is gated behind an auth system — preferences must survive a logout/login cycle.

## Positive consequences

- Increases the sense of ownership and retention
- Reduces early churn through the user's initial investment
- Differentiates the product without complex features

## Negative consequences / risks

- Adds backend complexity (per-user preference storage)
- Requires careful UX design to avoid friction

## Alternatives considered

- **Mandatory onboarding (forced steps)**: creates friction and drop-off before first use. Rejected.
- **Zero discovery (no onboarding)**: ownership stays weak. Rejected.
- **localStorage with no auth**: ephemeral customization, frustration on re-login. Rejected.

## Scope

Consumer-facing (B2C) projects only. Excluded: internal tools, APIs, single-client B2B, MVPs under 2 weeks.
