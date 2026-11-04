# Hindsight — journal of lessons learned

> Loaded at every session via `@hindsight.md` in `AGENTS.md`.
> One entry = one concrete lesson drawn from a real situation, so the mistake is not repeated.
>
> **Purge rule**: a lesson promoted to a rule in `AGENTS.md` is **removed from here**. Otherwise it
> is loaded twice at every session for a single piece of information.

## Entry format

```markdown
### YYYY-MM-DD — Short title of the lesson
- **Context**: what was happening, the situation encountered.
- **Lesson**: what to remember / do differently next time.
```

## Entries

### 2026-09-17 — A committed fix is not a deployed fix

- **Context**: a morning audit marked a batch of fixes "done" across several files. A fingerprint
  check in the afternoon showed the target environment was not a git checkout at all, and half the
  "fixed" files had never arrived there. The running environment still contained stale flags and an
  old agent name. Same mechanism as a prior resurrection of compatibility aliases months earlier.
- **Lesson**: proof of deployment is the target environment's commit hash matching the pushed
  commit, never "files copied." And an audit report only says "fixed" after verifying **on the
  actual machine**, not in the repository.

### 2026-09-16 — A failure after a change is not a regression until replayed on the original code

- **Context**: migrating an error contract across ten backends. Every red test suite after the
  change tempted the conclusion "regression." Replaying the same case on the pre-change file showed
  four failures out of five were pre-existing: broken test mocks, an unreachable cache service, a
  trait used as a class, a missing factory. Only one was actually caused by the change.
- **Lesson**: before announcing or "fixing" a regression, replay the case on the original code —
  two minutes, and it avoids blaming your own work or modifying healthy code. Corollary: a container
  often serves a version older than the repository on disk; compare checksums container/disk
  **before** diagnosing, or you debug a ghost.

### 2026-09-16 — A test that pins a string does not pin a behavior

- **Context**: a test verified the presence of an exception class name as a literal **string** in a
  bootstrap file's text. It would have stayed green if the class were only in a comment, and it
  turned red when the exception rendering moved to a shared package — while the actual behavior was
  intact. Same pattern elsewhere: two tests pinned the exact wording of an error message that the
  contract explicitly declared non-contractual.
- **Lesson**: a test must exercise the behavior (raise the exception, read the response), never the
  implementation (grep a file, exact wording of a label, code location). Pin the machine-readable
  slug and the shape, not the words.

### 2026-09-16 — A brand icon is not an interface icon

- **Context**: applying an "icon library only" rule, a brand logo SVG was replaced with a generic
  icon. It was the application's logo, derived from a master asset and duplicated across four
  surfaces (backend SVG, frontend component, favicon, branding page) — the project's own config said
  so explicitly.
- **Lesson**: an icon-library rule targets interface icons (actions, statuses, navigation), not
  visual identity. Before replacing an SVG, check whether it is referenced as a brand element or
  duplicated across several surfaces: that is the sign of a logo, and changing it is a product
  decision, not a compliance fix.

### 2026-09-16 — Never a mass-index-reset command inside a cleanup loop

- **Context**: at the end of a history-cleanup operation, removing temporary refs, an unrelated
  "reset index" command was added to the same loop across ten repositories — wiping each repo's
  staged index (up to ~1300 staged deletions on one repo). Repaired because nothing had been
  committed or pushed: files were intact on disk.
- **Lesson**: a cleanup loop contains only commands whose scope exactly matches what was announced.
  Removing refs and touching the index are different operations — never mix them. Before any
  mass command across N repositories, test it on a single one and check status before propagating.
  Corollary: reversibility depended entirely on nothing being committed — check status immediately
  after any mass command, not at the end.

### 2026-09-09 — `cap_drop: [ALL]` makes a binary with file capabilities unrunnable

- **Context**: hardening containerized services (non-root user, `cap_drop: [ALL]`). A CLI binary in
  one image carried a network-bind file capability (for binding to a low port): under
  `cap_drop ALL`, the binary failed with "operation not permitted" even as root, and dependent
  workers looped on restart. Corollary: root without capabilities can no longer `chown`/`chmod`
  files copied into the container from outside.
- **Lesson**: before setting `cap_drop: [ALL]`, check binaries for file capabilities; strip the
  capability in the image or grant only that one. Any admin operation on a non-root container's
  volume goes through a disposable container, never an ad hoc root exec.

### 2026-09-09 — A 419/CSRF error from curl is not proof of a CSRF/logout vulnerability

- **Context**: a subagent classified an SPA logout endpoint "Critical" (POST without a CSRF header,
  a cookie forced httpOnly). curl reproduced a 419 error and a surviving session. In a real
  same-origin browser, the same call succeeded and revoked the session: the framework's CSRF
  middleware accepts a same-origin Fetch Metadata header without a token.
