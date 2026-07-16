<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# SMT Certificate-Checker Verification: the Verified and Trusted Computing Bases

`SMTs.md` records, per solver, whether a *formally verified* checker exists for the
solver's proof certificate. This document answers the next two questions. First: which of
the seven general-purpose solvers actually have a machine-checked checker, and which
checker. Second: how large is the code involved, split into two disjoint notions that
must be measured separately.

- **VCB — Verified Computing Base.** The checker code that is **proven correct**: SMTCoq's
  reflexive checker, cake_lpr, gratchk, CoqQFBV. This code is *verified, not trusted*. Its
  size matters for audit and confidence, but a bug in it cannot make it accept a false
  certificate — the machine-checked soundness proof forbids exactly that, so such a bug is
  caught by the proof rather than silently believed.
- **TCB — Trusted Computing Base.** What remains **trusted** after verification: the prover
  **kernel** the checker is checked against (the Rocq or HOL4 kernel), plus the trusted
  SMT-LIB/DIMACS **semantics** and the **parser** that turns bytes on disk into the term
  the soundness theorem quantifies over. This is what must be believed unconditionally; no
  proof in the development discharges it.

The central point is that **verification moves code from the TCB into the VCB.** Before a
checker is verified, its entire body is trusted. After, the body is proven and only the
kernel plus the problem semantics and parser remain trusted. The quantitative result is an
asymmetry in three bands: the VCB is tens of thousands of lines of proven code, the
residual TCB is a few thousand to ~30 k lines of trusted kernel plus semantics, and both
are one to two orders of magnitude smaller than the ~350 k–500 k-line unverified solvers
of `SMTSizes.md` whose answers they certify.

All line counts are tokei's **Code** column (physical lines that are neither blank nor
comment), read from the clones produced by `scripts/CheckoutCheckerSources.sh`. Each row
below names the exact path counted and what was excluded.

## 1. Which solvers have a proven checker

The trust model is the one stated in `SMTs.md`: a production SMT solver is a large,
unverified C/C++/OCaml program; it is not trusted, its emitted certificate is. A *separate*
checker validates the certificate, and that checker can itself be formally verified. Two
independent proof layers must both be discharged: the SMT-level proof (theory reasoning, in
the Alethe or LFSC format) and the propositional SAT layer that bit-vector and Boolean
reasoning bit-blast into (in the DRAT/LRAT clausal-refutation format). Each layer has its
own verified checker — its own VCB.

| Solver | Certificate format(s) | SMT-level verified checker | SAT-layer verified checker |
|--------|-----------------------|----------------------------|----------------------------|
| Z3 | proof log (`sat.euf`), historical proof terms | SMTCoq (Rocq); Isabelle/HOL reconstructs Alethe | cake_lpr (HOL4/CakeML); GRAT/gratchk (Isabelle) |
| cvc5 | Alethe, LFSC, Lean 4; DRAT for the SAT/BV layer | SMTCoq (Rocq); Isabelle/HOL (Alethe) | cake_lpr (HOL4/CakeML); GRAT/gratchk (Isabelle) |
| veriT | Alethe (the format originated here) | SMTCoq (Rocq); Isabelle/HOL (Alethe) | cake_lpr; GRAT/gratchk |
| Yices2 | unsat cores / partial | none | — |
| MathSAT5 | own proof format | none | — |
| Alt-Ergo | named-assertion artifact / partial | none | — |
| OpenSMT | own resolution-proof format | none | — |

Three precise points about the verified-checker column:

- The verified Alethe path is **SMTCoq** (a checker extracted from a Rocq/Coq-certified
  program) and **Isabelle/HOL** (which reconstructs Alethe proofs against its own kernel).
  It is **not Carcara** — Carcara is a standalone Alethe checker and elaborator written in
  Rust, fast and useful but with no machine-checked correctness proof — and it is **not**
  the LFSC checker, a C++ signature-driven checker that is likewise unverified. Carcara and
  LFSC are in neither the VCB nor a reduced-TCB story: they are unverified checkers,
  measured below only as contrast.
