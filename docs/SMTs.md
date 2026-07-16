<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# SMT Solvers

Satisfiability-modulo-theories solvers decide the satisfiability of quantifier-free
(and, with instantiation, quantified) first-order formulas over background theories
such as fixed-size bit-vectors, arrays, linear and nonlinear arithmetic, and
uninterpreted functions. This document records seven general-purpose solvers on five
attributes: the language the solver itself is written in, whether its core reasoning
engine is formally verified, whether it emits a checkable proof certificate, whether a
formally verified checker exists for that certificate, and a coarse ordinal
`SMT-COMP standing` derived from recent SMT-COMP division results (2023–2025). A second
section lists theory-specialized solvers that target a single theory — nonlinear
arithmetic, bit-vectors, floating-point, strings — rather than competing across the
full range of divisions.

There is no fair single-number measure of SMT solver speed. SMT-COMP reports
per-division standings, not an overall ranking, and performance is theory- and
timeout-dependent: a solver that leads one division can place mid-pack or lower in
another. The `SMT-COMP standing` column is therefore a coarse summary of breadth of
recent division wins and podiums, and the real signal — which theories each solver
leads — is recorded per solver in the Notes.

The single most important observation is the `Kernel verified` column. No production
SMT solver listed here has a formally verified kernel: every entry reads `no`.
Production SMT solvers are large, heavily optimized C, C++, OCaml, and Java programs;
verifying the kernel of one is not how the field establishes trust. Trust instead
comes from the last two columns: an unverified solver emits a proof certificate that a
*separate* proof checker validates independently, and that checker can itself be
formally verified. The solver may be wrong; the checker's acceptance is what is
trusted. In the literature this checker is a **proof checker** or **certificate
checker** — the checking half of a *certifying algorithm* (Blum & Kannan; McConnell et
al.), where an algorithm emits a witness/certificate that a small checker validates.
This is why certificate production and its verified checking, not kernel verification,
are the axes along which these systems actually differ.

The `Certificate` column distinguishes three levels. `yes` means the solver emits a
fine-grained proof object that an external checker can validate (the format is named
per solver in the Notes). `partial` means the solver produces only a coarse artifact —
an unsatisfiable core (the subset of assertions responsible for unsatisfiability) or
an engine-specific trace — that is not a full, independently checkable refutation.
`no` means no certificate is emitted.

The `Verified checker` column records whether a *formally verified* proof checker
exists for the solver's certificate — a checker whose own correctness is
machine-checked, so accepting a certificate carries a proof-level guarantee. It reads
`yes` only for the solvers whose proofs SMTCoq reconstructs and validates inside Rocq
(Z3, cvc5, veriT); the other formats have only unverified checkers, or no full
certificate to check.

## The Seven General-Purpose Solvers

| Solver | Implementation language | Kernel verified | Certificate | Verified checker | SMT-COMP standing |
|--------|-------------------------|-----------------|-------------|------------------|-------------------|
| Z3 | C++ | no | yes | yes | broad-leader |
| cvc5 | C++ | no | yes | yes | broad-leader |
| Yices2 | C | no | partial | no | division-leader |
| MathSAT5 | C++ | no | yes | no | mid-pack |
| veriT | C | no | yes | yes | niche |
| Alt-Ergo | OCaml | no | partial | no | niche |
| OpenSMT | C++ | no | yes | no | division-leader |

## Notes

On the `SMT-COMP standing` column: the tier is a coarse ordinal summary of how widely
a solver won or reached the podium across SMT-COMP 2023–2025 single-query divisions,
not a universal speed number. The vocabulary has four levels. `broad-leader` marks a
solver that wins divisions across many distinct theories; `division-leader` marks a
solver that leads one or a few specific divisions; `mid-pack` marks a competitive
participant that recently won no division; `niche` marks a solver aimed at a specific
use that is not a recent front-runner in the open competition. Every value traces to
observed division results, and each solver's specific strengths are:

