<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Programming Language Speed

Three speed axes for the thirteen languages in `ThirteenPLs.md`: how fast the
toolchain turns source into runnable form (compilation speed), how fast that
runnable form executes (runtime speed), and how much of a multi-core machine one
process can use (maximal parallelism). Runtime values are measured tiers drawn
from the Computer Language Benchmarks Game and companion benchmark sites, not
precise ratios. Benchmark outcomes are workload- and hardware-dependent: a tier
here reports the typical band a language's optimized code falls in across the
benchmark suite, not a guarantee for any single program.

Abbreviations used in the grid: interp = interpreted, no ahead-of-time compile
step; 1-thr = single-threaded execution model; cores = true shared-memory
multi-core parallelism in one process; DRF = multi-core parallelism with static
data-race freedom enforced by the type system.

## Dimensions

Each dimension's values are ordered least → most along the named axis (for the
speed axes, slowest first; for parallelism, least capable first).

| # | Dimension | Values |
|---|-----------|--------|
| 1 | Compilation speed | interp / slow / medium / fast |
| 2 | Runtime speed | slow / medium / fast / fastest |
| 3 | Maximal parallelism | none / 1-thr / cores / DRF |

Dimension 1, compilation speed, rates the ahead-of-time toolchain that produces
runnable form. `interp` marks languages with no separate ahead-of-time compile
step (Python and JavaScript execute source directly under a runtime JIT; SBCL
compiles Lisp forms to native code incrementally at eval/load time rather than
in a batch pass). `slow` covers toolchains that run heavy analysis: Rust's
borrow check plus monomorphization plus LLVM, C++ template instantiation and
header re-parsing, and GHC's optimizing pipeline. `fast` covers toolchains built
for quick turnaround: `javac`, Roslyn, `ocamlopt`, and SML/NJ's incremental
compiler. Caveat: SML's whole-program optimizing compiler MLton is slow to
compile (it trades compile time for runtime speed); the `fast` value reflects
the interactive/incremental SML compilers. OxCaml sits at `medium` because its
flambda2 optimizer does more work than stock `ocamlopt`.

Dimension 2, runtime speed, rates execution of optimized output. `fastest` is
the ahead-of-time native tier with no managed runtime overhead (C, C++, Rust),
which the Benchmarks Game places at or near the fastest measured programs.
`fast` is the tier that runs native or JIT-compiled code but carries a managed
runtime and garbage collector (Java, C#, SBCL Lisp, GHC Haskell, MLton SML,
OCaml, OxCaml), typically within a small multiple of the native tier. `medium`
is the V8/Node JIT tier (JavaScript, and TypeScript, which compiles to
JavaScript). `slow` is CPython (Python), one to two orders of magnitude behind
the native tier on CPU-bound benchmarks.

Dimension 3, maximal parallelism, rates how much of a multi-core machine one
process can use. `none`: the SML standard defines no threads or shared-memory
parallelism. `1-thr`: JavaScript and TypeScript run a single-threaded event
loop; Web/worker threads are separate isolates with no shared mutable heap
(apart from `SharedArrayBuffer`). `cores`: full shared-memory multi-core
parallelism (C, C++, Java, C#, SBCL native threads, GHC RTS with `-threaded -N`,
OCaml 5 domains, and Python — this rating assumes the newest free-threaded,
no-GIL CPython build introduced by PEP 703, experimental in 3.13 and officially
supported as an optional build in 3.14; the default build still ships the GIL,
which would serialize CPU-bound Python threads to one core). `DRF`: full
multi-core parallelism
plus a type system that statically rules out data races — Rust via ownership and
`Send`/`Sync`, OxCaml via its mode system (`sync`/`portable`). The `cores`
languages reach the same core utilization as `DRF` but without the static
data-race guarantee.

## The Thirteen on these Dimensions

| # | Dimension | Python | C | C++ | Java | C# | JS | TS | Rust | Lisp | Haskell | SML | OCaml | OxCaml |
|---|-----------|--------|---|-----|------|----|----|----|------|------|---------|-----|-------|--------|
| 1 | Compilation speed | interp | medium | slow | fast | fast | interp | medium | slow | interp | slow | fast | fast | medium |
| 2 | Runtime speed | slow | fastest | fastest | fast | fast | medium | medium | fastest | fast | fast | fast | fast | fast |
| 3 | Maximal parallelism | cores | cores | cores | cores | cores | 1-thr | 1-thr | DRF | cores | cores | none | cores | DRF |

## Sources

- Computer Language Benchmarks Game — https://benchmarksgame-team.pages.debian.net/benchmarksgame/index.html
- programming-language-benchmarks.vercel.app (per-problem C/Rust/etc. comparisons) — https://programming-language-benchmarks.vercel.app/
- kostya/benchmarks (cross-language micro-benchmarks) — https://github.com/kostya/benchmarks
- Tristan Hume, "Comparing the Same Project in Rust, Haskell, C++, Python, Scala and OCaml" (compile-time and code-size comparison) — https://thume.ca/2019/04/29/comparing-compilers-in-rust-haskell-c-and-python/
- Python 3.13/3.14 free-threading (GIL) — https://docs.python.org/3/howto/free-threading-python.html
- OCaml 5 multicore domains — https://ocaml.org/docs/multicore-transition
- OxCaml overview — https://oxcaml.org/
- Jane Street, "Oxidizing OCaml: Data Race Freedom" — https://blog.janestreet.com/oxidizing-ocaml-parallelism/
- janestreet/parallel (OxCaml fork-join parallelism) — https://github.com/janestreet/parallel
