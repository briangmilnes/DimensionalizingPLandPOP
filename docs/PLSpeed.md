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
runnable form executes (runtime speed), and how much parallel hardware a
language's programs can harness (maximal parallelism). Runtime values are
measured bands drawn from the Computer Language Benchmarks Game and companion
benchmark sites, not precise ratios. Benchmark outcomes are workload- and
hardware-dependent: a band here reports the typical range a language's optimized
code falls in across the benchmark suite, not a guarantee for any single
program. Each dimension's values carry an integer score, ordered least → most
along the named axis.

Abbreviations used in the grid: interp = interpreted, no ahead-of-time compile
step; 1-thr = single-threaded execution model; few = shared-memory multi-core in
one process, scaling to a handful or dozens of cores; 1024+ = published
benchmarks demonstrate scaling to 1024 or more cores.

## Dimensions

Each dimension's values are ordered least → most along the named axis (for the
speed axes, slowest first; for parallelism, least capable first), with an
integer score in parentheses.

| # | Dimension | Values (score) |
|---|-----------|----------------|
| 1 | Compilation speed | interp (0) / slow (1) / medium (2) / fast (3) |
| 2 | Runtime speed | slow (0) / medium (1) / fast (2) |
| 3 | Maximal parallelism | none (0) / 1-thread (1) / a few cores (2) / 1024+ (3) |

Dimension 1, compilation speed, rates the ahead-of-time toolchain that produces
runnable form. `interp (0)` marks languages with no separate ahead-of-time
compile step: Python and JavaScript execute source directly, and SBCL compiles
Lisp forms to native code incrementally at eval/load time rather than in a batch
pass. `slow (1)` covers toolchains that run heavy analysis: Rust's borrow check
plus monomorphization plus LLVM, C++ template instantiation and header
re-parsing, and GHC's optimizing pipeline. `medium (2)` covers toolchains doing
moderate optimization: C through a standard optimizing backend, TypeScript's
type-check-and-emit, and OxCaml, whose native compiler does more optimization
work than stock `ocamlopt`. `fast (3)` covers toolchains built for quick
turnaround: `javac`, Roslyn, `ocamlopt`, and SML/NJ's incremental compiler.
Caveat: SML's whole-program optimizing compiler MLton is slow to compile (it
trades compile time for runtime speed); the `fast` value reflects the
interactive/incremental SML compilers.