- **Z3** and **cvc5** are the broad front-runners. cvc5 won the most single-query
  divisions in both 2024 and 2025, spanning quantified and quantifier-free arithmetic,
  bit-vectors, equality, and datatypes; Z3 (and its tuned variants Z3-alpha and
  Z3-Noodler) led the arithmetic, nonlinear-arithmetic, and string divisions. These
  two cover the widest range of theories.
- **Yices2** is fast on quantifier-free fragments: it led `QF_Equality`,
  `QF_Equality_NonLinearArith`, and `QF_LinearRealArith`, consistent with its
  reputation for speed on quantifier-free linear-arithmetic and bit-vector problems.
- **OpenSMT** leads the quantifier-free linear-arithmetic divisions
  (`QF_LinearIntArith`, `QF_LinearRealArith`).
- **MathSAT5** is a mature, competitive solver — strong in incremental solving and
  interpolation — but won no single-query division in 2024–2025, hence `mid-pack`.
- **veriT** and **Alt-Ergo** are `niche`: veriT is primarily a proof-producing solver,
  and Alt-Ergo targets the Why3/SPARK/Frama-C toolchains. Neither is a recent SMT-COMP
  division front-runner.
- The bit-vector/floating-point leader **Bitwuzla** and the interpolation
  division-leader **SMTInterpol** are theory-specialized and are listed in the
  specialized-solvers section below, not here.

The caveat bears repeating: SMT-COMP standings and solving speed are division- and
benchmark-dependent. A solver that leads one theory can be weak in another, and the
per-division winners shift year to year, so treat the tier as a summary of breadth of
recent competitive results, not a portable speed measurement.

The proof-checker landscape is what makes an unverified solver's answer trustworthy.
The pattern is: solver emits certificate → independent checker validates it. The
principal checkers and formats:

- **Alethe** is a generic SMT proof format based on SMT-LIB syntax, with coarse- and
  fine-grained steps. It was first implemented in veriT and is now also emitted by
  cvc5. **Carcara** is a standalone Alethe proof checker and elaborator written in
  Rust. **SMTCoq** reconstructs Alethe (and other) proofs inside the Rocq (formerly
  Coq) proof assistant; its checker is extracted from a Rocq-certified program, so
  acceptance carries a machine-checked guarantee. Isabelle/HOL likewise reconstructs
  Alethe proofs.
- **LFSC** (Logical Framework with Side Conditions), an Edinburgh-LF-based framework,
  was CVC4's proof language and is still one of cvc5's output formats; proofs are
  checked by an LFSC signature-driven checker.
- **DRAT / DRUP** are the standard clausal-refutation formats for the propositional
  SAT core. Bit-vector solvers bit-blast to SAT, so their SAT-level reasoning can be
  certified with a DRAT proof from the SAT back end (as in the DRAT-based bit-vector
  proofs first demonstrated in CVC4). DRAT checkers, and the verified GRAT/LRAT
  toolchains, discharge this layer.
- **SMTCoq** checks proofs from Z3, cvc5, and veriT by reconstruction inside Rocq —
  these are exactly the three solvers whose `Verified checker` cell reads `yes`. The
  per-solver certificate formats named above (Alethe, LFSC, own resolution formats,
  etc.) are what each `Certificate` cell refers to.

Per-solver details:

- **Z3** has supported proof terms since 2008, using a large set of low-level
  inference rules; these historically coarse proofs have been used to replay tactics
  in Isabelle and to generate interpolants. A newer proof-log format targets the
  SAT/EUF core (`sat.euf`) and is designed for efficient checking by built-in
  validators.
- **cvc5** has the strongest proof-production story here: an internal proof
  representation post-processed into Alethe, LFSC, or Lean 4 syntax, with DRAT
  certifying the bit-vector/SAT layer.
