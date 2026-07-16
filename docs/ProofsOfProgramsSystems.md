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

## Systems

| System | Core description |
|--------|------------------|
| **Rocq** (formerly Coq) | Interactive proof assistant on the Calculus of Inductive Constructions; small trusted kernel; extracts to OCaml/Haskell. |
| **Lean 4** | Interactive proof assistant and programming language on a CIC variant, with strong metaprogramming. |
| **Agda** | Dependently-typed programming language in which proof is programming (Martin-Löf type theory). |
| **Twelf** | LF logical framework for programming-language metatheory; encodes deductive systems with higher-order abstract syntax and proves metatheorems by totality checking. |
| **Isabelle/HOL** | Interactive proof assistant on classical higher-order logic, with strong automation (Sledgehammer). |
| **Iris** | Higher-order concurrent separation logic mechanized as a Rocq library — a logic, not a standalone tool. |
| **F\*** | Dependently-typed language with refinement types discharged by an SMT solver; extracts to OCaml/C; its Steel and Pulse DSLs add concurrent separation logic. |
| **Verus** | SMT-based deductive verifier for Rust, with specifications embedded in Rust and ownership-based reasoning. |
| **Dafny** | SMT-based auto-active verifier with its own language; weakest-precondition reasoning with dynamic frames. |
| **Why3** | Deductive-verification platform and WhyML intermediate language that dispatches proof obligations to many provers; a backend other tools build on. |

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
| 11 | Incremental | yes / partial / no |
| 12 | Parallel | yes / partial / no |

## The Ten on these Dimensions

| # | Dimension | Rocq | Lean | Agda | Twelf | Isabelle | Iris | F* | Verus | Dafny | Why3 |
|---|-----------|------|------|------|-------|----------|------|----|-------|-------|------|
| 1 | Foundation | DTT | DTT | DTT | DTT | HOL | sep-logic | DTT | FOL | FOL | FOL |
| 2 | Core logic | CIC | CIC* | MLTT | LF | HOL | HO-BI | refine | FOL | FOL | FOL |
| 3 | Proof style | interactive | interactive | interactive | interactive | hybrid | interactive | hybrid | auto | auto | hybrid |
| 4 | Trusted base | kernel | kernel | kernel | kernel | kernel | kernel | +SMT | +SMT | +SMT | +SMT |
| 5 | Program model | embedded | own-lang | own-lang | embedded | embedded | embedded | own-lang | annotates | own-lang | own-lang |
| 6 | Program logic | — | — | — | — | Hoare | conc-sep | conc-sep | separation | Hoare | Hoare |
| 7 | Concurrency | no | no | no | no | no | yes | yes | yes | no | no |
| 8 | Executable output | extract | native | extract | none | extract | none | extract | native | native | extract |
| 9 | Host language | OCaml | Lean/C++ | Haskell | SML | SML | Rocq | F*/OCaml | Rust | C# | OCaml |
| 10 | Good for | both | both | both | PL-sem | both | both | PoP | PoP | PoP | PoP |
| 11 | Incremental | yes | yes | yes | no | yes | yes | yes | partial | partial | yes |
| 12 | Parallel | yes | yes | partial | no | yes | yes | yes | yes | yes | yes |

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
- **F\*** provides concurrent separation logic through two DSLs embedded in it:
  Steel (on the SteelCore concurrent separation logic, ICFP 2020) and its
  successor Pulse (on PulseCore, an impredicative concurrent separation logic).
  Its `conc-sep` and `yes` cells reflect these; F\*'s effectful base additionally
  has Dijkstra-monad weakest-precondition reasoning.
- **Program logic and Concurrency** otherwise describe the base system. Rocq
  reaches concurrent separation logic through the Iris library (its own row);
  Isabelle and Verus have concurrency developments beyond the base value shown.
  Dafny's program logic is weakest-precondition with dynamic frames, discharged
  to Z3 through Boogie.
