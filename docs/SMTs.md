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
uninterpreted functions. This document records eleven solvers on three attributes:
the language the solver itself is written in, whether its core reasoning engine is
formally verified, and whether it emits a checkable proof certificate — and in what
format.

The single most important observation is the middle column. No production SMT solver
listed here has a formally verified kernel: every entry reads `no`. Production SMT
solvers are large, heavily optimized C, C++, OCaml, and Java programs; verifying the
kernel of one is not how the field establishes trust. Trust instead comes from the
third column: an unverified solver emits a proof certificate that a *separate*, often
formally verified, proof checker validates independently. The solver may be wrong; the
checker's acceptance is what is trusted. This is why proof output, not kernel
verification, is the axis along which these systems actually differ.

The `Proof output` column distinguishes three levels. `yes (format)` means the solver
emits a fine-grained proof object in the named format that an external checker can
validate. `partial` means the solver produces only a coarse artifact — an
unsatisfiable core (the subset of assertions responsible for unsatisfiability) or an
engine-specific trace — that is not a full, independently checkable refutation.
`no` means no proof or certificate is emitted.

## The Eleven Solvers

| Solver | Implementation language | Kernel verified | Proof output |
|--------|-------------------------|-----------------|--------------|
| Z3 | C++ | no | yes (proof terms; newer SAT/EUF proof logs) |
| cvc5 | C++ | no | yes (Alethe, LFSC, Lean; DRAT for the bit-vector/SAT core) |
| Yices2 | C | no | partial (DPLL(T) unsat proofs and unsat cores; none for the mcSAT engine) |
| MathSAT5 | C++ | no | yes (own proof format; Craig interpolants) |
| Bitwuzla | C++ | no | partial (unsat cores and interpolants; no full proof certificate) |
| veriT | C | no | yes (Alethe) |
| SMTInterpol | Java | no | yes (own resolution-proof format; Craig interpolants) |
| Alt-Ergo | OCaml | no | partial (unsat cores; no fine-grained checkable proof) |
| OpenSMT | C++ | no | yes (own resolution-proof format; interpolants) |
| STP | C++ | no | no |
| Colibri2 | OCaml | no | no |

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
- **SMTCoq** checks proofs from Z3, cvc5, and veriT by reconstruction inside Rocq.

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