- **Yices2** produces unsatisfiable cores and, for its DPLL(T) engine, unsat proofs
  (recent work); its alternative mcSAT engine has no known proof-logging technique,
  so the overall status is `partial`.
- **MathSAT5** (reimplemented in C++) generates proofs, unsat cores, and Craig
  interpolants, tightly integrated with incremental solving; the proof object is in
  its own format rather than a shared standard.
- **veriT** is the origin of the Alethe format and emits Alethe proofs consumed by
  Isabelle/HOL and SMTCoq.
- **Alt-Ergo** (OCaml) is the automatic prover behind Why3, SPARK, Frama-C, and
  Atelier-B. Its proof output is limited: the historical `-proof` option now reports
  the named assertions used (an unsat-core-style artifact), not a fine-grained
  checkable proof — hence `partial`.
- **OpenSMT** (C++, USI) produces resolution proofs used to drive its interpolation
  engine (linear real arithmetic, uninterpreted functions, and others); the proof is
  its own format rather than a shared standard.

On verified kernels: the closest points to a genuinely verified-kernel SMT solver are
not general-purpose solvers. **Colibrics**, a sibling in the Colibri family, is a
formally proved constraint engine, and **CoqQFBV** is a certified quantifier-free
bit-vector solver extracted from a Rocq development (verified bit-blasting plus a
verified SAT-certificate checker). Both are narrow; every general-purpose solver in
the table is unverified and relies on the certificate-plus-checker path for trust.

## Limited / theory-specialized solvers

The general-purpose table above lists solvers with broad theory coverage. A second
population of solvers targets a single theory, or a narrow group of theories, and does
not compete across the full range of SMT-LIB divisions. These are the tools you reach
for when the problem is entirely nonlinear real arithmetic, entirely bit-vectors,
entirely floating-point, or entirely strings, and a specialized decision procedure
beats a general engine. The columns match the main table where they apply;
`Certificate` uses the same three levels (`yes` = independently checkable proof object,
`partial` = unsat core or engine trace only, `no` = none).

| Solver | Theory / scope | Implementation language | Certificate | Notes |
|--------|----------------|-------------------------|-------------|-------|
| dReal | Nonlinear real arithmetic + ODEs (QF_NRA over transcendental functions) | C++ | yes | δ-complete DPLL(ICP); returns `unsat` or `δ-sat`; emits an unsat proof with a bundled proof checker. |
| MetiTarski | Inequalities over transcendental/elementary functions (ln, exp, sin, …) | Standard ML | partial | A first-order ATP (modified Metis), not an SMT-LIB solver; calls an external real-closed-field oracle (QEPCAD, Z3, or Mathematica). Proof trusts that oracle. |
| SMT-RAT | Nonlinear real and integer arithmetic (also linear, difference logic, bit-vectors) | C++ | partial | Modular CAD / virtual-substitution / Gröbner toolbox on the CArL library (RWTH Aachen); emits infeasible subsets, not full proofs. |
| raSAT | Polynomial inequality constraints over reals (QF_NRA) | OCaml | no | Interval over-approximation plus testing under-approximation, on top of MiniSAT; research prototype, effectively unmaintained. |
| iSAT3 | Nonlinear + transcendental arithmetic; bounded model checker | C++ | no | Interval constraint propagation fused with CDCL; incomplete (may return `unknown` with an undecided interval box); research tool. |
| Boolector | Bit-vectors, arrays, uninterpreted functions | C | partial | Unsat cores and SAT-layer DRUP; the direct predecessor of Bitwuzla. Development stopped; superseded by Bitwuzla. |
| Bitwuzla | Bit-vectors, floating-point, arrays, UF | C++ | partial | From-scratch 2022 C++ rewrite of Boolector; SMT-COMP leader in the QF_BV and floating-point divisions; unsat cores and bit-precise interpolants, no full certificate; no verified checker. Moved here from the general table. |
| STP | Bit-vectors + arrays | C++ | no | Bit-blasting solver for symbolic-execution and security tools; no proof output; a niche SMT-COMP entrant. Moved here from the general table. |
| Colibri (COLIBRI) | Floating-point + constraint programming | Prolog (used as a Prolog library) | no | The ancestor of the Colibri family (in development since 2000); reimplemented in OCaml as Colibri2. |
| Colibri2 | Floating-point + constraint programming | OCaml | no | OCaml successor of COLIBRI (above); high-level interval/flag reasoning per value rather than bit-blasting; Colibrics is its formally proved sibling. Moved here from the general table. |
| Z3-Noodler | Strings (word equations + regular constraints) | C++ | no | A fork of Z3 that replaces the string theory solver with a stabilization-based automata procedure on the Mata library (VeriFIT, Brno); actively developed. |
| OSTRICH | Strings (concatenation, reverse, replaceAll, …) | Scala | no | Automata-based decision procedure built as a library on top of Princess; actively developed (OSTRICH2 is the current line). |
| Princess | Presburger arithmetic + uninterpreted predicates; also arrays, ADTs, bit-vectors, strings, heaps | Scala | partial | An interpolating first-order prover; produces internal proofs and Craig interpolants, but no shared external certificate format. It is the SMT back end OSTRICH extends. |
| SMTInterpol | QF uninterpreted functions + linear arithmetic (interpolation) | Java | yes | Interpolating solver leading the QF_Equality_LinearArith division; emits its own resolution-proof format and Craig interpolants; no verified external checker. Moved here from the general table. |

