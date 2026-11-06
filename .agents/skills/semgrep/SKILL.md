---
name: semgrep
type: utility
priority: high
scope: security
model: claude-sonnet-5
dependencies: []
conflicts: []
description: >
  Semgrep OSS wrapper via Docker Compose — local SAST scan, SARIF findings parsing,
  blocking gate on HIGH/CRITICAL. Invocable standalone or from security-agent,
  appsec, pr-review-agent, ci-scan.
---

# Semgrep — Local SAST via Docker Compose

Runs a Semgrep scan on target source code via the project's InfraDocker Docker Compose
container, parses SARIF findings, filters by severity, and generates a
structured report.

## Prerequisites

The Semgrep container must be available via:
```bash
docker compose -f COMPOSE_FILE run --rm semgrep --version
```

Known compose file paths depending on the machine:
- Primary Windows: `C:\Projet\SiteV26\InfraDocker\compose.dev-tools.yaml`
- Alternate disk: `D:\site26\SiteV26\InfraDocker\compose.dev-tools.yaml`

Detect the right path in Phase 1 — use whichever file exists.

## Expected input

- `TARGET_PATH`: absolute or relative path of the folder to scan (mounted into the container's `/src/`)
- `RULESETS`: list of rulesets to enable (default: see below)
- `COMPOSE_FILE`: path to `compose.dev-tools.yaml` (required if non-standard)
- `DIFF_ONLY`: true/false — scan only modified files (default: false)
- `FAIL_ON`: minimum blocking severity — `ERROR` (default) | `WARNING` | `never`

## Default rulesets

```
p/owasp-top-ten
p/secrets
p/php
p/typescript
```

Complementary rulesets available:
- `p/laravel` — Laravel-specific patterns
- `p/javascript` — vanilla JavaScript
- `p/docker` — Dockerfiles and compose
- `p/ci` — CI/CD pipelines
- `p/sql-injection` — in-depth SQL injection

## Workflow

### Phase 1 — Environment validation

**Step 1a — Detect the compose file:**
```bash
# Try both known paths
if (Test-Path "C:\Projet\SiteV26\InfraDocker\compose.dev-tools.yaml") {
    $COMPOSE_FILE = "C:\Projet\SiteV26\InfraDocker\compose.dev-tools.yaml"
} elseif (Test-Path "D:\site26\SiteV26\InfraDocker\compose.dev-tools.yaml") {
    $COMPOSE_FILE = "D:\site26\SiteV26\InfraDocker\compose.dev-tools.yaml"
} else {
    Write-Warning "⚠️ SEMGREP ABSENT — compose.dev-tools.yaml not found at known paths:"
    Write-Warning "  · C:\Projet\SiteV26\InfraDocker\compose.dev-tools.yaml"
    Write-Warning "  · D:\site26\SiteV26\InfraDocker\compose.dev-tools.yaml"
    Write-Warning "Verify that InfraDocker is cloned and the container is started."
    exit 2
}
```

**Step 1b — Verify the container responds:**
```bash
docker compose -f $COMPOSE_FILE run --rm semgrep --version
```

If the command fails (exit ≠ 0):
```
⚠️ SEMGREP ABSENT — The Semgrep container is not responding.
Possible causes:
  · Docker Desktop not started
  · Image semgrep/semgrep:1.90.0 not pulled (docker pull semgrep/semgrep:1.90.0)
  · "semgrep" service absent from compose.dev-tools.yaml
Action: verify with `docker compose -f COMPOSE_FILE run --rm semgrep --version`
SAST scan cancelled — report as "semgrep unavailable" in the report.
```

If invoked from `security-agent` or `appsec`: return status `SEMGREP_UNAVAILABLE` to the calling skill so it documents the absence in its report.

### Phase 2 — Building the scan command

Standard command (full scan):
```bash
docker compose -f COMPOSE_FILE run --rm semgrep scan \
  --config p/owasp-top-ten \
  --config p/secrets \
  --config p/php \
  --config p/typescript \
  --metrics=off \
  --json \
  --output /tmp/semgrep-results.json \
  /src/TARGET_PATH
```

Diff-scoped command (PR review):
```bash
docker compose -f COMPOSE_FILE run --rm semgrep scan \
  --config p/owasp-top-ten \
  --config p/secrets \
  --config p/php \
  --config p/typescript \
  --metrics=off \
  --json \
  --output /tmp/semgrep-results.json \
  --include="MODIFIED_FILES" \
  /src/TARGET_PATH
```

Gating parameter (add to the command):
- `--error` → exit code 1 if ERROR-severity findings (default — blocking)
- `--severity ERROR` → only report ERROR/CRITICAL findings
- Omit `--error` for report-only mode (exit 0 always)

### Phase 3 — Parsing results

Read the produced JSON file. Extract per finding:

| Field | JSON source |
|---|---|
| `check_id` | `.results[].check_id` |
| **Severity** | `.results[].extra.severity` (ERROR=Critical, WARNING=High, INFO=Low) |
| **File:line** | `.results[].path` + `.results[].start.line` |
| **Message** | `.results[].extra.message` |
| **OWASP** | `.results[].extra.metadata.owasp` (if present) |
| **CWE** | `.results[].extra.metadata.cwe` (if present) |
| **Code extract** | `.results[].extra.lines` |

Semgrep → internal convention severity mapping:

| Semgrep | Convention | Gating |
|---|---|---|
| `ERROR` | Critical | Blocking |
| `WARNING` | High | Blocking |
| `INFO` | Low | Non-blocking |

### Phase 4 — Structured report

```
**SEMGREP SAST REPORT**
Date: YYYY-MM-DD
Target: TARGET_PATH
Rulesets: p/owasp-top-ten, p/secrets, p/php, p/typescript
Findings: X Critical (ERROR), X High (WARNING), X Low (INFO)
Gating status: BLOCKED / OK

**Critical and High findings** (descending severity order)

[CRITICAL] check_id
- File: path/file.ext:line
- OWASP: AXX:2021 (if available)
- CWE: CWE-XXX (if available)
- Message: rule message
- Code: vulnerable code extract
- Action: recommended remediation

**Low findings** (summary)
X INFO findings — see the full JSON for detail.

**Verdict**
✅ OK — no blocking finding detected.
❌ BLOCKED — X Critical/High findings to fix before merge.
```

### Phase 5 — Persistence

- If invoked from `security-agent` or `appsec`: don't write a file — pass findings to the calling skill.
- If invoked standalone:
  1. `mkdir -p security/semgrep`
  2. Write `security/semgrep/YYYY-MM-DD_semgrep.md` (Phase 4 report)
  3. Keep the raw JSON in `security/semgrep/YYYY-MM-DD_semgrep-raw.json`

## Exit codes

| Code | Meaning |
|---|---|
| `0` | Scan OK, no blocking finding |
| `1` | ERROR or WARNING findings detected (gating active) |
| `2` | Configuration error or container unavailable |

## Use cases

### Full project scan
```
/semgrep TARGET_PATH=/src/MyProject COMPOSE_FILE=/path/InfraDocker/compose.dev-tools.yaml
```

### Diff-scoped scan (PR review — called by pr-review-agent)
```
/semgrep TARGET_PATH=/src/MyProject DIFF_ONLY=true COMPOSE_FILE=...
```

### PHP-only scan
```
/semgrep RULESETS="p/php p/laravel p/owasp-top-ten" TARGET_PATH=...
```

## CI/CD integration (GitHub Actions)

```yaml
name: Semgrep SAST
on:
  pull_request:
    branches: [main, develop]

jobs:
  semgrep:
    runs-on: ubuntu-latest
    container:
      image: semgrep/semgrep:1.90.0
    steps:
      - uses: actions/checkout@v4

      - name: Run Semgrep
        run: |
          semgrep scan \
            --config p/owasp-top-ten \
            --config p/secrets \
            --config p/php \
            --config p/typescript \
            --metrics=off \
            --sarif \
            --output semgrep.sarif \
            --error \
            .

      - name: Upload SARIF
        if: always()
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep.sarif
```

## CI/CD integration (GitLab CI)

```yaml
semgrep-sast:
  stage: test
  image: semgrep/semgrep:1.90.0
  script:
    - semgrep scan
        --config p/owasp-top-ten
        --config p/secrets
        --config p/php
        --config p/typescript
        --metrics=off
        --sarif
        --output semgrep.sarif
        --error
        .
  artifacts:
    reports:
      sast: semgrep.sarif
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
```

## Notes

- `--metrics=off`: disables Semgrep telemetry (mandatory in internal environments).
- The Docker container mounts the source code in `/src/` — adapt the volume in `compose.dev-tools.yaml` if needed.
- Docker image used: `semgrep/semgrep:1.90.0`.
- In diff-scoped mode, pass the list of modified files via `--include` to limit noise.
