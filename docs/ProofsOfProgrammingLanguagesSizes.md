<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Sizes of the Verified Programming-Language Developments

This sizes the formally verified language implementations and related mechanized
developments catalogued in `ProofsOfProgrammingLanguages.md`. For each development
it reports, where the split is obtainable, three quantities: **compiler LOC**, **core
library LOC**, and **proof LOC**. The compiler-versus-library split applies only to
the developments that contain an actual verified compiler (CompCert, CakeML, Jinja,
JinjaThreads); the rest are mechanized semantics, program logics, or verified
programs with no compiler, and their compiler and library columns are marked `n/a`.

All figures are tokei's **Code** column (physical lines that are neither blank nor
comment). The measurements are reproducible: `scripts/CheckoutProofLangSources.sh`
clones the repositories into `sources/` (shallow, per-repo non-fatal), and the
proof/spec splits are produced by the three awk scripts described in the Methodology
section. `sources/` is git-ignored; the clones are not committed.

## Key methodology point: tokei counts a proof as its host language's code

tokei classifies a proof script by the file's host language and **cannot distinguish
proof from program**. A Rocq/Coq `.v` file is counted entirely as "Coq"; a HOL4
proof script (`.sml`) is counted as "Standard ML"; an Isabelle `.thy` file is counted
as "Isabelle"; tokei also recognizes Lean, Agda, and F\* as languages. Consequently,
tokei's Code figure for a verified development **includes the correctness proof but
does not separate it** from the specifications and definitions. The headline "total
development LOC" below is therefore proof-inclusive.

To obtain a proof-versus-specification split, a heuristic must be layered on top of
tokei. **Every proof-versus-spec split in this document is heuristic and approximate.**
The three heuristics, and how reliable each is, are:

- **Coq/Rocq `.v` (reliable).** `scripts/coq_proof_loc.awk` classifies every
  non-blank, non-comment physical line inside a `Proof` … `Qed`/`Defined`/`Admitted`/
  `Abort` block as *proof* and every other line as *spec/definition*. Comments
  (`(* … *)`, nesting-aware) are stripped and state is reset per file. Validation: on
  CompCert the heuristic's total (170,625) matches tokei's Coq Code (170,633) to within
  8 lines (0.005%); across the other Coq repositories it tracks tokei's Coq Code to
  within 0.6–1.6% (hs-to-coq is the exception at +7.6%, noted in its row). The split is
  a slight *under*-count of proof, because term-mode proofs written as
  `Definition f := …` with no `Proof` block count as spec.

- **HOL4 `.sml` (reliable for modern CakeML).** `scripts/hol4_proof_loc.awk` uses the
  same block idea: lines inside `Proof` … `QED` blocks are *proof*, the rest
  (`Definition … End`, `Datatype:`, theorem-statement lines) are *spec*. Modern CakeML
  is written almost entirely in this delimited syntax (11,187 `Theorem` markers against
  only 307 legacy `store_thm`/`prove(` calls, ≈2.7%), so the delimited-block heuristic
  captures nearly all proof text. Legacy undelimited proofs count as spec, a ≈3%
  proof under-count. Validation: totals match tokei's SML Code to within 0.4–0.5%.

- **Isabelle `.thy` (rough; a lower bound).** Isabelle proofs are not delimited by a
  single open/close keyword, so `scripts/isabelle_proof_loc.awk` classifies each line
  by its **leading keyword**: apply/by/done/qed/proof/next/show/have/hence/thus/
  obtain/fix/assume/using/unfolding/moreover/ultimately/… count as *proof*; everything
  else — including `lemma`/`theorem` statement lines, wrapped proof-continuation lines,
  and `text \<open>…\<close>` documentation cartouches — counts as *spec*. Because
  statement and continuation lines land in spec, the reported proof share is a **lower
  bound**. Validation: totals match tokei's Isabelle Code to within 0.9–2.2%, but the
  proof/spec boundary itself is only approximate.