Per-solver detail:

- **dReal** (C++) decides first-order formulas over the reals with polynomials,
  trigonometric, exponential, and other nonlinear functions, and can integrate
  ordinary differential equations. It implements δ-complete decision procedures
  in the DPLL(ICP) framework: an answer is `unsat` (sound) or `δ-sat` (a solution
  to a δ-perturbed formula). It is the one solver in this table with a genuine
  proof story — the `--proof` option emits an unsatisfiability proof and the
  distribution ships a checker for it.
- **MetiTarski** (Standard ML) is properly a first-order automatic theorem
  prover, not an SMT-LIB solver: a modified version of Joe Leslie-Hurd's Metis
  superposition prover that discharges the real-arithmetic side conditions with
  an external cylindrical-algebraic-decomposition oracle (QEPCAD by default, or
  Z3 or Mathematica). It proves universally quantified inequalities over
  elementary functions. Its proof is a resolution derivation that trusts the CAD
  oracle, so it is not a self-contained certificate.
- **SMT-RAT** (C++) is a toolbox rather than a single engine: parameterized
  modules (virtual substitution, cylindrical algebraic decomposition, Gröbner-basis
  simplification) combined by a user-specified strategy, built on the CArL
  real-arithmetic library. Its focus is nonlinear real and integer arithmetic; it
  emits infeasible subsets (unsat cores), not full proofs.
- **raSAT** (OCaml, on MiniSAT) solves polynomial inequalities by combining
  interval arithmetic (over-approximation for unsat) with testing
  (under-approximation for sat), refining intervals when both are inconclusive. It
  is a research prototype and is not actively maintained.
- **iSAT3** (C++) tightly integrates DPLL/CDCL with interval constraint
  propagation over linear, nonlinear, and transcendental constraints, and serves
  as a bounded model checker. It is incomplete on satisfiable instances — it can
  stop with an interval box of unknown status — and is a research tool, not a
  competition entrant.
- **Boolector** (C) is the direct predecessor of Bitwuzla, covering bit-vectors,
  arrays, and uninterpreted functions by bit-blasting with lemmas-on-demand for
  arrays. Its active development has stopped; the project itself states it is
  succeeded by Bitwuzla. It produces unsat cores and SAT-level DRUP, hence
  `partial`.
