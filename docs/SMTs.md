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
uninterpreted functions. This document records eleven solvers on five attributes:
the language the solver itself is written in, whether its core reasoning engine is
formally verified, whether it emits a checkable proof certificate, whether a
formally verified checker exists for that certificate, and a coarse ordinal
`SMT-COMP standing` derived from recent SMT-COMP division results (2023–2025).

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

## The Eleven Solvers

| Solver | Implementation language | Kernel verified | Certificate | Verified checker | SMT-COMP standing |
|--------|-------------------------|-----------------|-------------|------------------|-------------------|
| Z3 | C++ | no | yes | yes | broad-leader |
| cvc5 | C++ | no | yes | yes | broad-leader |
| Yices2 | C | no | partial | no | division-leader |
| MathSAT5 | C++ | no | yes | no | mid-pack |
| Bitwuzla | C++ | no | partial | no | division-leader |
| veriT | C | no | yes | yes | niche |
| SMTInterpol | Java | no | yes | no | division-leader |
| Alt-Ergo | OCaml | no | partial | no | niche |
| OpenSMT | C++ | no | yes | no | division-leader |
| STP | C++ | no | no | no | niche |
| Colibri2 | OCaml | no | no | no | niche |

## Notes

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
- **Bitwuzla** is the leader in the bit-vector and floating-point divisions —
  `QF_Bitvec`, `QF_Equality_Bitvec`, `FPArith`, and `QF_FPArith` — where it and its
  variants took first place in 2024 and 2025. Its coverage is narrower than Z3/cvc5
  (bit-vectors, floating-point, arrays, uninterpreted functions), so it is a dominant
  division-leader rather than a broad-leader.
- **Yices2** is fast on quantifier-free fragments: it led `QF_Equality`,
  `QF_Equality_NonLinearArith`, and `QF_LinearRealArith`, consistent with its
  reputation for speed on quantifier-free linear-arithmetic and bit-vector problems.
- **OpenSMT** leads the quantifier-free linear-arithmetic divisions
  (`QF_LinearIntArith`, `QF_LinearRealArith`), and **SMTInterpol** leads
  `QF_Equality_LinearArith`; both are division-leaders confined to those fragments.
- **MathSAT5** is a mature, competitive solver — strong in incremental solving and
  interpolation — but won no single-query division in 2024–2025, hence `mid-pack`.
- **veriT**, **Alt-Ergo**, **STP**, and **Colibri2** are `niche`: veriT is primarily a
  proof-producing solver, Alt-Ergo targets the Why3/SPARK/Frama-C toolchains, STP
  targets bit-vectors and arrays for symbolic-execution tools, and Colibri2 targets
  floating-point and embedded reasoning. None is a recent SMT-COMP division front-runner.

The caveat bears repeating: SMT-COMP standings and solving speed are division- and
benchmark-dependent. A solver that leads one theory can be weak in another, and the
per-division winners shift year to year, so treat the tier as a summary of breadth of
recent competitive results, not a portable speed measurement.

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
- **Bitwuzla** is a from-scratch C++ rewrite (2022) of the C solver Boolector, for
  bit-vectors, floating-point, arrays, and uninterpreted functions. The released
  solver produces unsat cores and, recently, bit-precise interpolants, but not a
  full, independently checkable proof certificate — hence `partial`, correcting the
  common assumption that it emits full proofs.
- **veriT** is the origin of the Alethe format and emits Alethe proofs consumed by
  Isabelle/HOL and SMTCoq.
- **SMTInterpol** (Java) is proof-producing over the quantifier-free combination of
  uninterpreted functions and linear arithmetic; it extracts unsat cores and
  inductive sequences of Craig interpolants from its resolution proofs.
- **Alt-Ergo** (OCaml) is the automatic prover behind Why3, SPARK, Frama-C, and
  Atelier-B. Its proof output is limited: the historical `-proof` option now reports
  the named assertions used (an unsat-core-style artifact), not a fine-grained
  checkable proof — hence `partial`.