- **F\* (not cleanly separable).** F\* interleaves specification, executable code, and
  proof within a single definition through refinement types and SMT-discharged
  obligations; there is no lexical proof delimiter to count. For HACL\* the only
  defensible proxy is the file kind: `.fsti` interface files (specification) versus
  `.fst` implementation-plus-proof files. Proof and program cannot be separated within
  the `.fst` bodies, and this is reported honestly rather than guessed.

## Sizes by development

Code LOC (tokei Code). `n/a` marks a column that does not apply (no compiler, or no
separable base library). The proof and spec/definition columns are the heuristic split
of the proof-language source; for CompCert the OCaml (extraction, C parser, driver
glue) is unverified program and is excluded from the proof column.

| Development | Prover / language | Compiler LOC | Core-library LOC | Total dev LOC | Proof LOC (heuristic) | Spec/def (remainder) |
|-------------|-------------------|-------------:|-----------------:|--------------:|----------------------:|---------------------:|
| **CompCert** | Rocq (Coq) + OCaml | 206,904 | none (→ glibc) | 206,904 | 89,813 | 80,812 (+29,335 OCaml) |
| **CakeML** (compiler) | HOL4 (SML) | 362,817 | — | 362,817 | 195,137 | 164,236 |
| **CakeML** (basis) | HOL4 (SML) | — | 24,006 | 24,006 | 12,887 | 10,650 |
| **Jinja** | Isabelle/HOL | 15,510 (combined) | n/a | 15,510 | 8,432 † | 7,423 |
| **JinjaThreads** | Isabelle/HOL | 79,414 (combined) | n/a | 79,414 | 44,382 † | 34,340 |
| **VST** | Rocq (Coq) | n/a | n/a | 504,090 | 268,386 | 227,603 |
| **RustBelt** (lambda-rust) | Rocq (Coq) / Iris | n/a | n/a | 17,411 | 9,920 | 7,492 |
| **JSCert / JSRef** | Rocq (Coq) | n/a | n/a | 17,122 | 4,648 | 12,460 |
| **Vellvm** | Rocq (Coq) | n/a | n/a | 27,777 | 10,673 | 16,924 |
| **hs-to-coq** | Rocq (Coq) | n/a | n/a | 115,848 | ≈39,141 ‡ | ≈86,179 ‡ |
| **Fiat-Crypto** | Rocq (Coq) | 157,671 (generator) | n/a | 157,671 | 44,768 | 110,758 |
| **HACL\* / EverCrypt** | F\* | n/a | 162,492 | 162,492 | not separable § | .fsti 34,077 / .fst 131,703 |
| **seL4** (l4v: spec + proof) | Isabelle/HOL | n/a | n/a | 803,647 | 416,381 † | 377,110 |

† Isabelle proof figures are the leading-keyword lower bound (see Methodology);
statement and continuation lines are counted as spec, so true proof is somewhat higher.
‡ hs-to-coq: the heuristic's total (125,320) runs 7.6% above tokei's Coq Code
(115,848); its `base/` subtree is 13,432 lines of *translated Haskell definitions* with
almost no proof (1.3% proof), while the verification proper (`examples/`, `base-thy/`)
carries the proof. Treat its split as the least reliable of the Coq rows.
§ HACL\*: F\* interleaves spec, code, and proof; the `.fsti`/`.fst` split is a file-kind
proxy for interface-versus-implementation, not a proof-versus-program split.

### Verified compilers (the compiler-versus-library split)

Only four developments contain an actual machine-checked verified compiler, and only
these support a meaningful compiler-versus-library breakdown.

| Compiler | Prover | Compiler LOC | Core library LOC | Base library it targets / links |
|----------|--------|-------------:|-----------------:|---------------------------------|
| CompCert | Rocq (Coq) + OCaml | 206,904 | none of its own | glibc — 1,104,158 (from `PLSizes.md`) |
| CakeML | HOL4 | 362,817 | `basis` 24,006 | its own verified `basis` + verified runtime/GC |
| Jinja | Isabelle/HOL | 15,510 (compiler + metatheory, not separable) | n/a | JVM bytecode; no separate library |
| JinjaThreads | Isabelle/HOL | 79,414 (compiler + JMM + threads, not separable) | n/a | JVM bytecode; no separate library |