- **Bitwuzla** (C++) is a from-scratch 2022 rewrite of Boolector, covering
  bit-vectors, floating-point, arrays, and uninterpreted functions — but no
  arithmetic theory. It leads the bit-vector and floating-point SMT-COMP divisions
  (`QF_Bitvec`, `QF_Equality_Bitvec`, `FPArith`, `QF_FPArith`). It produces unsat
  cores and, recently, bit-precise interpolants, but not a full independently
  checkable certificate — hence `partial`.
- **STP** (C++) targets bit-vectors and arrays for symbolic-execution and security
  tools; it bit-blasts and is not a proof-producing solver.
- **Colibri (COLIBRI)** is the original constraint-programming solver of the
  Frama-C Colibri family, in development since 2000 and used as a Prolog library
  by other tools. It maintains high-level interval and flag information per
  floating-point value rather than bit-blasting. Colibri2 is its OCaml
  reimplementation, and Colibrics is the formally proved sibling cited in the
  verified-kernel note above.
- **Colibri2** (OCaml) is the OCaml successor of COLIBRI, the constraint-programming
  SMT solver of the Frama-C Colibri family, aimed at floating-point and embedded
  reasoning; it maintains high-level interval and flag information per value rather
  than bit-blasting, and does not emit a checkable proof.
- **Z3-Noodler** (C++) is a fork of Z3 v4.15.x that swaps Z3's string theory
  solver for a stabilization-based automata procedure implemented on the Mata
  automata library. It inherits Z3's non-string reasoning; its string solver adds
  no separate proof certificate.
- **OSTRICH** (Scala) is an automata-based string solver built as a library on
  Princess, with a decision procedure exploiting distributivity of regular
  constraints across function pre-images (concatenation, reverse, replaceAll, and
  more). It is actively developed; OSTRICH2 is the current release line.
- **Princess** (Scala) is an interpolating theorem prover for Presburger
  arithmetic with uninterpreted predicates, extended with theory modules for
  arrays, nonlinear arithmetic, rationals, bit-vectors, algebraic datatypes,
  heaps, and strings. It produces internal proofs and Craig interpolants but no
  shared external certificate format, so `partial`. OSTRICH is built on it.
- **SMTInterpol** (Java) is proof-producing over the quantifier-free combination of
  uninterpreted functions and linear arithmetic, and leads the
  `QF_Equality_LinearArith` division. It extracts unsat cores and inductive
  sequences of Craig interpolants from its resolution proofs, but there is no
  verified external checker for its format.

These four — **Bitwuzla**, **STP**, **Colibri2**, and **SMTInterpol** — were moved
here from the general-purpose table because their theory coverage is narrow: Bitwuzla
and STP are bit-vector/array (and, for Bitwuzla, floating-point) solvers, Colibri2 is
floating-point and constraint-programming, and SMTInterpol is confined to
quantifier-free uninterpreted functions plus linear arithmetic with an interpolation
focus. Bitwuzla and SMTInterpol remain strong SMT-COMP entrants that lead specific
divisions, but they decide only their own theories, not the broad range the
general-purpose solvers cover.

## Sources

