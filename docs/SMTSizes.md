<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# SMT Solver Source Sizes

Code-size measurements for the SMT solvers catalogued in `SMTs.md`, counting each
solver's hand-written **implementation source** with tests excluded. The rule is
**implementation source, no tests, no bindings**: for every solver this reports the
lines written in the solver's own implementation language(s) — the dominant language
plus its headers and hand-written parser grammars — and drops the test suites,
benchmark corpora, example programs, foreign-language API bindings, build-system
files, documentation, and generated data. Three solvers in `SMTs.md` are closed source
or binary-only and cannot be measured; they are listed with a dash and the reason so
the set stays complete.

## Methodology and caveats

All figures are tokei's **Code** column: physical lines that are neither blank nor
comment. The measurements are reproducible: run `scripts/CheckoutSMTSources.sh` to
shallow-clone the open-source solvers into `sources/` (and fetch the veriT source
tarball, which has no public git repository), then `scripts/SMTLOC.sh` to print the
per-solver tokei tables. The numbers below were read from that run.

- **Code column = implementation-language sum.** Each solver's headline figure is the
  sum of its implementation-language rows: the dominant language and its headers (for
  C/C++ solvers, `C++` + `C Header`, or `C` + `C Header`), plus hand-written parser
  grammars (Lex, Yacc/Happy, Menhir) where present. Foreign-language API bindings
  (C#, Java, Python, Cython, TypeScript, Go, OCaml wrappers), build files (CMake,
  Autoconf, Meson, Bazel), documentation (Markdown, TeX), and generated data are read
  off the tokei table but not summed into the headline. This matches the
  implementation-language rule used in `PLSizes.md`. The raw whole-tree tokei Code
  total is larger for solvers that ship substantial bindings; the gap is called out in
  the Note column where it is material.
- **Tests excluded, per solver.** Each solver lays its tests out differently; the
  "Tests excluded" column records what was dropped. Most solvers keep tests in a
  top-level `test/`, `tests/`, or `regression/` directory that is simply not part of
  the measured source subtree. Two need directory-internal exclusion: Z3 and Z3-Noodler
  hold tests in `src/test/` (excluded by directory basename), and dReal interleaves 37
  `*_test.cc` files inside its source tree (excluded by tokei name glob) alongside a
  `test/` directory.
- **Z3-Noodler is a fork of Z3.** Z3-Noodler is a fork of Z3 v4.16.x whose tree
  contains all of Z3. Its 500,456-line figure is therefore almost entirely inherited
  Z3, not new code. The new code is the string theory solver in
  `src/smt/theory_str_noodler`, which measures 18,492 lines (C++ + C Header); the
  remainder overlaps the Z3 row above it. The figure is reported for completeness but
  must not be read as an independent 500 k-line solver.
- **Vendored and external dependencies.** raSAT bundles a copy of MiniSAT (its `mtl/`
  template library plus C/C++ solver files, ~5,163 lines) inside the clone; the
  headline counts only raSAT's own OCaml + Menhir source. SMT-RAT is built on the
  external CArL real-arithmetic library, and OSTRICH is built on Princess; neither
  dependency is vendored into the measured tree, so those numbers do not double-count.
  dReal keeps its bundled dependencies in a separate `third_party/` directory that is
  outside the measured `dreal/` source directory.
- **veriT has no public git repository.** LORIA distributes veriT as source tarballs
  only. `CheckoutSMTSources.sh` fetches `verit-2021.06.2-rmx.tar.gz` and measures its
  `src/`; the figure is that stable 2021 release, not a live repository head.
- **Closed / binary-only solvers.** MathSAT5 (FBK/Trento), iSAT3 (Freiburg/Oldenburg),
  and the original CEA Colibri are distributed as binaries only, with no public source,
  and cannot be measured. They appear in the table with a dash.

## Sizes by solver

Code LOC (tokei Code lines), implementation languages only, tests excluded, sorted
descending. The `Class` column marks each solver as general-purpose (**GP**, the seven
solvers of the `SMTs.md` main table) or theory-specialized (**Spec.**, the second
section of `SMTs.md`).