- **Executable output** — `extract` (Rocq, Agda, Isabelle, F\*, Why3) emits a
  general-purpose language with proofs erased; `native` (Lean, Verus, Dafny)
  compiles programs to run directly; `none` (Twelf, Iris) reasons about programs
  or systems it does not itself produce. The line between the first two is soft.
- **Good for** — `PL-sem` systems are built for language semantics and metatheory;
  `PoP` systems are built to verify that specific programs meet specifications;
  `both` marks general proof assistants used either way.
- **Incremental** records whether a module's checked result is written to a
  persistent artifact and assumed on later runs, so the module is not re-checked
  from scratch — the proof analogue of separate compilation. `yes` for the
  systems that emit a per-module compiled artifact: Rocq writes `.vo` (and the
  proof-erasing `.vos`) objects, which `Require` loads without re-checking; Lean
  writes `.olean`; Agda writes `.agdai` interface files, reloaded rather than
  re-checked when the source hash is unchanged; Isabelle builds persistent
  session heap images (a dumped Poly/ML world) that downstream sessions load
  without re-processing the parent theories; F\* writes `.checked` files that
  cache a module's verification, skipped on the next run when the hash matches;
  Iris inherits Rocq's `.vo`. Why3 is `yes` by a different mechanism: the proof
  session (an XML database) records which prover and which transformations
  discharged each goal, and `why3 replay` reuses that assignment rather than
  redoing proof search — it re-invokes the provers to re-check, so the expensive
  search result is saved and assumed, not the final boolean.
- The two SMT-backed program verifiers are `partial`, correcting a first
  guess of `yes`: they are modular but do not persist per-function results
  across separate command-line runs. **Verus** verifies each function against
  its callees' specifications, not their bodies, and at the crate boundary an
  already-verified crate is exported as a `.vir` file whose functions are
  imported and assumed (as `vstd` is) — that is genuine separate compilation of
  proofs — but within a crate every batch run re-verifies the crate's own
  functions from scratch, with no persistent per-function cache. **Dafny**
  likewise verifies each method modularly against other methods' specifications;
  Boogie's fine-grained caching (Leino and Wüstholz, 2015) reuses results across
  edits within a live IDE or language-server session, keyed by call-graph and
  control-flow checksums, but a fresh `dafny verify` process re-checks from
  scratch.
- **Twelf** is `no`: it re-reads its LF signatures from source and re-runs term
  reconstruction and the totality (mode, coverage, termination) checks on each
  session. It has no compiled-proof build artifact analogous to `.vo` or
  `.olean`, so nothing checked is saved and assumed on a later run; loaded
  signatures persist only in the memory of a running session, which is why this
  cell is weaker than the rest.
- **Parallel** records whether checking, elaboration, or verification runs on
  multiple threads. `yes` for the systems that parallelize across modules or
  within one: Rocq builds files concurrently (`make -j`, dune) and processes
  proofs asynchronously; Lean builds modules in parallel under `lake` and
  elaborates within a file concurrently; Isabelle is the established case of
  parallel proof checking on Poly/ML (parallel across theories and within a
  theory via futures, bounded by Poly/ML's single-threaded garbage collector);
  Iris inherits Rocq's parallel build. The four SMT-backed systems are naturally
  parallel because independent verification conditions are independent solver
  queries: F\* verifies modules concurrently; Verus runs a bucket-based worker
  pool, each worker holding its own Z3 process, sized by `--num-threads`; Dafny
  parallelizes verification-condition solving with `/vcsCores`; Why3's scheduler
  runs prover calls concurrently. **Agda** is `partial` — its `-j` flag gives
  module-granularity parallelism across independent modules, but each module is
  type-checked single-threaded. **Twelf** is `no`: single-threaded SML with no
  parallel checking.
- **Flagship uses**: Rocq — CompCert, VST; Isabelle/HOL — seL4; Twelf — mechanized
  language metatheory (POPLmark); F\* — HACL\*, EverCrypt; Lean — mathlib; Dafny —
  IronFleet; Why3 — SPARK, Frama-C backend.