- Computer Language Benchmarks Game / SMT-COMP results index — https://smt-comp.github.io/2024/results/
- SMT-COMP 2025 single-query results — https://smt-comp.github.io/2025/results/results-single-query/
- SMT-COMP 2024 single-query results — https://smt-comp.github.io/2024/results/results-single-query/
- SMT-COMP 2024 largest-contribution ranking — https://smt-comp.github.io/2024/results/largest-contribution-single-query/
- SMT-COMP 2023 slides — https://smt-workshop.cs.uiowa.edu/2023/slides/smtcomp.pdf
- Z3 proof logs and proof terms — https://microsoft.github.io/z3guide/programming/Proof%20Logs/ ; "Proofs in Satisfiability Modulo Theories" — https://leodemoura.github.io/files/SMTProofs.pdf ; Z3 Theorem Prover — https://en.wikipedia.org/wiki/Z3_Theorem_Prover
- cvc5 proof production (Alethe, LFSC, Lean) — https://cvc5.github.io/docs/cvc5-1.0.2/proofs/proofs.html ; Alethe output — https://cvc5.github.io/docs/cvc5-1.0.0/proofs/output_alethe.html ; cvc5 system description — https://hanielbarbosa.com/papers/tacas2022.pdf
- Yices2 unsat proofs and cores — https://yices.csl.sri.com/papers/manual.pdf
- MathSAT5 (proofs, interpolants, C++ reimplementation) — https://mathsat.fbk.eu/ ; "The MathSAT5 SMT Solver" — https://link.springer.com/chapter/10.1007/978-3-642-36742-7_7
- veriT and Alethe — https://www.verit-solver.org/ ; "The Alethe Proof Format" — https://verit.loria.fr/documentation/alethe-spec.pdf
- Alt-Ergo (OCaml, proof/unsat-core options) — https://alt-ergo.ocamlpro.com/ ; https://en.wikipedia.org/wiki/Alt-Ergo
- OpenSMT (C++, proofs, interpolants) — https://github.com/usi-verification-and-security/opensmt ; SMT-COMP 2020 description — https://smt-comp.github.io/2020/system-descriptions/OpenSMT.pdf
- Carcara Alethe checker — https://link.springer.com/chapter/10.1007/978-3-031-30823-9_19
- SMTCoq — https://smtcoq.github.io/capi.html
- DRAT-based bit-vector proofs — https://arxiv.org/abs/1907.00087 ; CoqQFBV certified QF_BV solver — https://link.springer.com/chapter/10.1007/978-3-030-81688-9_7
- dReal — http://dreal.github.io/ ; "dReal: An SMT Solver for Nonlinear Theories over the Reals" — https://link.springer.com/chapter/10.1007/978-3-642-38574-2_14 ; https://github.com/dreal/dreal4
- MetiTarski — https://www.cl.cam.ac.uk/~lp15/papers/Arith/ ; https://www.cl.cam.ac.uk/~lp15/papers/Arith/calculemus2008.pdf ; Metis — https://www.gilith.com/metis/
- SMT-RAT — https://smt-comp.github.io/2020/system-descriptions/SMT-RAT.pdf ; https://link.springer.com/chapter/10.1007/978-3-319-24318-4_26
- raSAT — https://link.springer.com/article/10.1007/s10703-017-0284-9
- iSAT3 — https://www.semanticscholar.org/paper/06e898cca568bad925c83276a24ee3aa0111d992
- Boolector / Bitwuzla — https://github.com/Boolector/boolector ; https://link.springer.com/chapter/10.1007/978-3-642-00768-2_16 ; Bitwuzla — https://github.com/bitwuzla/bitwuzla ; CAV 2023 — https://cs.stanford.edu/~preiner/publications/2023/NiemetzP-CAV23.pdf
- STP — https://github.com/stp/stp ; "A Solver for a Theory of Strings and Bit-vectors" — https://arxiv.org/pdf/1605.09446
- Colibri family (Colibri2 in OCaml; Colibrics formally proved) — https://colibri.frama-c.com/ ; https://arxiv.org/pdf/2002.12441
- Z3-Noodler — https://github.com/VeriFIT/z3-noodler ; https://link.springer.com/chapter/10.1007/978-3-031-57246-3_2
- OSTRICH — https://github.com/uuverifiers/ostrich ; https://arxiv.org/pdf/2506.14363
- Princess — http://www.philipp.ruemmer.org/princess.shtml ; https://github.com/uuverifiers/princess
- SMTInterpol — https://ultimate.informatik.uni-freiburg.de/smtinterpol/ ; "SMTInterpol: an Interpolating SMT Solver" — https://jhoenicke.de/docs/chn12-spin.pdf
