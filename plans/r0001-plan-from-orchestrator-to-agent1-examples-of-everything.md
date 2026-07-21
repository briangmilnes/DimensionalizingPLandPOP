---
round: r0001
from: orchestrator
to: agent1
subject: examples-of-everything
date: 2026-0721-16:24
status: active
related: reports/r0001-report-from-agent1-to-orchestrator-examples-of-everything.md
---

# Plan: docs/ExamplesOfEverything.md

## Goal

Produce `docs/ExamplesOfEverything.md`: the same sectioned, table-per-section
structure as `docs/CostOfProvingEverything.md`, but each row expanded from a bare
item into an example table. For every item give, in columns:

1. the item (the category name, as the first column header)
2. **LOC estimate** — a rough order-of-magnitude size for a real instance (if you can),
3. **Best proven example** — the best *formally verified* instance, or `none` if there is none,
4. **Best unproven example** — the best production / unverified instance.

"With a tables line" = each table has a header row naming those columns.

## Source of the row set

Read `docs/CostOfProvingEverything.md` FIRST and mirror its sections and rows
**exactly as they currently stand** (the user is editing that file). At the time of
writing it has these sections: 1 Semantics, 2 PL, 3 Std Library, 4 OS, (4) Utilities,
5 Application Stack, 6 Distributed Services, 7 Proof of Programs (POP). Use whatever
is actually in the file when you run — do not hard-code this list. Keep its numbered
`## N. Name` section headings and the leading 95%-width `<style>` block.

## How to fill the columns

- **Proven examples and their LOC** are already measured in this repo — reuse them and
  cite the doc: `PLSizes.md`, `SMTSizes.md`, `ProofsOfProgrammingLanguagesSizes.md`,
  `SMTCheckVerificationAndTCBandVCB.md`, `ProofsOfProgramsSystems.md`,
  `ProofsOfProgrammingLanguages.md`. Examples: compiler → CompCert (206,904);
  Certificate Checker → SMTCoq (15,133); OS kernel → seL4 (l4v 803,647); crypto/Std
  Library → HACL\*/CakeML basis; Proof Assistant → Rocq/Lean/Isabelle/HOL4.
- **Unproven examples and their LOC** — use the best-known production instance
  (compiler → GCC/LLVM; OS kernel → Linux; in-memory DB → Redis; on-disk DB →
  PostgreSQL/SQLite; HTTP server → nginx; DNS → BIND; git → git). Use WebSearch/WebFetch
  or repo stats for rough LOC; order-of-magnitude is fine, mark with `~`.
- Where an item has **no** formally verified instance (much of Distributed Services,
  Utilities, Application Stack, hardware-ish rows), put `none` in the proven column —
  honestly, do not invent one.
- LOC is an estimate: use `~`, ranges, or `—` when you cannot source it. No false precision.

## Style / rules

- ComputAItionalThinking: precise CS terms, no metaphors, honest about estimates.
- Keep the `docs/` house style (95% `<style>` block, numbered `## N.` sections).
- Do NOT edit `README.md` (the orchestrator adds the index entry) and do NOT `git commit`.
- Do NOT stage or touch anything under `sources/` (gitignored clones).

## Deliverables

1. `docs/ExamplesOfEverything.md`.
2. A GRASE report at
   `reports/r0001-report-from-agent1-to-orchestrator-examples-of-everything.md` with
   YAML frontmatter (`round: r0001`, `from: agent1`, `to: orchestrator`,
   `subject: examples-of-everything`, `date`, `started`, `finished`,
   `related: plans/r0001-plan-from-orchestrator-to-agent1-examples-of-everything.md`)
   summarizing: the row set used, which proven examples came from which repo doc, which
   unproven LOC figures you sourced (with URLs), and every cell you left `none` / `—`
   and why. Timestamps in project-tz `America/Los_Angeles`, minute resolution
   `YYYY-MMDD-HH:MM`.