- **OpenSMT** (C++, USI) produces resolution proofs used to drive its interpolation
  engine (linear real arithmetic, uninterpreted functions, and others); the proof is
  its own format rather than a shared standard.
- **STP** (C++) targets bit-vectors and arrays for symbolic-execution and
  security tools; it is not a proof-producing solver.
- **Colibri2** (OCaml) is a constraint-programming SMT solver in the Frama-C
  Colibri family, aimed at floating-point and embedded reasoning; it does not emit a
  checkable proof.

On verified kernels: the closest points to a genuinely verified-kernel SMT solver are
not general-purpose solvers. **Colibrics**, a sibling in the Colibri family, is a
formally proved constraint engine, and **CoqQFBV** is a certified quantifier-free
bit-vector solver extracted from a Rocq development (verified bit-blasting plus a
verified SAT-certificate checker). Both are narrow; every general-purpose solver in
the table is unverified and relies on the certificate-plus-checker path for trust.

## Limited / theory-specialized solvers

The eleven-solver table above lists solvers marketed as general-purpose SMT
engines. A second population of solvers targets a single theory, or a narrow group
of theories, and does not compete across SMT-LIB divisions. These are the tools you
reach for when the problem is entirely nonlinear real arithmetic, entirely
bit-vectors, entirely floating-point, or entirely strings, and a specialized
decision procedure beats a general engine. The columns match the main table where
they apply; `Certificate` uses the same three levels (`yes` = independently
checkable proof object, `partial` = unsat core or engine trace only, `no` = none).

| Solver | Theory / scope | Implementation language | Certificate | Notes |
|--------|----------------|-------------------------|-------------|-------|
| dReal | Nonlinear real arithmetic + ODEs (QF_NRA over transcendental functions) | C++ | yes | δ-complete DPLL(ICP); returns `unsat` or `δ-sat`; emits an unsat proof with a bundled proof checker. |
| MetiTarski | Inequalities over transcendental/elementary functions (ln, exp, sin, …) | Standard ML | partial | A first-order ATP (modified Metis), not an SMT-LIB solver; calls an external real-closed-field oracle (QEPCAD, Z3, or Mathematica). Proof trusts that oracle. |
| SMT-RAT | Nonlinear real and integer arithmetic (also linear, difference logic, bit-vectors) | C++ | partial | Modular CAD / virtual-substitution / Gröbner toolbox on the CArL library (RWTH Aachen); emits infeasible subsets, not full proofs. |
| raSAT | Polynomial inequality constraints over reals (QF_NRA) | OCaml | no | Interval over-approximation plus testing under-approximation, on top of MiniSAT; research prototype, effectively unmaintained. |
| iSAT3 | Nonlinear + transcendental arithmetic; bounded model checker | C++ | no | Interval constraint propagation fused with CDCL; incomplete (may return `unknown` with an undecided interval box); research tool. |
| Boolector | Bit-vectors, arrays, uninterpreted functions | C | partial | Unsat cores and SAT-layer DRUP; the direct predecessor of Bitwuzla. Development stopped; superseded by Bitwuzla. |
| Colibri (COLIBRI) | Floating-point + constraint programming | Prolog (used as a Prolog library) | no | The ancestor of the Colibri family (in development since 2000); reimplemented in OCaml as Colibri2, which is in the general table. |
| Z3-Noodler | Strings (word equations + regular constraints) | C++ | no | A fork of Z3 that replaces the string theory solver with a stabilization-based automata procedure on the Mata library (VeriFIT, Brno); actively developed. |
| OSTRICH | Strings (concatenation, reverse, replaceAll, …) | Scala | no | Automata-based decision procedure built as a library on top of Princess; actively developed (OSTRICH2 is the current line). |
| Princess | Presburger arithmetic + uninterpreted predicates; also arrays, ADTs, bit-vectors, strings, heaps | Scala | partial | An interpolating first-order prover; produces internal proofs and Craig interpolants, but no shared external certificate format. It is the SMT back end OSTRICH extends. |

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
- **Colibri (COLIBRI)** is the original constraint-programming solver of the
  Frama-C Colibri family, in development since 2000 and used as a Prolog library
  by other tools. It maintains high-level interval and flag information per
  floating-point value rather than bit-blasting. Colibri2 (in the general table)
  is its OCaml reimplementation, and Colibrics is the formally proved sibling
  cited in the verified-kernel note above.
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