| Solver | Class | Language | Code | Tests excluded | Note |
|--------|:-----:|----------|-----:|----------------|------|
| Z3-Noodler | Spec. | C++ | 500,456 | `src/test/` | Fork of Z3 v4.16.x; the tree includes all of Z3, so this figure is almost entirely inherited. New string-solver code (`src/smt/theory_str_noodler`) is 18,492. |
| Z3 | GP | C++ | 496,337 | `src/test/` | Measured `src/`; C++ 376,255 + C Header 120,082. Raw tree Code is 547,912 — the ~52 k gap is C#/Java/Python/TypeScript/Go/OCaml API bindings. |
| cvc5 | GP | C++ | 358,821 | top-level `test/` | Measured `src/`; C++ 293,218 + C Header 65,603. Excludes Cython/Java/Python bindings and TOML. |
| Yices2 | GP | C | 247,849 | top-level `tests/` | Measured `src/`; C 219,776 + C Header 28,073. Almost pure C. |
| SMT-RAT | Spec. | C++ | 91,424 | `src/tests/` | C++ 39,789 + C Header 51,635. Built on the external CArL library (not vendored). |
| Boolector | Spec. | C | 85,394 | top-level `test/` | C 75,208 + C Header 4,608 + C++ 4,590 + C++ Header 988. Archived; superseded by Bitwuzla. |
| Bitwuzla | Spec. | C++ | 67,666 | top-level `test/` | C++ 56,748 + C Header 10,918. From-scratch rewrite of Boolector. |
| Princess | Spec. | Scala | 66,045 | `src/test/` | Measured `src/main`. OSTRICH is built on it. |
| veriT | GP | C | 55,561 | top-level `test/` | C 51,134 + C Header 4,427. From the 2021.06.2 source tarball; no public git repo. |
| Colibri2 | Spec. | OCaml | 54,191 | `colibri2/tests/` | Measured the `colibri2/` subdirectory of the Frama-C `colibrics` repository. |
| SMTInterpol | Spec. | Java | 52,933 | separate `SMTInterpolTest/` | Measured `SMTInterpol/src`. |
| STP | Spec. | C++ | 41,851 | top-level `tests/` | C++ 31,412 + C Header 6,494 + Yacc/Lex grammars 3,945. |
| OpenSMT | GP | C++ | 37,263 | top-level `test/` | C++ 22,975 + C++ Header 520 + C Header 13,768. |
| Alt-Ergo | GP | OCaml | 36,200 | top-level `tests/` | Measured `src/`; almost pure OCaml. |
| MetiTarski | Spec. | Standard ML | 30,335 | `tptp/` corpus separate | SML 30,248 + Lex grammar 87. A first-order ATP, not an SMT-LIB solver. |
| OSTRICH | Spec. | Scala | 19,940 | `src/test/` | Measured `src/main`. Built as a library on Princess. |
| raSAT | Spec. | OCaml | 13,134 | `Test/`, benchmarks | OCaml 12,612 + Menhir 522. Bundles MiniSAT (~5,163 C/C++, not counted). Unmaintained prototype (last commit 2014). |
| dReal | Spec. | C++ | 10,900 | `test/` + 37 `*_test.cc` + examples | C++ 7,890 + C Header 3,010. `third_party/` dependencies excluded (separate directory). |
| MathSAT5 | GP | C++ | — | — | Closed source: FBK/Trento, binary-only distribution, no public source. Not measurable. |
| iSAT3 | Spec. | C++ | — | — | Binary-only research tool (Freiburg/Oldenburg, AVACS); no public source repository. Not measurable. |
| Colibri (original) | Spec. | — | — | — | Original CEA Colibri; binary-only distribution, no public source. Colibri2 (above) is its measurable OCaml successor. |

The seven general-purpose solvers of `SMTs.md` are Z3, cvc5, Yices2, MathSAT5, veriT,
Alt-Ergo, and OpenSMT — of these only MathSAT5 is unmeasurable (closed source). Every
other row is theory-specialized.

## Observations

The two broad-leader general-purpose solvers, Z3 and cvc5, are also the two largest
measurable code bases (496,337 and 358,821 lines of C++), an order of magnitude larger
than the specialized solvers that decide a single theory. dReal (10,900) and raSAT
(13,134) are the smallest, consistent with their narrow scope (nonlinear real
arithmetic) and, for raSAT, its status as an unmaintained research prototype. The Scala
and OCaml solvers (Princess, Colibri2, OSTRICH, Alt-Ergo) and the Java solver
(SMTInterpol) sit in a middle band of 20 k–66 k lines, smaller than the mature C/C++
engines but not trivially so.

## Reproducing

```
bash scripts/CheckoutSMTSources.sh   # shallow-clones the open-source solvers into sources/
                                     # and fetches the veriT source tarball
bash scripts/SMTLOC.sh               # prints per-solver tokei tables; read the Code column
```

`sources/` is git-ignored; the clones and the veriT tarball are not committed. The
closed-source solvers (MathSAT5, iSAT3, original Colibri) are not fetched by the
checkout script, as they have no public source.