Dimension 2, runtime speed, rates execution of optimized output in three bands.
`fast (2)` is the tier that runs native or managed-runtime code within a small
multiple of the fastest measured programs: the ahead-of-time native languages (C,
C++, Rust) and the native/managed languages that carry a runtime and garbage
collector (Java, C#, SBCL Lisp, GHC Haskell, MLton SML, OCaml, OxCaml). The
Benchmarks Game places the native languages at or near the fastest measured
programs and the managed ones typically within a small multiple. `medium (1)` is
the JavaScript execution tier (JavaScript, and TypeScript, which compiles to
JavaScript), typically several times slower than the `fast` band on CPU-bound
benchmarks. `slow (0)` is CPython (Python), one to two orders of magnitude behind
the `fast` band on CPU-bound benchmarks.

Dimension 3, maximal parallelism, rates how much parallel hardware a language's
programs can harness, measured against published benchmarks. `none (0)`: the SML
standard defines no threads or shared-memory parallelism. `1-thread (1)`:
JavaScript and TypeScript run a single-threaded event loop; worker threads are
separate isolates with no shared mutable heap (apart from `SharedArrayBuffer`).
`a few cores (2)`: shared-memory multi-core within one process, scaling to a
handful or dozens of cores — C#, Rust (threads with ownership-checked sharing),
SBCL native threads, OCaml 5 domains, OxCaml fork-join parallelism, Java threads,
and Python (assuming a build whose threads run on separate cores). `1024+ (3)`:
languages with published benchmarks demonstrating parallel scaling to 1024 or
more cores. Four languages qualify on the evidence gathered:

- C and C++ are the primary languages of the MPI and OpenMP HPC interfaces.
  Published codes scale to tens of thousands of cores: the GROMACS molecular
  dynamics code (C/C++) sustains parallel efficiency above 0.9 out to 65,536
  cores, and the FleCSI-based radiation hydrodynamics code (C++) holds parallel
  efficiency above 97% on 1024 nodes.
- Haskell qualifies through HdpH (Haskell distributed parallel Haskell), a
  native-Haskell DSL that the peer-reviewed literature reports scaling to 32,000
  cores on distributed-memory systems.
- Python qualifies through mpi4py, its standard MPI binding: a published
  many-task scaling study runs Python over more than 12,000 cores on cluster
  supercomputers.

The `1024+` benchmarks for Haskell (HdpH) and Python (mpi4py) are
distributed-memory, multi-process results, not single-process shared-memory
scaling. Java and Rust are placed at `a few cores` rather than `1024+`: both have
HPC bindings (MPJ Express for Java, rsmpi for Rust), but the published results
located here top out below 1024 cores, so neither meets the `1024+` bar on the
evidence at hand.

## The Thirteen on these Dimensions

| # | Dimension | Python | C | C++ | Java | C# | JS | TS | Rust | Lisp | Haskell | SML | OCaml | OxCaml |
|---|-----------|--------|---|-----|------|----|----|----|------|------|---------|-----|-------|--------|
| 1 | Compilation speed | interp | medium | slow | fast | fast | interp | medium | slow | interp | slow | fast | fast | medium |
| 2 | Runtime speed | slow | fast | fast | fast | fast | medium | medium | fast | fast | fast | fast | fast | fast |
| 3 | Maximal parallelism | 1024+ | 1024+ | 1024+ | few | few | 1-thr | 1-thr | few | few | 1024+ | none | few | few |

## Sources

- Computer Language Benchmarks Game — https://benchmarksgame-team.pages.debian.net/benchmarksgame/index.html
- programming-language-benchmarks.vercel.app (per-problem C/Rust/etc. comparisons) — https://programming-language-benchmarks.vercel.app/
- kostya/benchmarks (cross-language micro-benchmarks) — https://github.com/kostya/benchmarks
- Tristan Hume, "Comparing the Same Project in Rust, Haskell, C++, Python, Scala and OCaml" (compile-time and code-size comparison) — https://thume.ca/2019/04/29/comparing-compilers-in-rust-haskell-c-and-python/
- Kutzner et al., "Scaling of the GROMACS Molecular Dynamics Code to 65k CPU Cores on an HPC Cluster" (C/C++, MPI+OpenMP strong scaling) — https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11822873/
- "Radiation Hydrodynamics at Scale: Comparing MPI and Asynchronous Many-Task Runtimes with FleCSI" (C++, >97% parallel efficiency on 1024 nodes) — https://arxiv.org/pdf/2603.05366
- Maier, Stewart, Trinder, "The HdpH DSLs for Scalable Reliable Computation," Haskell Symposium 2014 (Haskell distributed parallel Haskell, scaling to 32,000 cores) — https://www.dcs.gla.ac.uk/~trinder/papers/HdpH_DSLs-haskell14.pdf
- Lunacek et al., "The scaling of many-task computing approaches in Python on cluster supercomputers" (mpi4py over 12,000 cores) — https://www.researchgate.net/publication/261430782
- OMB-Py: Python Micro-Benchmarks for Evaluating Performance of MPI Libraries on HPC Systems — https://hgpu.org/?p=25735
- Mallón et al., "NPB-MPJ: NAS Parallel Benchmarks Implementation for Message-Passing in Java" (MPJ Express, Java HPC) — https://gac.udc.es/~gltaboada/papers/mallon_pdp09.pdf
- rsmpi: MPI bindings for Rust — https://github.com/rsmpi/rsmpi
- OCaml 5 multicore domains — https://ocaml.org/docs/multicore-transition
- OxCaml overview — https://oxcaml.org/
- janestreet/parallel (OxCaml fork-join parallelism) — https://github.com/janestreet/parallel
