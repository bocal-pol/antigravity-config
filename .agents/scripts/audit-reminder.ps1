# audit-reminder.ps1 - forces a /claude-api prompt-audit reminder at session end
# when files in the prompt surface (AGENTS.md, primer.md, hindsight.md,
# .agents/, .agents/skills/) were modified in this session and not yet audited.
#
# NOTE (unconfirmed Antigravity support): see PORTING-NOTES.md - whether
# Antigravity triggers a Stop-equivalent hook, and whether a blocking exit
# code (2) is honored the way it is by Claude Code, is unverified. Kept as a
# best-effort artifact, ported from the source repo's Claude Code Stop hook
# of the same name.
#
# In the source repo this is wired to Claude Code's Stop hook
# (.claude/settings.json). Blocks session end ONCE PER CHANGE SET: a marker
# (.agents/tmp/.audit-reminded-<hash>) remembers that the reminder already
# fired for the current state of the repo, to avoid an infinite loop.
#
# Exit codes: 0 = nothing to report or already done, 2 = blocks session end
# and passes the instruction to the model via stderr (Claude Code's Stop
# hook mechanism - unconfirmed on Antigravity, see note above).
# Portable: no hardcoded user path, PowerShell 5.1, no external module.
# No em dash or typographic quote in this file.

$ErrorActionPreference = 'SilentlyContinue'

function Find-Git {
    $cmd = Get-Command git -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    foreach ($p in @("$env:LOCALAPPDATA\Programs\Git\cmd\git.exe", "$env:ProgramFiles\Git\cmd\git.exe")) {
        if (Test-Path $p) { return $p }
    }
    return $null
}

$git  = Find-Git
$repo = (Get-Location).Path

if (-not $git) {
    exit 0
}

if (-not (Test-Path (Join-Path $repo '.git'))) {
    exit 0
}

# Files with a real content diff (not just a line-ending change that
# core.autocrlf marks "modified" in status --porcelain with no real diff)
# or untracked, touching the prompt surface.
$paths = @('AGENTS.md', 'primer.md', 'hindsight.md', '.agents', 'PRODUCT-RULES.md')
$modified  = @(& $git -C $repo diff --name-only -- $paths 2>$null)
$staged    = @(& $git -C $repo diff --cached --name-only -- $paths 2>$null)
$untracked = @(& $git -C $repo ls-files --others --exclude-standard -- $paths 2>$null)
$changed = @($modified + $staged + $untracked | Sort-Object -Unique)

if ($changed.Count -eq 0) {
    exit 0
}

# Marker keyed on the current change set: an MD5 hash of the changed-file
# list, so the reminder fires only once per state (and again if new changes
# are added on top).
$statusHash = ($changed -join "`n") | Out-String
$hashObj = [System.Security.Cryptography.MD5]::Create()
$bytes = [System.Text.Encoding]::UTF8.GetBytes($statusHash)
$hash = [BitConverter]::ToString($hashObj.ComputeHash($bytes)).Replace('-', '').Substring(0, 12)

$tmpDir = Join-Path $repo '.agents\tmp'
if (-not (Test-Path $tmpDir)) {
    New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
}
$marker = Join-Path $tmpDir ".audit-reminded-$hash"

if (Test-Path $marker) {
    exit 0
}

New-Item -ItemType File -Path $marker -Force | Out-Null

[Console]::Error.WriteLine("Files in the prompt surface of this repo were modified in this session ($($changed.Count) file(s): AGENTS.md, primer.md, hindsight.md, .agents/ or .agents/skills/). Before closing, run a prompt audit to check that no dated pattern was introduced or left behind. Do not ask again for this same change set.")
exit 2
