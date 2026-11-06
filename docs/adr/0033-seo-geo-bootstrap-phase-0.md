# ADR 0033 — SEO/GEO bootstrap: mandatory Phase 0 before any frontend development

- **Status**: accepted
- **Date**: 2026-08-21

## Context

Applications were launched with no discoverability files: no `robots.txt`, no sitemap, no `llms.txt` (LLM discoverability), no og/geo meta tags. SEO and discoverability by AI engines were ignored until production launch.

## Decision

`frontend-agent` checks for SEO/GEO files before any frontend development (Phase 0):

- `public/robots.txt`
- `public/sitemap.xml`
- `public/llms.txt` and `public/llms-full.txt`
- A WebManifest (JSON)
- Meta tags: `og:title`, `geo.region`, `application/ld+json`

If missing → invoke the `seo-geo` skill to create them.

Skip allowed if the project declares `seo: backend` (a pure API, no public interface).

## Positive consequences

- Guaranteed discoverability from the first deployment
- `llms.txt` prepares the project for indexing by AI agents
- No SEO scrambled together in a rush after launch

## Alternatives considered

- **SEO after launch**: too late, hurts initial indexing. Rejected.
- **Optional SEO**: systematically forgotten. Made mandatory in Phase 0.

## Scope

Frontend — all projects with a public interface.
