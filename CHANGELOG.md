# Changelog

All notable changes to `antigravity-config`. Format
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), versioning
[SemVer](https://semver.org/).

**Versioning applies to the repository, not to each skill.** A `version:` field in every
frontmatter would be dozens of values to maintain by hand for information `git log` already gives.

What counts as a **breaking** (major) change: a `team-dev` mode removed or renamed, a skill removed
or merged, an agent renamed, a frontmatter convention that invalidates existing files. A skill can
be added or enriched without being a breaking change.

## [Unreleased]

### Added

- Initial Antigravity-format port of a private AI coding-assistant configuration: `AGENTS.md`,
  `primer.md`, `hindsight.md`, product rules, contributor guide, security policy, and the
  `.agents/` skill and agent structure.
- `PORTING-NOTES.md` and `RENAME-MAP.md` documenting the port's format uncertainties and every
  renamed agent/skill.

---

## Before this changelog

This repository starts fresh as a port; it carries no changelog history prior to this entry. The
source configuration's own history is not reproduced here.
