<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Programming Language Implementation Sizes

Code-size measurements for the language implementations checked out under
`sources/`, counting the **source / compiler** and the **base library** of each
system separately, with tests and test corpora excluded. The rule is
**src / lib, no tests**: for every system this reports the hand-written
implementation source of the toolchain and, where the system ships one, its base
library — never the test suites, benchmark corpora, or example programs.

## Methodology and caveats

All figures are tokei's **Code** column: physical lines that are neither blank
nor comment. The measurements are reproducible: run
`scripts/CheckoutPLSources.sh` to clone the six repositories into `sources/`
(shallow, single-branch), then `scripts/LOC.sh` to print the per-system tables.
The numbers below were read from that run.

- **Tests excluded.** For Clang, LLVM, and libc++ the `test/` and `unittests/`
  directories are excluded; those hold `.ll`/`.s` and C/C++ test corpora
  (millions of lines) rather than the tools' own source. glibc requires a
  stronger exclusion, described under its row.
- **CakeML is HOL4 proof scripts.** The CakeML figures are HOL4 `.sml` proof
  scripts, not ordinary program source; the compiler is defined and verified
  inside the proof, so its "source" size is not comparable line-for-line with a
  conventionally written compiler.
- **CompCert is mostly its Rocq proof.** Of CompCert's 206,904 lines, 170,633
  are Rocq (`.v`) — the machine-checked correctness proof — and 29,335 are the
  OCaml that is extracted and run. CompCert ships no base library of its own; its
  compiled C links against the host C library, i.e. glibc.
- **Clang and LLVM are shared toolchain infrastructure.** They are the two halves
  of the C/C++ toolchain (front end and backend). The LLVM backend is not
  C/C++-specific: it is also the code generator for `rustc`, so its 2.9M lines are
  shared infrastructure counted once here and drawn on by more than one language.
- **glibc test-interleave caveat.** glibc interleaves per-directory test files
  (`tst-*.c`, `test-*.c`) inside its source directories, which a directory-level
  exclude alone misses. The measurement therefore excludes tests both by
  directory basename (`test`, `tests`, `benchtests`, any `test*` basename) and by
  tokei file-name glob (`tst-*`, `test-*`), which empirically drops the ~3,300
  interleaved test files plus the `htl/tests`, `localedata/tests`, and `nptl`
  `tst-*` corpora. A residual ~130 differently-named test programs (`bug-*.c`,
  `check-*.c`) are not matched by these globs and remain in the count, so the
  glibc figure is a slight **over**-count of pure library source, not an
  under-count. The `localedata/` locale-definition tables (~39 MB of data, not C
  code) are excluded from the headline; including them changes the C figure by
  only ~566 lines, since tokei classifies the locale tables as data (PO/Autoconf/
  Plain Text), never as C.

The glibc headline is the sum of glibc's actual implementation languages —
C (574,520) + C Header (290,995) + GNU-style Assembly (238,643) = **1,104,158**.
The per-architecture hand-written assembly in `sysdeps/` is genuine library code
and is included. glibc's raw tokei total across all file types is 1,350,426; the
~246k difference is translation catalogs (PO files, ~105k), build files
(Makefile, Autoconf, M4), documentation (TeX, Markdown), and helper scripts —
none of which are C library implementation, so none are summed into the headline.

## Sizes by system

Code LOC (tokei Code lines), tests excluded. A dash marks a column that does not
apply to that system.

| System | Source / compiler Code | Base library Code | Dominant language | Note |
|--------|-----------------------:|------------------:|-------------------|------|
| CompCert | 206,904 | — | Rocq + OCaml | Verified C compiler; 170,633 of the source is the Rocq proof. Links against glibc. |
| CakeML | 362,817 | 24,006 | SML (HOL4) | Compiler and `basis` are HOL4 proof scripts, not ordinary source. |
| Rust (rustc) | 659,292 | 208,981 | Rust | Base library = `std` + `core` + `alloc`. Uses the LLVM backend below. |
| Clang (C/C++ front end) | 1,469,561 | — | C++ | Front-end half of the C/C++ toolchain; base library is libc++ / glibc. |
| LLVM (backend) | 2,895,123 | — | C++ | Shared code generator; also the backend for `rustc`. |
| libc++ (C++ base library) | — | 173,894 | C++ | The C++ standard library; mostly header-resident templates. |
| OxCaml | 411,215 | 28,932 | OCaml | Compiler + C runtime; base library = `stdlib`. |
| glibc (C base library) | — | 1,104,158 | C | C standard library; tests excluded (see caveat). C + C Header + Assembly. |

## Rollup by source language

Summing the compiler and base-library figures per language. The LLVM backend
(2,895,123) is shared between C++ and Rust; it is counted in the C++ row where it
originates and noted, not added again, in the Rust row.

| Language | Implementation | Total Code | Composition |
|----------|----------------|-----------:|-------------|
| C | CompCert + glibc | 1,311,062 | 206,904 (CompCert) + 1,104,158 (glibc) |
| C++ | Clang + LLVM + libc++ | 4,538,578 | 1,469,561 + 2,895,123 + 173,894 |
| Rust | rustc + std/core/alloc | 868,273 | 659,292 + 208,981; also relies on the shared 2.9M-line LLVM backend |
| OCaml (OxCaml) | OxCaml + stdlib | 440,147 | 411,215 + 28,932 |
| SML (CakeML) | CakeML + basis | 386,823 | 362,817 + 24,006 (HOL4 proof scripts) |

## Reproducing

```
bash scripts/CheckoutPLSources.sh   # clones compcert, cakeml, rust, llvm-project, oxcaml, glibc into sources/
bash scripts/LOC.sh                 # prints per-system tokei tables; read the Code column
```

`sources/` is git-ignored; the clones are not committed.