CompCert's compiler LOC breaks down as 170,633 Rocq (the machine-checked proof and the
Clight/assembly semantics) plus 29,335 OCaml (extraction glue, the hand-written C
parser `cparser`, and the driver — unverified program, outside the trusted correctness
proof). It ships no base library of its own; compiled C links against the host C
library, cross-referenced here as glibc at 1,104,158 lines. CakeML is the only entry
that verifies its own base library and runtime: the `basis` library is 24,006 lines of
HOL4 proof script, and the compiler figure additionally covers a verified generational
copying garbage collector and verified bignum arithmetic. Jinja and JinjaThreads bundle
the verified source-to-bytecode compiler together with the language's operational
semantics, type system, and bytecode verifier in one Isabelle development, with no
directory boundary that cleanly isolates the compiler from its metatheory; the whole
figure is reported and labelled "combined".

### Semantics, program logics, and verified programs (no compiler)

These developments prove properties *about* a language or a program; none is a proof
that a shipping compiler is correct, so their compiler and library columns are `n/a`.
They are ordered by size.

- **seL4 / l4v** (803,647 Isabelle lines, the largest here) is the functional-
  correctness proof of the seL4 microkernel — a verified *program*, not a compiler.
  Its `spec/` (31,632 lines) is the kernel specification and is almost all definition
  (6.9% proof by the heuristic); its `proof/` (761,859 lines) is the refinement proof
  and is 54.4% proof. Only `spec/` and `proof/` were sized; the shallow clone is ≈70 MB.
- **VST** (504,090 Coq lines) is the Verified Software Toolchain: a separation-logic
  program logic for CompCert Clight, proved sound in Rocq. The bundled copies of
  CompCert (`compcert/`, `compcert_new/`) and the vendored dependencies (`coq-ext-lib`,
  `InteractionTrees`, `fcf`) were **excluded** to avoid double-counting; tests, `progs`,
  and `examples` were excluded as well.
- **Fiat-Crypto** (157,671 Coq lines in `src/`) synthesizes verified field-arithmetic
  routines and emits C, Rust, Go, and other back ends; it is a verified *code
  generator*, listed under compilers above for the compiler LOC column. Its lowest
  proof share (28.8%) reflects that most of its source is the reflective
  definition/rewriting framework rather than tactic proof.
- **HACL\* / EverCrypt** (162,492 F\* lines) is a verified cryptographic *library* that
  compiles to C. The C in `dist/` (233,390 lines) is KaRaMeL-generated output, not
  hand-written source, and is excluded. Only the hacl-star repository's F\* was sized;
  the ValeCrypt verified-assembly proofs (a separate Vale/Dafny development) were not.
- **hs-to-coq** (115,848 Coq lines) translates Haskell to Coq and verifies subsets of
  `base` and `containers`; the translator tool itself is Haskell and is not counted here.
- **Vellvm** (27,777 Coq lines in `src/`) is a Rocq semantics for a subset of LLVM IR
  with an executable interpreter.
- **RustBelt / lambda-rust** (17,411 Coq lines) is the Iris semantic-soundness proof for
  a λ-calculus model of Rust; it proves the type system sound, not that rustc is correct.
- **JSCert / JSRef** (17,122 Coq lines) is a Coq-mechanized ECMAScript 5 semantics plus
  JSRef, a reference interpreter extracted to OCaml and proved correct against it. Its
  low proof share (27.2%) reflects that the bulk of the development is the large
  inductive semantics (definition), not proof.

## Caveats and honest limits

- **All proof/spec splits are heuristic**, with reliability decreasing from Coq (line
  totals match tokei to ≈0.01–1.6%) to HOL4 (≈0.5%) to Isabelle (totals to ≈1–2% but
  the proof boundary is a keyword lower bound) to F\* (no split possible).
