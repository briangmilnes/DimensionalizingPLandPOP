<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Thirteen PLs — Implementation Sources

Where to obtain the source of each language's implementation, so the sizes in a
LOC study can be measured on disk rather than cited. This is a candidate list to
be pared down to one authoritative source per language, and a fixed rule for what
counts.

## What to count (the scope problem)

Three things get conflated in "how big is a language," and we want only the first
two:

1. **Implementation** — the compiler or interpreter plus its runtime (GC, JIT,
   VM). This is the language proper.
2. **Base / standard library** — the library that ships with the implementation
   (Python's `Lib/`, Rust's `library/std`, the SML Basis). In scope.
3. **The package ecosystem** — third-party libraries in a registry (PyPI, npm,
   crates.io, Hackage, Maven Central, NuGet, opam). Unbounded and **out of
   scope**; we do not want these.

The boundary between (2) and (3) is the crux and must be fixed per language before
measuring — e.g. for C# does the .NET base class library count but not NuGet; for
Common Lisp SBCL's `contrib/` is a judgment call. The `Base library` column names
the in-repo path that (2) refers to.

The verified compilers **CompCert** (C) and **CakeML** (SML) are included as
distinct implementation rows: they are small, self-contained, authoritative, and
directly relevant to the `ProofsOfProgrammingLanguages.md` catalog.

## Sources

Authoritative pick per language is listed first; alternatives are in Notes.

| Language | Implementation | Source repository | Base library (in-repo) | Notes |
|----------|----------------|-------------------|------------------------|-------|
| Python | CPython | https://github.com/python/cpython | `Lib/` (Python) + `Modules/`, `Objects/`, `Python/` (C) | Reference implementation. Alt: PyPy (`github.com/pypy/pypy`). |
| C | GCC | https://github.com/gcc-mirror/gcc | libc is separate: glibc (`sourceware.org/git/glibc.git`) or musl (`git.musl-libc.org`) | GCC is multi-front-end and huge; count only the C front end + gcc middle/back end, or use a smaller compiler. Alt: Clang (see C++ row). |
| C (verified) | CompCert | https://github.com/AbsInt/CompCert | — (targets the host libc) | Verified optimizing C compiler in Rocq. Small and self-contained — a clean row to measure. |
| C++ | Clang + LLVM | https://github.com/llvm/llvm-project | libc++ in `libcxx/` (or libstdc++ inside GCC) | LLVM is shared by many front ends; count `clang/` + `libcxx/`, and decide whether the shared LLVM backend counts. Alt: GCC `g++`. |
| Java | OpenJDK | https://github.com/openjdk/jdk | class library in `src/java.base`, `src/java.*` | HotSpot VM in `src/hotspot`. |
| C# | Roslyn (compiler) + CoreCLR/BCL (runtime + library) | https://github.com/dotnet/roslyn ; https://github.com/dotnet/runtime | .NET base class library in `dotnet/runtime` `src/libraries` | Compiler and runtime/library live in separate repos. Exclude NuGet. |
| JS | V8 | https://github.com/v8/v8 | none separate (built-ins live in the engine) | Alt engines: SpiderMonkey (`github.com/mozilla/gecko-dev`, `js/src`), JavaScriptCore (WebKit). |
| TS | TypeScript | https://github.com/microsoft/TypeScript | `src/lib/*.d.ts` (type declarations only; tiny) | Compiles to JavaScript; has no runtime standard library of its own. |
| Rust | rustc | https://github.com/rust-lang/rust | `library/std` (+ `core`, `alloc`) | Compiler in `compiler/`. Links LLVM as its backend — decide whether to include LLVM. |
| Lisp | SBCL | https://github.com/sbcl/sbcl | Common Lisp + `contrib/` shipped in-repo (`src/code/`) | Common Lisp has no single standard-library repo; SBCL bundles it. Alts: CCL, ECL, ABCL. |
| Haskell | GHC | https://gitlab.haskell.org/ghc/ghc (mirror https://github.com/ghc/ghc) | `libraries/base` (+ core boot libraries, as submodules) | Uses git submodules for the boot libraries. |
| SML | MLton | https://github.com/MLton/mlton | `basis-library/` (SML Basis Library) | Alts: SML/NJ (`github.com/smlnj/smlnj`), Poly/ML (`github.com/polyml/polyml`). |
| SML (verified) | CakeML | https://github.com/CakeML/cakeml | `basis/` (CakeML Basis) | Verified compiler + runtime for an SML dialect; the development is HOL4 proof scripts, so "LOC" here is proof + generated code, not ordinary source. |
| OCaml | OCaml | https://github.com/ocaml/ocaml | `stdlib/` | |
| OxCaml | OxCaml (Jane Street) | https://github.com/oxcaml/oxcaml | `stdlib/` + Jane Street extensions | Open-source branch of OCaml (formerly `ocaml-flambda/ocaml-jst`); measure as OCaml plus the extension delta. |

## To pare down

For each row we still need to decide, before measuring:

- **One authoritative implementation** (e.g. GCC vs Clang for C; MLton vs SML/NJ
  for SML) — or measure two and label both.
- **Which in-repo directories count** as implementation vs base library vs tests
  vs generated code, so the numbers are comparable across languages.
- **Shared backends**: LLVM is counted once but serves C++, Rust (backend), and
  others — whether to attribute it, and to which, is a decision, not a fact.
- **CakeML's caveat**: its repo is HOL4 proof scripts producing verified machine
  code, so a raw LOC count is not comparable to an ordinary compiler's source.

## Sources

- OxCaml — https://github.com/oxcaml/oxcaml ; https://oxcaml.org/get-oxcaml/ ; https://blog.janestreet.com/introducing-oxcaml/
- CompCert — https://github.com/AbsInt/CompCert ; https://compcert.org/
- CakeML — https://github.com/CakeML/cakeml ; https://cakeml.org/
