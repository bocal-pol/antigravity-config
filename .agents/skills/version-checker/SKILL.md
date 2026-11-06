---
name: version-checker
description: "Detects the languages and frameworks used in a project, compares their current version to the latest stable version and their EOL status, without scanning the code or proposing a migration plan. Auto-invoke on: check versions, which version, outdated version, check versions, up-to-date language, up-to-date framework, version watch, EOL, end of life."
model: claude-haiku-4-5-20251001
user-invocable: true
type: utility
priority: low
scope: cross
dependencies: []
conflicts: []
---

# Version Checker

Detects the languages/frameworks present in a project, compares the current version to the latest
known stable one, and flags EOL — without scanning the code or producing a migration plan (that
role belongs to `version-updater`).

## Optional Input (if invoked from team-dev or version-updater)

Receive: the project root to analyze. Return: the Markdown table + a boolean
`major_gap` + the `eol_stacks` list, without writing a file — the caller manages its own
cache/persistence.

## Workflow

### Phase 1 — Manifest detection

Glob at the project root (and one level of subfolders for a monorepo), excluding
`node_modules/`, `vendor/`, `.git/`:

- `composer.json` → PHP (`require.php`) + Laravel/Symfony (`require."laravel/framework"` /
  `require."symfony/framework-bundle"`)
- `package.json` → Node.js (`engines.node`) + Angular (`@angular/core`) + React (`react`) + Vue
  (`vue`)
- `*.csproj` / `Directory.Build.props` → .NET (`<TargetFramework>`)
- `pubspec.yaml` → Flutter/Dart (`environment.sdk`, `flutter`)
- `requirements.txt` / `pyproject.toml` → Python (`python_requires` / `requires-python`) +
  Django/Flask/FastAPI if present in dependencies
- `go.mod` → Go (`go` directive)
- `Gemfile` → Ruby + Rails
- `pom.xml` / `build.gradle` → Java/Kotlin + Spring Boot

A missing manifest means the stack is absent from the project — no warning.

### Phase 2 — Current version vs latest stable

For each detected stack, read the current version from the manifest. Obtain the latest
stable version and support status via `context7-mcp` (if the stack has indexed
documentation) or `WebFetch` on an official source (endoflife.date, official release page) —
never guess a recent version from the model's memory alone when in doubt.

### Phase 3 — Compact report

```
## Version Check — YYYY-MM-DD

| Stack | Current version | Latest stable | Gap | Support status |
|-------|------------------|-----------------|-------|-----------------|
| Laravel | 10.x | 12.x | Major (2 versions) | EOL since Feb 2025 |
| Node.js | 18.x | 22.x | Major | Active |

Major gap or EOL detected: Yes/No
```

### Phase 4 — Conditional persistence

- **Standalone**: create the folder via Bash (`mkdir -p reports/version-checker`), write
  `reports/version-checker/YYYY-MM-DD_version-checker.md`
- **Orchestrated** (`team-dev`, `version-updater`): return the Markdown + `major_gap` +
  `eol_stacks` without writing a file