- **Lesson**: for any CSRF/session finding on a modern framework, replay in a **real browser** (or
  add the relevant Fetch Metadata header) before classifying; a curl request without those headers
  produces a false positive. Symmetrically, verify the tested container actually serves the current
  branch — otherwise you audit a ghost.

### 2026-09-09 — A control declared in an ADR is not a control

- **Context**: an internal project's audit found a documented threat model and over twenty ADRs
  describing CSP, timeouts, anti-CSRF state, an access-control contract, and a secrets vault "with
  no silent fallback." None of these five controls existed in the actual code; a suspended admin
  account kept access to the admin panel.
- **Lesson**: in an audit or a delivery review, start from the list of **declared** controls (ADRs,
  architecture docs, integration contracts) and demand an executable proof for each (code grep +
  a dynamic command). An ADR with no test pinning it is a hypothesis, not a protection.

### 2026-09-18 — Rewriting history requires freezing the remote

- **Context**: rewriting history on two remotes (filter-branch, 26 branches). During the local
  passes, several PRs were merged on GitHub. Each merge **reintroduced the old, unrewritten
  history** on the integration and release branches: after a validated "clean" pass, the markers
  were back on the remote. A subsequent force-push overwrote those merges — content happened to be
  identical, verified by diffing, but nothing guaranteed that in advance.
- **Lesson**: a history rewrite is an **exclusive operation**. Before starting: announce the freeze,
  and stop merging or pushing to the remote until the end. After every fetch, re-verify the remote
  tips are the ones just rewritten. And before any force-push showing an unknown remote SHA, **stop**
  — an unfamiliar remote SHA means someone has pushed.

### 2026-09-18 — A word-boundary regex does not protect after an underscore, and `--all` includes original refs

- **Context**: same operation. Two verification false negatives chained together. First, a log
  search across "all" refs declared every marker intact after a successful pass: an "all refs" flag
  **includes the old backup refs** that a history rewrite deliberately keeps as a safety net. Then a
  word-boundary pattern failed to match inside a filename using underscores: an underscore **is** a
  word character, so a word boundary does not apply between it and the following letter. A third
  gap: a file filter only covered known extensions, missing extensionless files that also needed
  purging.
- **Lesson**: verify rewritten history on branches and tags explicitly, never on "all" refs. For a
  distinctive token, replace **without** word boundaries rather than with them. And make any file
  filter cover extensionless files too, not only files with a known extension.

### 2026-09-17 — A dry run on a mass-replacement script is not a formality

- **Context**: anonymizing ~870 occurrences across 8 skills. The script stored its replacement pairs
  in a nested array structure that the scripting language silently flattened: each pair was read
  character by character, and the simulation announced ~72,830 replacements instead of 870. Applied
  without simulation, it would have destroyed six skills.
- **Lesson**: any mass-replacement script has a dry-run mode **on by default**, which prints the
  count per pattern and per file; only switch to apply mode after reading those numbers and finding
  them plausible.

### 2026-09-17 — Separating private from shared is decided on identification, not on topic

- **Context**: preparing to open a repository for sharing. A first pass moved several persona agents
  and skills to a private repository because their subjects seemed personal. On review, that was too
  broad: knowing how to do something is a skill, not private data. What actually mattered was that a
  few personas carried the first name of real people.
- **Lesson**: before moving a file out of a repository being opened up, ask the right question —
  **"does this file identify someone?"**, not "is the topic private?" A persona is named after its
  function. Applied literally, the criterion kept almost everything shared.

### 2026-06-23 — Map cross-references before a mass rename

- **Context**: renaming a whole set of agents to new code names. The first script only touched the
  agents directory plus a couple of top-level files, missing dozens of skills that referenced the
  old names in their own "optional input / persistence" sections.
- **Lesson**: before a rename refactor, grep the **entire** repository to map every reference
  (skills, registries, README, hooks). After applying the change, re-grep to prove no stale token
  remains. Corollary verified later: a mechanical grep is not enough — after renaming three agents,
  over a dozen **prose** mentions still lingered in examples and delegation tables.

### 2026-10-02 — A guard-rail that greps raw JSON blocks itself

- **Context**: exploring a third-party project for transposable mechanisms. A pre-tool-use hook
  grepped the entire raw JSON payload received on stdin to detect a push to a protected branch. A
  simple commit message that merely *talked about* the forbidden pattern (in quotes) triggered the
  block — demonstrated live in the same session, where the hook blocked its own test command because
  it contained the literal string in quotes.
- **Lesson**: a guard-rail grep must operate on the extracted command field, with quoted content
  stripped out before searching for dangerous flags — otherwise any commit message that *mentions*
  the forbidden pattern gets blocked by that very pattern. Corollary: verify that a rule described in
  a hook's own comments actually matches what is implemented, not just what is commented as intent.