- **The heuristic totals are not identical to tokei's Code totals.** The awk scripts
  do their own comment/blank stripping, which diverges from tokei's by a fraction of a
  percent in most repositories (7.6% for hs-to-coq). The "Total dev LOC" column is
  tokei's Code; the proof and spec columns are the heuristic's split and sum to the
  heuristic total, not exactly to the tokei total.
- **Vendored dependencies were excluded where identified** (the CompCert copies and
  interaction-tree/ext-lib trees inside VST; `coqprime` etc. left inside Fiat-Crypto's
  `src/` measurement are part of that development's build). Residual vendored code inside
  a measured tree would inflate that development's figure.
- **Compiler-versus-library separation is only possible for the four compilers.** For
  Jinja and JinjaThreads even that separation is not clean, because the compiler and its
  metatheory share a single Isabelle development.
- **Generated artifacts are excluded from source counts**: HACL\*'s `dist/` C output and
  Fiat-Crypto's `fiat-c`/`fiat-rust`/etc. back-end output are compiler *output*, not
  hand-written source, and are not counted as development LOC.
- **Repositories cloned versus skipped.** All targeted repositories were obtained
  successfully; none was skipped for size or availability. CompCert and CakeML were
  already present under `sources/` and were reused. VST, lambda-rust, JSCert, Vellvm,
  hs-to-coq, and Fiat-Crypto were full shallow clones. HACL\* was a shallow clone
  (≈110 MB). Jinja and JinjaThreads were obtained by a blobless sparse checkout of just
  `thys/Jinja` and `thys/JinjaThreads` from the AFP GitHub mirror. seL4's l4v was a
  shallow clone whose `spec/` and `proof/` subtrees were the only parts sized. The
  KJS (K framework) JavaScript semantics and the WasmCert developments listed in the
  catalogue's secondary section were not sized (out of the requested scope).

## Reproducing

```
bash scripts/CheckoutProofLangSources.sh    # shallow-clones the verified developments into sources/
# then, per development, tokei for the total and the awk heuristics for the split:
tokei --exclude test --exclude doc sources/compcert
find sources/compcert -name '*.v'   -print0 | xargs -0 awk -f scripts/coq_proof_loc.awk      # Coq split
find sources/cakeml   -name '*.sml' -print0 | xargs -0 awk -f scripts/hol4_proof_loc.awk      # HOL4 split
find sources/afp-jinja -name '*.thy' -print0 | xargs -0 awk -f scripts/isabelle_proof_loc.awk # Isabelle split
```

Each awk script prints `proof spec total` per invocation; sum across files. `sources/`
is git-ignored; the clones are not committed.

## Sources

- CompCert — https://github.com/AbsInt/CompCert , https://compcert.org/
- CakeML — https://github.com/CakeML/cakeml , https://cakeml.org/
- Jinja / JinjaThreads (AFP) — https://www.isa-afp.org/entries/Jinja.html , https://www.isa-afp.org/entries/JinjaThreads.html , mirror https://github.com/isabelle-prover/mirror-afp-devel
- VST — https://github.com/PrincetonUniversity/VST , https://vst.cs.princeton.edu/
- RustBelt / lambda-rust — https://gitlab.mpi-sws.org/iris/lambda-rust , https://plv.mpi-sws.org/rustbelt/
- JSCert / JSRef — https://github.com/jscert/jscert
- Vellvm — https://github.com/vellvm/vellvm
- hs-to-coq — https://github.com/plclub/hs-to-coq
- Fiat-Crypto — https://github.com/mit-plv/fiat-crypto
- HACL\* / EverCrypt — https://github.com/hacl-star/hacl-star , https://hacl-star.github.io/
- seL4 / l4v — https://github.com/seL4/l4v , https://sel4.systems/
- glibc size cross-reference — `docs/PLSizes.md` (1,104,158 lines)
- tokei — https://github.com/XAMPPRocky/tokei (version 14.0.0)