A caveat on the general/limited boundary: the split between the eleven-solver table
and this one is not clean, because several solvers currently listed as
general-purpose are themselves theory-limited. **Bitwuzla** covers only
bit-vectors, floating-point, arrays, and uninterpreted functions — it has no
arithmetic theory. **STP** covers only bit-vectors and arrays (it appears in the
main table as a `niche` division entrant, but by scope it belongs here alongside
Boolector). **Colibri2** is a floating-point and constraint-programming solver, the
OCaml successor of the COLIBRI listed just above. **SMTInterpol** is confined to
quantifier-free uninterpreted functions plus linear arithmetic, with its design
centered on interpolation. These four sit in the main table for historical or
SMT-COMP-participation reasons, not because their theory coverage is broad. The
rows are left in place here; whether to relocate them is a maintenance decision.

## Sources

- Z3 proof logs and proof terms — https://microsoft.github.io/z3guide/programming/Proof%20Logs/ ; "Proofs in Satisfiability Modulo Theories" — https://leodemoura.github.io/files/SMTProofs.pdf ; Z3 Theorem Prover — https://en.wikipedia.org/wiki/Z3_Theorem_Prover
- cvc5 proof production (Alethe, LFSC, Lean) — https://cvc5.github.io/docs/cvc5-1.0.2/proofs/proofs.html ; Alethe output — https://cvc5.github.io/docs/cvc5-1.0.0/proofs/output_alethe.html ; cvc5 system description — https://hanielbarbosa.com/papers/tacas2022.pdf
- Yices2 unsat proofs and cores — https://yices.csl.sri.com/papers/manual.pdf ; "Unsatisfiability Proofs in the Yices 2 SMT Solver" (2025) — https://repositum.tuwien.at/bitstream/20.500.12708/216476/1/Bertalanic%20Martina%20-%202025%20-%20Unsatisfiability%20Proofs%20in%20the%20Yices%202%20SMT%20Solver.pdf
- MathSAT5 (proofs, interpolants, C++ reimplementation) — https://mathsat.fbk.eu/ ; "The MathSAT5 SMT Solver" — https://link.springer.com/chapter/10.1007/978-3-642-36742-7_7
- Bitwuzla (C++ rewrite, options) — https://github.com/bitwuzla/bitwuzla ; CLI options — https://bitwuzla.github.io/docs/binary.html ; system description CAV 2023 — https://cs.stanford.edu/~preiner/publications/2023/NiemetzP-CAV23.pdf ; "Bit-Precise Interpolation in Bitwuzla" — https://link.springer.com/chapter/10.1007/978-3-032-22752-2_4
- veriT and Alethe — https://www.verit-solver.org/ ; "The Alethe Proof Format" — https://verit.loria.fr/documentation/alethe-spec.pdf
- SMTInterpol (Java, interpolants, proofs) — https://ultimate.informatik.uni-freiburg.de/smtinterpol/ ; "SMTInterpol: an Interpolating SMT Solver" — https://jhoenicke.de/docs/chn12-spin.pdf
- Alt-Ergo (OCaml, proof/unsat-core options) — https://alt-ergo.ocamlpro.com/ ; https://en.wikipedia.org/wiki/Alt-Ergo
- OpenSMT (C++, proofs, interpolants) — https://github.com/usi-verification-and-security/opensmt ; SMT-COMP 2020 description — https://smt-comp.github.io/2020/system-descriptions/OpenSMT.pdf
- STP (C++, bit-vectors/arrays) — https://github.com/stp/stp ; "A Solver for a Theory of Strings and Bit-vectors" — https://arxiv.org/pdf/1605.09446
- Colibri family (Colibri2 in OCaml; Colibrics formally proved) — https://colibri.frama-c.com/
- Carcara Alethe checker — https://link.springer.com/chapter/10.1007/978-3-031-30823-9_19
- SMTCoq — https://smtcoq.github.io/capi.html
- DRAT-based bit-vector proofs — https://arxiv.org/abs/1907.00087 ; CoqQFBV certified QF_BV solver — https://link.springer.com/chapter/10.1007/978-3-030-81688-9_7
- dReal (C++, δ-complete, ODEs, proofs) — http://dreal.github.io/ ; "dReal: An SMT Solver for Nonlinear Theories over the Reals" — https://link.springer.com/chapter/10.1007/978-3-642-38574-2_14 ; dreal4 — https://github.com/dreal/dreal4
- MetiTarski (Standard ML, elementary functions, CAD oracle) — https://www.cl.cam.ac.uk/~lp15/papers/Arith/ ; "MetiTarski: An Automatic Prover for the Elementary Functions" — https://www.cl.cam.ac.uk/~lp15/papers/Arith/calculemus2008.pdf ; Metis (Standard ML) — https://www.gilith.com/metis/
- SMT-RAT (C++ toolbox, CAD/VS, CArL) — https://smt-comp.github.io/2020/system-descriptions/SMT-RAT.pdf ; "SMT-RAT: An Open Source C++ Toolbox for Strategic and Parallel SMT Solving" — https://link.springer.com/chapter/10.1007/978-3-319-24318-4_26
- raSAT (OCaml on MiniSAT, interval + testing) — "raSAT: an SMT solver for polynomial constraints" — https://link.springer.com/article/10.1007/s10703-017-0284-9
- iSAT3 (C++, interval constraint propagation, bounded model checker) — "Implication Graph Compression inside the SMT Solver iSAT3" — https://www.semanticscholar.org/paper/06e898cca568bad925c83276a24ee3aa0111d992
- Boolector (C, bit-vectors/arrays/UF; succeeded by Bitwuzla) — https://github.com/Boolector/boolector ; "Boolector: An Efficient SMT Solver for Bit-Vectors and Arrays" — https://link.springer.com/chapter/10.1007/978-3-642-00768-2_16
- Colibri family (COLIBRI ancestor as a Prolog library; Colibri2 OCaml; Colibrics proved) — https://colibri.frama-c.com/ ; "An efficient constraint based framework for handling floating point SMT problems" — https://arxiv.org/pdf/2002.12441
- Z3-Noodler (C++ Z3 fork, automata strings on Mata) — https://github.com/VeriFIT/z3-noodler ; "Z3-Noodler: An Automata-based String Solver" — https://link.springer.com/chapter/10.1007/978-3-031-57246-3_2
- OSTRICH (Scala, automata strings on Princess) — https://github.com/uuverifiers/ostrich ; "OSTRICH2: Solver for Complex String Constraints" — https://arxiv.org/pdf/2506.14363
- Princess (Scala, Presburger + UF, arrays, interpolation) — http://www.philipp.ruemmer.org/princess.shtml ; https://github.com/uuverifiers/princess
- SMT-COMP division results (basis for the `SMT-COMP standing` column) — 2025 single-query results https://smt-comp.github.io/2025/results/results-single-query/ ; 2024 single-query results https://smt-comp.github.io/2024/results/results-single-query/ ; 2024 largest-contribution ranking https://smt-comp.github.io/2024/results/largest-contribution-single-query/ ; 2023 competition slides https://smt-workshop.cs.uiowa.edu/2023/slides/smtcomp.pdf ; results index https://smt-comp.github.io/2024/results/
