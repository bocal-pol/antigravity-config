---
name: ponytail
description: "Minimal code discipline: before writing or changing code, walk down the decision ladder (should this exist? already there? stdlib? native? dependency already present? one line? otherwise minimum), work in verifiable units, and apply measurable quality gates (CRAP < 10, duplication < 0.8, mutation testing) when tooling exists for the language. Use on any code task (write, add, refactor, fix, review, choose a dependency) and when the user says 'ponytail', 'be lazy', 'minimal solution', 'yagni', 'do less', or complains about over-engineering, boilerplate, or unnecessary dependencies. Do not use for non-code requests (prose, translation, summary)."
model: claude-sonnet-5
user-invocable: true
argument-hint: "[lite|full|ultra]"
type: utility
priority: high
scope: cross
dependencies: []
conflicts: []
---

# ponytail — Minimal code discipline (essence)

A behavioral gate to apply **before writing or changing code**. The lazy senior developer's philosophy: *the best code is the code you don't write*. Complements `karpathy-guidelines` (general discipline) with a concrete **decision ladder** applied to every piece of code under consideration.

> Essence extracted from the ponytail project — **without** the plugin, hooks, or slash commands. Here it's a discipline skill, invoked by the dev agents of `team-dev`.

## The decision ladder — walk it down before writing

For **each** function, class, file, dependency, or component under consideration, in order — stop at the first "yes":

| # | Question | If yes |
|---|---|---|
| 1 | **Should this exist?** | Don't write it (YAGNI) |
| 2 | **Already in this codebase?** | Reuse what's there |
| 3 | **Does the stdlib do it?** | Use the standard library |
| 4 | **A native platform feature?** | Use the native one (e.g. `<input type="date">`) |
| 5 | **An already-installed dependency?** | Use the present package |
| 6 | **Does it fit in one line?** | Write one line |
| 7 | **Otherwise** | Write the **minimum** that solves the problem, nothing speculative |

## Golden rule — lazy on solutions, never on reading

Before choosing a rung, **trace the real code flow**: read the relevant files, understand what exists, search (`Grep`/`Glob`) for an already-present helper/service/util. Laziness applies to *what you write*, never to *what you understand*. The smallest diff in the wrong place isn't lazy, it's a second bug.

**Bug fix = root cause, not symptom.** A ticket names a symptom. Before editing, `Grep` **all callers** of the targeted function. The lazy fix *is* the root fix: a guard in the shared function is a smaller diff than a guard in every caller, and leaves no sibling caller broken. Fix it once, where everyone passes through. (Full methodology: the `debug` skill.)

## Guardrails — never trimmed in the name of minimalism

Minimal code stays **complete and safe**. Never sacrifice:
- Input **validation**
- Explicit **error handling**
- **Security** (auth, authorization, no secrets in plaintext)
- **Accessibility** (a11y) on frontend/mobile

Minimal ≠ sloppy: you remove the superfluous, not the guarantees.

## Minimal verification — lazy code without its check isn't finished

Any **non-trivial** logic (a branch, a loop, a parser, a money/security path) leaves **ONE** executable check behind it: the smallest thing that fails if the logic breaks — an `assert` in a `demo()`/`__main__`, or a single `test_*`. No framework, no fixtures, no suite per function unless requested. A trivial one-liner doesn't need a test: YAGNI applies to tests too. (Proof of completion: the `unlazy` discipline.)

## `// ponytail:` convention

Reserve the marker for **real, deliberate shortcuts**: a conscious simplification with a **known ceiling** (global lock, O(n²) scan, naive heuristic, tolerated duplication). The comment names the ceiling **and** the upgrade path:

```txt
# ponytail: global lock — move to a per-account lock if throughput becomes an issue

// ponytail: logic duplicated in 2 callers — extract into a service at the 3rd caller
```

A native or stdlib choice isn't a shortcut, it isn't marked. These markers trace accepted debt (findable via a `ponytail:` grep).

## Working in verifiable units

Finish a small unit and verify it before starting another — never validate one giant diff all at once at the end. A refactor always follows the same order: **pin** the current behavior (characterization test or existing passing tests), **change** the structure, **prove** the behavior hasn't moved (same suite, green before and after). Changing behavior and structure in the same commit makes both unverifiable separately.

## Measurable quality gates (if tooling is available for the language)

Three optional gates, inherited from [`ub-mode`](https://github.com/unclebob/ub-mode) (Robert C.
Martin) and its companion tools
([`crapper`](https://github.com/unclebob/crapper),
[`dryer`](https://github.com/unclebob/dryer),
[`mutator`](https://github.com/unclebob/mutator)). **These tools currently only support
Clojure/Java/Go/TypeScript/Rust/Python** — not PHP/Laravel, not .NET/C#, not Dart/Flutter, the
majority of a typical stack this repo covers. The gates therefore remain **conditional
recommendations**, never a blocker: on an unsupported stack, document their manual equivalent below
rather than silently ignoring them.

| Gate | Threshold | Tool (if stack supported) | Manual equivalent otherwise |
|---|---|---|---|
| **CRAP** (complexity × (1 − coverage)²) | < 10 per function | `crapper` | Spot by eye a function that is both complex (many nested branches/loops) and untested; split it or test it, not both halves |
| **Structural duplication** | similarity < 0.8 | `dryer` | Grep the method/block name across the whole monorepo (already a project rule); extract at the 3rd occurrence, mark `// ponytail:` below 3 |
| **Mutation testing** | kill mutants, cover the uncovered, remove dead code | `mutator` | Manual review: for each branch not covered by a test, ask whether a realistic input reaches it — if yes, missing test; if no, flag as dead code |

Never run `crapper`/`dryer`/`mutator` without first checking their presence (`which crapper` or
equivalent) — not installed = go straight to the manual equivalent, without a blocking warning.

## Deep modules — minimize the interface, not just the line count

Minimalism isn't only about **line count** but about **interface surface**. A good module is **deep**: a lot of behavior encapsulated behind a **minimal interface**, at a **clean seam**.

- Prefer **one function/class that does a lot behind few parameters** to ten shallow helpers that leak their details.
- Place abstractions at the **natural seams** of the flow (where the code's responsibility changes), not arbitrarily.
- A "shallow" module (interface as wide as its implementation) adds nothing: it's cost without encapsulation → reject it (rung 1 of the ladder).
- Expose the **strict minimum**; keep everything that can be private, private.

> Essence of `codebase-design` (Matt Pocock): *deep modules, minimal interfaces, clean seams.*

## Intensity (a stance, not a plugin)

Adjustable via the argument, **default: `full`**.

| Mode | Stance |
|---|---|
| `lite` | Reminds of the ladder without enforcing it — flags only flagrant over-engineering |
| `full` | **Default** — applies the ladder systematically before writing, rejects speculative code |
| `ultra` | Maximal — questions everything, pushes native/one-liner to the max, challenges every abstraction |

## Application within `team-dev`

Invoked at **Phase 0d** (alongside `karpathy-guidelines`) before code-generating modes (`--backend`, `--frontend`, `--mobile`, `--build`, `--update`, `--pr-review`), and referenced by the dev agents (`backend-agent`, `frontend-agent`, `mobile-agent`). Division of roles:
- `karpathy-guidelines` = general discipline (think before, surgical changes, success criteria).
- `ponytail` = the **concrete "walk the ladder before writing" gate**.

## Fallback

If the skill is unavailable, apply the decision ladder + golden rule + guardrails from memory.

## Skip memorization

No persistence. This is a discipline gate, not an artifact producer.
