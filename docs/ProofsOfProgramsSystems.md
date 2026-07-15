<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Proofs of Programs Systems

Systems for mechanically proving properties of programs — proof assistants,
program logics, logical frameworks, and deductive verifiers. This is a distinct
subject from the programming languages dimensionalized in `ThirteenPLs.md`: here
the object is the verification system, not the language being verified. First cut
over ten systems: Rocq (formerly Coq), Lean 4, Agda, Twelf, Isabelle/HOL, Iris,
F\*, Verus, Dafny, and Why3.

The **Foundation** dimension names the broad logical family; the **Core logic**
dimension names the specific calculus the system is built on (for example Rocq's
Calculus of Inductive Constructions). The **Good for** dimension records the
split the systems fall into: some are built for reasoning about
programming-language semantics and metatheory, some for proving specific programs
meet their specifications, and the general proof assistants do both.

Two members are not peers of the rest, recorded in the grid and explained in the
notes: Iris is a logic mechanized as a library inside Rocq, and Why3 is a
verification backend other tools build on.

Abbreviations used in the grid: DTT = dependent type theory, HOL = higher-order
logic, FOL = first-order logic, sep-logic = separation logic, CIC = Calculus of
Inductive Constructions, CIC\* = Lean's CIC variant (proof-irrelevant `Prop`,
quotients), MLTT = Martin-Löf type theory, LF = Edinburgh Logical Framework
(λΠ), HO-BI = higher-order bunched-implications / step-indexed separation logic,
refine = refinement types (Dijkstra monads), conc-sep = concurrent separation
logic, kernel = small trusted proof kernel, +SMT = trusts an SMT solver,
own-lang = the system is its own programming language, annotates = adds
specifications to an external language, extract = emits a general-purpose
language with proofs erased, PL-sem = programming-language semantics and
metatheory, PoP = proofs of programs.

## Dimensions

| # | Dimension | Values |
|---|-----------|--------|
| 1 | Foundation | DTT / HOL / FOL / sep-logic |
| 2 | Core logic | CIC / CIC* / MLTT / LF / HOL / FOL / HO-BI / refine |
| 3 | Proof style | interactive / hybrid / auto |
| 4 | Trusted base | kernel / +SMT |
| 5 | Program model | embedded / own-lang / annotates |
| 6 | Program logic | — / Hoare / separation / conc-sep / refinement |
| 7 | Concurrency | yes / no |
| 8 | Executable output | extract / native / none |
| 9 | Host language | OCaml / Haskell / SML / Rust / C# / Lean / F* |
| 10 | Good for | PL-sem / PoP / both |

## The Ten on these Dimensions

| # | Dimension | Rocq | Lean | Agda | Twelf | Isabelle | Iris | F* | Verus | Dafny | Why3 |
|---|-----------|------|------|------|-------|----------|------|----|-------|-------|------|
| 1 | Foundation | DTT | DTT | DTT | DTT | HOL | sep-logic | DTT | FOL | FOL | FOL |
| 2 | Core logic | CIC | CIC* | MLTT | LF | HOL | HO-BI | refine | FOL | FOL | FOL |
| 3 | Proof style | interactive | interactive | interactive | interactive | hybrid | interactive | hybrid | auto | auto | hybrid |
| 4 | Trusted base | kernel | kernel | kernel | kernel | kernel | kernel | +SMT | +SMT | +SMT | +SMT |
| 5 | Program model | embedded | own-lang | own-lang | embedded | embedded | embedded | own-lang | annotates | own-lang | own-lang |
| 6 | Program logic | — | — | — | — | Hoare | conc-sep | Hoare | separation | Hoare | Hoare |
| 7 | Concurrency | no | no | no | no | no | yes | no | yes | no | no |
| 8 | Executable output | extract | native | extract | none | extract | none | extract | native | native | extract |
| 9 | Host language | OCaml | Lean/C++ | Haskell | SML | SML | Rocq | F*/OCaml | Rust | C# | OCaml |
| 10 | Good for | both | both | both | PL-sem | both | both | PoP | PoP | PoP | PoP |

## Notes

This is an early cut; several cells report the base system, not its extensions.

- **Core logic** names the specific calculus. Rocq is the Calculus of Inductive
  Constructions; Lean 4 uses a CIC variant (`CIC*`) with a proof-irrelevant
  impredicative `Prop` and quotient types; Agda is intensional Martin-Löf type
  theory; Twelf is the Edinburgh Logical Framework (LF, the λΠ type theory);
  Isabelle/HOL is classical higher-order logic (Church's simple type theory);
  Iris is a higher-order, step-indexed separation (bunched-implications) logic;
  F\*'s core is refinement types with Dijkstra monads; Verus, Dafny, and Why3
  encode into classical first-order logic discharged by an SMT solver.
- **Twelf** is a logical framework: object languages and their semantics are
  encoded as LF signatures using higher-order abstract syntax, and metatheorems
  (type safety, determinacy) are logic-programming relations proved total by
  Twelf's mode, coverage, and termination checkers. It is aimed at
  programming-language metatheory (the POPLmark challenge), not at verifying
  application programs, which is why its Good-for cell is `PL-sem`. Implemented
  in SML.
- **Iris** is a higher-order concurrent separation logic mechanized as a Rocq
  library, not a standalone tool. Its foundation and trusted base are Rocq's. It
  serves both PoP and PL-sem (semantic type soundness, e.g. RustBelt).
- **Why3** is a deductive-verification platform and intermediate language
  (WhyML) that discharges verification conditions to external SMT and ATP
  provers. SPARK, Frama-C, and Creusot use it as a backend.
- **Program logic and Concurrency** rows describe the base system. Rocq and F\*
  reach concurrent separation logic through extensions (Iris for Rocq;
  Steel/Pulse for F\*); Isabelle and Verus have concurrency developments beyond
  the base value shown. F\*'s `Hoare` cell is its Dijkstra-monad
  weakest-precondition reasoning; Dafny's is weakest-precondition with dynamic
  frames, discharged to Z3 through Boogie.
- **Executable output** — `extract` (Rocq, Agda, Isabelle, F\*, Why3) emits a
  general-purpose language with proofs erased; `native` (Lean, Verus, Dafny)
  compiles programs to run directly; `none` (Twelf, Iris) reasons about programs
  or systems it does not itself produce. The line between the first two is soft.
- **Good for** — `PL-sem` systems are built for language semantics and metatheory;
  `PoP` systems are built to verify that specific programs meet specifications;
  `both` marks general proof assistants used either way.
- **Flagship uses**: Rocq — CompCert, VST; Isabelle/HOL — seL4; Twelf — mechanized
  language metatheory (POPLmark); F\* — HACL\*, EverCrypt; Lean — mathlib; Dafny —
  IronFleet; Why3 — SPARK, Frama-C backend.