- SMTCoq's first-class inputs are veriT and cvc5 Alethe proofs and ZChaff SAT proofs; Z3 is
  reached through the shared Alethe format and an SMTCoq extension. The `yes` in the
  `SMTs.md` `Verified checker` column for Z3/cvc5/veriT is the mapping recorded here.
- The SAT layer is separable and has its own verified checkers. **cake_lpr** is verified in
  HOL4 and its correctness proof reaches the extracted **CakeML machine code**, not merely
  the source. **GRAT/gratchk** is verified in Isabelle/HOL down to the integer array
  representing the formula. CoqQFBV (below) uses GRAT internally to discharge its
  bit-blasted SAT layer.

The four solvers with `none` — Yices2, MathSAT5, Alt-Ergo, OpenSMT — either emit only a
partial artifact (an unsat core or engine trace, not a full independently checkable
refutation) or emit a full proof in a private format for which no verified checker has been
built. A verified checker requires a shared, fully specified certificate format; that is why
the verified-checker frontier coincides with Alethe/LFSC plus DRAT/LRAT.

A narrow fifth verified artifact sits beside these: **CoqQFBV**, a certified quantifier-free
bit-vector solver-and-checker extracted from a Rocq development (verified bit-blasting plus
a verified interface to GRAT's SAT-certificate checker). It is not a checker for one of the
seven solvers' certificates; it is a self-contained certified decision procedure for QF_BV,
measured here as a fourth VCB development.

## 2. VCB and TCB: what verification moves, and what it leaves

A reflexive verified checker changes what must be trusted. Its own checking code is a
function defined *inside* the proof assistant and proven correct against a formal
specification of the certificate's meaning. Running it is running a proof-assistant term
whose soundness theorem is machine-checked. That code is therefore the **VCB**:
verified-not-trusted. A bug in the checker's algorithm cannot make it accept a false
certificate, because the soundness proof rules that out. Consequently the *size of the VCB
is not the size of the TCB*; the two are disjoint and are counted separately in §3.

What remains in the **TCB** — what an adversary could exploit despite the proof — is:

1. **The prover kernel that machine-checks the checker.** SMTCoq and CoqQFBV are checked by
   the **Rocq (Coq) kernel**; gratchk by the **Isabelle/HOL kernel**; cake_lpr by the
   **HOL4 kernel**. If the kernel is unsound, its acceptance of the soundness proof is
   worthless. The kernel is small by design — the LCF discipline: only a small trusted
   module can construct a value of the theorem type — which is why verification is credible.
2. **The trusted formula semantics and the parser.** The soundness theorem is stated
   *relative to* a formal semantics of the certificate and of the problem — the meaning of an
   SMT-LIB assertion, or of a DIMACS clause set. That semantics is trusted by definition: it
   is the specification, not something proven. The parser that turns on-disk bytes into the
   internal term the theorem quantifies over is trusted too; a parser that misreads the
   problem breaks the guarantee regardless of the checker.

**Verification moves code from the TCB into the VCB.** An unverified checker — Carcara,
LFSC, or the built-in validators inside a solver — is trusted in its entirety: every line
of its checking logic is in the TCB. Verifying that same logic (SMTCoq, cake_lpr, gratchk)
moves the whole checking body into the VCB and shrinks the TCB to the kernel plus the
problem semantics and parser. The measured effect in §3 is that a ~10 k–44 k-line VCB leaves
behind a ~2 k–30 k-line TCB, in place of trusting a ~350 k–500 k-line solver.

For **cake_lpr** the TCB bottoms out lower than for the reflexive Coq/Rocq checkers. Its
verification is carried through the CakeML compiler's own correctness theorem to the emitted
machine code, so there is no trusted extraction step and no trusted compiler between the
proof and the running binary. Its TCB is the CakeML/HOL4 kernel plus the formal semantics of
the SAT problem and the LRAT certificate — the parser being itself verified in this
development, hence in the VCB rather than the TCB.

By contrast, a reflexive Coq/Rocq checker (SMTCoq, CoqQFBV) is proven at the source level and
then **extracted** to OCaml and compiled; the OCaml extraction mechanism and the OCaml
compiler are additional trusted elements — additional TCB — not present in the cake_lpr
chain. This is a real difference in TCB shape, not a difference in VCB size.

## 3. Measured sizes

The VCB (proven checker code) and the TCB (trusted kernel and semantics) are measured
separately, then set against the unverified checkers and, at the bottom, the unverified
solvers from `SMTSizes.md`. Every "Path counted" is relative to `sources/`.

### VCB — verified checkers (code that is proven correct)

| Development | Path counted | Language | Code | Excluded |
|-------------|--------------|----------|-----:|----------|
| SMTCoq — reflexive checker | `smtcoq/theories/checker` | Coq | 15,133 | rest of `theories/`, the OCaml plugin, examples, unit-tests |
| SMTCoq — all verified theories | `smtcoq/theories` | Coq | 22,231 | `src/` OCaml plugin, `examples/`, `unit-tests/` |
| CoqQFBV — certified solver+checker | `coqqfbv/src` (minus `src/ocaml`) | Coq | 43,635 | OCaml extraction/parser, vendored libs (see caveat), examples |
| cake_lpr — LRAT checker (spec + array impl) | 8 files in `cakeml/examples/lpr_checker` | HOL4/SML | 10,071 | packing & Ramsey application specializations; `array/compilation` CakeML→machine-code glue |
| gratchk — SAT-certificate checker | `grat/gratchk/*.thy` | Isabelle | 11,605 | `document/`, `output/` (exported SML), `code/` (unverified driver/parser glue) |

The two SMTCoq rows are nested: `theories/checker` (15,133) is the reflexive checker proper
— `MainChecker.v` plus the per-theory small checkers; `theories/` (22,231) adds the verified
support in `structures/` and `utils/` (Int63, persistent arrays, bit-vector primitives) and
the reflexion `tactics/`. Report 15,133 as the checker, 22,231 as the whole verified Coq VCB.

### TCB — trusted prover kernels (what remains trusted after verification)

| Kernel | Path counted | Language | Code | Note |
|--------|--------------|----------|-----:|------|
| Rocq (Coq) kernel | `rocq/kernel` | OCaml | 30,411 | TCB for SMTCoq and CoqQFBV. The directory also holds 2,597 lines of C (the `byterun/` bytecode VM used by `vm_compute`), likewise trusted; OCaml logic is the 30,411 figure. |
| HOL4 kernel (standard) | `hol4/src/0` + `src/thm/std-thm{,sig}.ML` | SML | 2,210 | TCB for cake_lpr. The LCF trusted core: type/term representation (`src/0`) plus the primitive-inference `Thm` structure. Adding the OpenTheory `Thm` variant and the `prekernel/` support (~2,065) raises the figure; the standard kernel proper is 2,210. |

The kernel is the machine-checkable part of the TCB. The rest of the TCB — the SMT-LIB/DIMACS
semantics and, for the extracted checkers, the parser — is definitional (the specification a
soundness theorem is stated against) and is not a separately countable code artifact. The
Isabelle/HOL kernel (the TCB for gratchk and for Isabelle's Alethe reconstruction) was not
measured as a separate clone; it is a small Standard ML core comparable in role and size to
the HOL4 kernel.

### Unverified checkers (contrast — entirely in the TCB, no proof)

| Checker | Path counted | Language | Code | Note |
|---------|--------------|----------|-----:|------|
| Carcara — Alethe checker/elaborator | `carcara` (excl. `test/`, `tests/`) | Rust | 22,420 | Fast standalone Alethe checker; not machine-checked, so all of it is trusted. |
| LFSC — proof checker | `lfsc/src` | C++ + C Header | 5,570 | 4,729 C++ + 841 C Header; cvc5's LFSC signature-driven checker; not machine-checked, so all of it is trusted. |

Carcara and LFSC are the measured cost of *not* verifying: their whole bodies (22,420 and
5,570 lines) sit in the TCB, whereas SMTCoq/cake_lpr/gratchk move comparable checking logic
into the VCB and leave only a kernel behind.

### The three bands, against the unverified solvers

The solvers whose answers all of the above certify are, from `SMTSizes.md`:

| System | Band | Code | Status |
|--------|------|-----:|:------:|
| Z3 | unverified solver (`z3/src`) | 496,337 | trusted-or-certified |
| cvc5 | unverified solver (`cvc5/src`) | 358,821 | trusted-or-certified |
| veriT | unverified solver (2021 tarball `src/`) | 55,561 | trusted-or-certified |
| — | — | — | — |
| CoqQFBV certified solver+checker | VCB | 43,635 | verified (Rocq) |
| Rocq kernel | TCB | 30,411 | trusted core |
| SMTCoq all theories | VCB | 22,231 | verified (Rocq) |
| Carcara (Alethe, Rust) | unverified checker → TCB | 22,420 | trusted |
| SMTCoq reflexive checker | VCB | 15,133 | verified (Rocq) |
| gratchk (SAT layer) | VCB | 11,605 | verified (Isabelle) |
| cake_lpr (SAT layer) | VCB | 10,071 | verified (HOL4→machine code) |
| LFSC checker (C++) | unverified checker → TCB | 5,570 | trusted |
| HOL4 standard kernel | TCB | 2,210 | trusted core |

Reading the bands together: to trust a cvc5 `unsat` on a bit-vector problem via the cake_lpr
path, the residual TCB is the ~2 k-line HOL4 kernel plus the SAT-problem semantics, and the
VCB doing the work is ~10 k lines of proven checker — in place of trusting a 358,821-line
unverified solver. Even the largest VCB artifact (CoqQFBV, 43,635) and the largest TCB kernel
(Rocq, 30,411) are an order of magnitude below Z3's 496,337 and cvc5's 358,821 lines.
Verification does not make the solver smaller; it moves the burden of trust off the
half-million-line solver and onto a small VCB plus a small TCB.

## Methodology and caveats

- **tokei Code column.** All figures are non-blank, non-comment physical lines, identical to
  the rule in `SMTSizes.md` and `PLSizes.md`. Runnable via
  `scripts/CheckoutCheckerSources.sh` then per-path `tokei` invocations; the paths and
  exclusions are stated in each row above.
- **VCB vs TCB.** *VCB* code carries a machine-checked soundness proof (SMTCoq, CoqQFBV,
  gratchk, cake_lpr). *TCB* code has no such proof and must be believed (the prover kernels;
  every parser; the formal semantics a soundness theorem is stated against). The two are
  disjoint and are reported in separate tables precisely so they are not conflated. An
  unverified checker (Carcara, LFSC) is entirely TCB.
- **cake_lpr scope.** The 10,071-line VCB figure counts the checker specification
  (`lprScript`, `satSemScript`), the DIMACS/LRAT parser (`lpr_parsingScript`,
  `lpr_arrayParsingProgScript`), and the verified array implementation (`lpr_listScript`,
  `lpr_arrayProgScript`, `lpr_arrayFullProgScript`, `lpr_composeProgScript`). The
  packing-chromatic and Ramsey specializations and the `array/compilation` directory (the
  CakeML compiler invocation and its ARM8/x64 machine-code correctness proof) are excluded as
  applications and extraction glue; the whole `examples/lpr_checker` tree is 12,956 SML.
- **gratchk scope.** The 11,605 Isabelle lines are the `*.thy` theories in the `gratchk`
  package: the DRAT/GRAT semantics, unit propagation, and the verified checker itself,
  together with the bundled refinement-framework support theories the development builds on.
  The exported SML (`output/`, 3,579 lines) and the unverified I/O driver and DIMACS parser in
  `code/` are excluded. gratchk is the VCB; gratgen (the unverified DRAT→GRAT generator) was
  not fetched.
- **HOL4 kernel judgment call.** HOL4's trusted core is layered across `src/prekernel`
  (support: `Lib`, `Feedback`, `Globals`), `src/0` (type and term representation), and
  `src/thm` (the primitive-inference `Thm` structure, in standard and OpenTheory variants).
  The reported 2,210 TCB lines are the standard kernel proper: `src/0` plus
  `std-thm.ML`/`std-thmsig.ML`, excluding the `mlton/` build variant and tests. tokei labels
  the `.ML` files OCaml by extension; they are Standard ML. Including the OpenTheory `Thm`
  variant and the `prekernel/` support directory would roughly double the figure; the LCF
  trusted core that constructs theorem values is the 2,210 reported.
- **Rocq kernel judgment call.** `rocq/kernel` (30,411 OCaml) is the kernel directory proper —
  reduction, conversion, typing, universes, and the safe-environment interface. The 2,597
  lines of C in `byterun/` implement the bytecode reduction machine invoked by `vm_compute`
  and are part of the trusted conversion path; they are noted separately rather than summed
  into the OCaml logic figure.
- **CoqQFBV vendored libraries not fetched.** CoqQFBV's `src/` Coq (43,635) builds on the
  vendored `lib/coq-nbits` and `lib/coq-ssrlib` libraries, which are git submodules and were
  not populated by the `--depth 1` shallow clone. The 43,635 figure is therefore the CoqQFBV
  `src/` VCB alone; its verified support libraries are additional and uncounted. The OCaml
  extraction and SMT-LIB parser glue in `src/ocaml` (39,287 OCaml + 193 Menhir) is trusted,
  not verified — it is TCB, not VCB — and is excluded from the VCB figure.
- **Carcara test exclusion.** The `test/` and `tests/` directories were excluded by basename;
  Carcara also keeps some `#[cfg(test)]` unit tests inline in `src/`, which the 22,420-line
  Rust figure does not separate out.
- **Not everything is a separate repository.** cake_lpr lives inside the existing
  `sources/cakeml` clone and was not re-cloned. GRAT/gratchk has no public git repository; it
  is fetched as the `gratchk.tgz` tarball (verified Isabelle theories) from Peter Lammich's TU
  Munich page. Both facts are handled by the checkout script below.

## Reproducing

```
bash scripts/CheckoutCheckerSources.sh   # shallow-clones smtcoq, coqqfbv, carcara, lfsc,
                                          # the Rocq and HOL4 kernels; fetches the gratchk
                                          # tarball. cake_lpr is already inside sources/cakeml.
# then measure each path with tokei, e.g.:
tokei sources/smtcoq/theories/checker                 # VCB: SMTCoq reflexive checker
tokei sources/coqqfbv/src --exclude ocaml             # VCB: CoqQFBV certified solver+checker
tokei sources/grat/gratchk/*.thy                      # VCB: gratchk
tokei sources/rocq/kernel                             # TCB: Rocq kernel
tokei sources/hol4/src/0 sources/hol4/src/thm/std-thm.ML sources/hol4/src/thm/std-thmsig.ML --exclude mlton  # TCB: HOL4 kernel
```

`sources/` is git-ignored; none of these clones or the gratchk tarball are committed.

## Sources

- SMTCoq — https://github.com/smtcoq/smtcoq ; project page https://smtcoq.github.io/ ; C API / extraction note https://smtcoq.github.io/capi.html
- CoqQFBV — https://github.com/fmlab-iis/coq-qfbv ; "CoqQFBV: A Scalable Certified SMT Quantifier-Free Bit-Vector Solver" https://link.springer.com/chapter/10.1007/978-3-030-81688-9_7
- cake_lpr (LRAT checker in CakeML) — https://github.com/CakeML/cakeml (subdir `examples/lpr_checker`) ; CakeML verified SAT-checker work
- GRAT / gratchk — https://www21.in.tum.de/~lammich/grat/ ; "Efficient Verified (UN)SAT Certificate Checking", J. Automated Reasoning https://link.springer.com/article/10.1007/s10817-019-09525-z ; "The GRAT Tool Chain" https://link.springer.com/chapter/10.1007/978-3-319-66263-3_29
- Carcara (unverified Alethe checker, Rust) — https://github.com/ufmg-smite/carcara ; "Carcara: An Efficient Proof Checker and Elaborator for SMT Proofs in the Alethe Format" https://link.springer.com/chapter/10.1007/978-3-031-30823-9_19
- LFSC (unverified checker, C++) — https://github.com/cvc5/LFSC ; cvc5 LFSC output docs https://cvc5.github.io/docs/cvc5-1.0.2/proofs/output_lfsc.html
- Rocq (Coq) prover, kernel — https://github.com/rocq-prover/rocq
- HOL4 theorem prover, kernel — https://github.com/HOL-Theorem-Prover/HOL
- Alethe format — https://verit.loria.fr/documentation/alethe-spec.pdf
- Solver sizes referenced in the three-bands table — `docs/SMTSizes.md`
