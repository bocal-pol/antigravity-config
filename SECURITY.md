# Security policy

This repository is a shared AI-assistant configuration. A flaw here does not compromise a
production service, but it runs on every machine that has adopted it.

## Reporting an issue

Open a **private** issue (security advisory) on the repository, or contact the maintainer directly.
Do not describe the problem in a public issue until a fix is available.

In scope:

- A secret, token, password, or personal data present in a versioned file or in git history.
- A hook, script, or skill that runs a destructive command without confirmation.
- A declared guard-rail that does not actually apply (the most frequent defect kind in this type of
  repository: a protection can remain inoperative for months without anything signaling it).
- An absolute user path or an account identifier in a file tracked by git.

## What must never be committed

| Item | Where it should live |
| --- | --- |
| Credential/token files (OAuth, API keys) | On the local machine only — git-ignored, and denied by permission settings |
| Passwords, private keys, API tokens | A secrets manager (Vault, SOPS, Docker Secrets…). **Never an env file**, even in local development |
| Account identifiers, employee IDs, internal zone names | Nowhere in a versioned file |
| Local settings overrides, memory, session transcripts | On the local machine — all git-ignored |

## Checking before pushing

```bash
# No absolute Windows user path in tracked files
git grep -n -E 'C:\\Users\\[A-Za-z0-9]'

# Branch guard-rails respond correctly
echo '{"tool_name":"Bash","tool_input":{"command":"git push origin main"}}' | bash pre-tool-use.sh   # expected: 2
echo '{"tool_name":"Bash","tool_input":{"command":"git push origin feature/x"}}' | bash pre-tool-use.sh # expected: 0
```

The first command should return nothing. The second should **refuse** (non-zero exit), the third
should **allow** (exit 0) — a hook that silently lets everything through produces no error message.

## Sensitive content in a conversation

Wrap any token, temporary password, private URL, or client data appearing in a prompt in
`<private>…</private>` tags. That content is then excluded from cross-session memory.

## Scope

This repository provides no online service and has no supported version in the classic sense. Only
the `main` branch receives fixes.
