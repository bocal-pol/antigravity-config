---
name: ponytail
description: "Minimal code discipline: before writing or modifying code, go down the decision ladder (should this exist? already there? stdlib? native? a present dependency? one line? otherwise minimal), work in verifiable units, and apply measurable quality gates (CRAP < 10, duplication < 0.8, mutation testing) when tooling exists for the language. Use on any code task (write, add, refactor, fix, review, choose a dependency) and when the user says \"ponytail\", \"be lazy\", \"minimal solution\", \"yagni\", \"do less\", or complains about over-engineering, boilerplate, or unnecessary dependencies. Don't use for non-code requests (prose, translation, summary)."
model: claude-sonnet-5
user-invocable: true
argument-hint: "[lite|full|ultra]"
type: utility
priority: high
scope: cross
dependencies: []
conflicts: []
---

# ponytail — Minimal Code Discipline (essence)

A behavioral gate to apply **before writing or modifying code**. The lazy senior developer's philosophy: *the best code is the code you don't write*. Complements `karpathy-guidelines` (general discipline) with a concrete **decision ladder** applied to every piece of code under consideration.

> Essence extracted from the ponytail project — **with no** plugin, hooks, or slash commands. Here it's a discipline skill, invoked by `team-dev`'s dev agents.

## The decision ladder — climb down it before writing

For **every** function, class, file, dependency, or component under consideration, in order — stop at the first "yes":

| # | Question | If yes |
|---|---|---|
| 1 | **Should this exist?** | Don't write it (YAGNI) |
| 2 | **Already in this codebase?** | Reuse the existing one |
| 3 | **Does the stdlib do it?** | Use the standard library |
| 4 | **A native platform feature?** | Use the native option (e.g. `<input type="date">`) |
| 5 | **A dependency already installed?** | Use the existing package |
| 6 | **Does it fit in one line?** | Write one line |
| 7 | **Otherwise** | Write the **minimum** that solves the problem, nothing speculative |

## Golden rule — lazy about solutions, never about reading

Before picking a rung, **trace the code's actual flow**: read the relevant files, understand what's there, search (`Grep`/`Glob`) for an already-present helper/service/util. Laziness is about *what you write*, never about *what you understand*. The smallest diff in the wrong place isn't lazy, it's a second bug.

**Bug fix = root cause, not symptom.** A ticket names a symptom. Before editing, `Grep` **every caller** of the targeted function. The lazy fix *is* the root fix: a guard inside the shared function is a smaller diff than a guard in each caller, and leaves no sibling caller broken. Fix it once, where everyone passes through. (Full methodology: the `debug` skill.)

## Guardrails — never trimmed in the name of minimalism

Minimal code stays **complete and safe**. Never sacrifice:
- Input **validation**
- Explicit **error handling**
- **Security** (auth, authorization, no secret in plaintext)
- **Accessibility** (a11y) on frontend/mobile

Minimal ≠ sloppy: you strip the superfluous, not the guarantees.

## Minimal verification — lazy code with no check isn't done

Any **non-trivial** logic (a branch, a loop, a parser, a money/security path) leaves **ONE** executable check behind it: the smallest thing that fails if the logic breaks — an `assert` in a `demo()`/`__main__`, or a single `test_*`. No framework, no fixtures, no suite per function unless asked. A trivial one-liner doesn't need a test: YAGNI applies to tests too. (Proof of completion: the `unlazy` discipline.)

## `// ponytail:` convention

Reserve the marker for **genuine, deliberate shortcuts**: a conscious simplification with a **known ceiling** (global lock, O(n²) scan, naive heuristic, tolerated duplication). The comment names both the ceiling **and** the upgrade path:

```txt
# ponytail: global lock — switch to a per-account lock if throughput becomes a problem

// ponytail: duplicated logic in 2 callers — extract into a service at the 3rd caller
```

A native or stdlib choice isn't a shortcut, it doesn't get marked. These markers track deliberate debt (findable via a `ponytail:` grep).

## Working in verifiable units

Finish a small unit and verify it before starting the next — never one massive diff validated as a block at the end. A refactoring always follows the same order: **pin** the current behavior (a characterization test or existing tests that pass), **change** the structure, **prove** the behavior hasn't moved (same suite, green before and after). Changing behavior and structure in the same commit makes both unverifiable separately.

## Measurable quality gates (if tooling is available for the language)

Three optional gates, inherited from [`ub-mode`](https://github.com/unclebob/ub-mode) (Robert C.
Martin) and its companion tools
([`crapper`](https://github.com/unclebob/crapper),
[`dryer`](https://github.com/unclebob/dryer),
[`mutator`](https://github.com/unclebob/mutator)). **These tools currently only support
Clojure/Java/Go/TypeScript/Rust/Python** — not PHP/Laravel, .NET/C#, or Dart/Flutter, the majority
of this ecosystem's stack. The gates therefore remain **conditional recommendations**, never a hard
block: on an unsupported stack, document their manual equivalent below rather than silently
ignoring them.

| Gate | Threshold | Tool (if the stack is supported) | Manual equivalent otherwise |
|---|---|---|---|
| **CRAP** (complexity × (1 − coverage)²) | < 10 per function | `crapper` | Eyeball a function that's both complex (many nested branches/loops) and untested; split it or test it, not half of each |
| **Structural duplication** | similarity < 0.8 | `dryer` | Grep the method/block name across the whole monorepo (already an AGENTS.md rule); extract on the 3rd occurrence, mark `// ponytail:` below 3 |
| **Mutation testing** | kill the mutants, cover the uncovered, remove dead code | `mutator` | Manual review: for each branch not covered by a test, ask whether a realistic input reaches it — if yes, a test is missing; if no, flag it as dead code |

Never run `crapper`/`dryer`/`mutator` without first checking they're present (`which crapper` or
equivalent) — no install = go straight to the manual equivalent, with no blocking warning.

## Deep modules — minimize the interface, not just the lines

Minimalism isn't just about **line count** but about **interface surface**. A good module is **deep**: a lot of behavior encapsulated behind a **minimal interface**, at a **clean seam**.

- Prefer **one function/class that does a lot behind few parameters** over ten shallow helpers that leak their details.
- Place abstractions at the flow's **natural seams** (where responsibility changes), not at random.
- A "shallow" module (interface as wide as its implementation) adds nothing: it's cost with no encapsulation → reject it (ladder rung 1).
- Expose the **strict minimum**; keep everything that can be private, private.

> Essence of `codebase-design` (Matt Pocock): *deep modules, minimal interfaces, clean seams.*

## Intensity (posture, no plugin)

Adjustable via the argument, **default: `full`**.

| Mode | Posture |
|---|---|
| `lite` | Reminds of the ladder without enforcing it — only flags blatant over-engineering |
| `full` | **Default** — systematically applies the ladder before writing, refuses the speculative |
| `ultra` | Maximal — questions everything, pushes native/one-liner to the max, challenges every abstraction |

## Application within `team-dev`

Invoked at **Phase 0d** (alongside `karpathy-guidelines`) before code-generating modes (`--backend`, `--frontend`, `--mobile`, `--build`, `--update`, `--pr-review`), and referenced by the dev agents (`backend-agent`, `frontend-agent`, `mobile-agent`). Division of roles:
- `karpathy-guidelines` = general discipline (think first, surgical changes, success criteria).
- `ponytail` = the **concrete "climb down the ladder before writing" gate**.

## Fallback

If the skill is unavailable, apply the decision ladder + the golden rule + the guardrails from memory.

## Skip memory

No persistence. This is a discipline gate, not an artifact producer.
