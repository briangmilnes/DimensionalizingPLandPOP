<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Dimensionalizing Programming Languages and Proofs of Programs

  This project is a design thinking exercise in dimensionalizing programming
 languages and proofs of programs. 
 
  [Design Thinking](https://en.wikipedia.org/wiki/Design_thinking) is an overview of this type
 of thinking with some problems classified as "Wicked problems". Dimensionalizing
 programming languages should be far less than 'Wicked' perhaps a 'Technical
 Challenge' types of problem [Problem Structuring Difficulty](https://en.wikipedia.org/wiki/Problem_structuring_methods#Types_of_situations_that_call_for_PSMs). 
 
  Here we start with thirteen interesting and/or popular programming languages and
 then dimensionalize them along a set of dimensions — typing, modularity,
 featurefulness, and speed.

  The project then extends the same treatment to proofs of programs. It
 dimensionalizes proof-of-programs systems — the proof assistants and deductive
 verifiers (Rocq, Lean, Agda, Twelf, Isabelle/HOL, Iris, F\*, Verus, Dafny, Why3) —
 records which languages have formally verified implementations (CompCert, CakeML,
 and others), and catalogs the SMT solvers those tools rely on by implementation
 language, kernel verification, and proof-certificate output.

  Finally it grounds these dimensions in measurement: using the checkout and
 line-counting scripts in `scripts/`, it reports the code sizes (lines of code,
 tests excluded) of the compilers, base libraries, and solvers on disk, so the
 sizes are reproducible numbers rather than estimates. 

## Documents

| # | Document | Covers |
|---|----------|--------|
| 1 | [ThirteenPLs.md](docs/ThirteenPLs.md) | Thirteen programming languages basic dimensional properties |
| 2 | [PLDimensions.md](docs/PLDimensions.md) | The dimensions along which programming languages vary |
| 3 | [TypingDimensions.md](docs/TypingDimensions.md) | Type systems: GC tagging, low-level, null/option, ADTs, polymorphism |
| 4 | [ModularityDimensions.md](docs/ModularityDimensions.md) | Modularity broken into base modules, signatures, functors, typeclasses |
| 5 | [PLFeaturefulness.md](docs/PLFeaturefulness.md) | Scores each dimension value by complexity and sums a featurefulness index per language |
| 6 | [PLSpeed.md](docs/PLSpeed.md) | Compilation speed, runtime speed, and maximal parallelism, from benchmark data |
| 7 | [ProofsOfProgramsSystems.md](docs/ProofsOfProgramsSystems.md) | Proof-of-programs systems (Rocq, Lean, Agda, Twelf, Isabelle/HOL, Iris, F*, Verus, Dafny, Why3) dimensionalized, including PL-semantics vs proofs-of-programs |
| 8 | [ProofsOfProgrammingLanguages.md](docs/ProofsOfProgrammingLanguages.md) | Which languages have verified implementations (CompCert, CakeML, …) and verified libraries, with honest extent |
| 9 | [SMTs.md](docs/SMTs.md) | SMT solvers: implementation language, whether the kernel is verified, and proof-certificate output |
| 10 | [ThirteenPLsSources.md](docs/ThirteenPLsSources.md) | Where to get each language's implementation source (incl. CompCert, CakeML), to pare down to authoritative sources for a LOC study |
| 11 | [PLSizes.md](docs/PLSizes.md) | Measured code sizes (tokei, tests excluded) of compiler + base library for CompCert, CakeML, Rust, Clang/LLVM, OxCaml, and glibc |
| 12 | [LLVMSizing.md](docs/LLVMSizing.md) | LLVM backend broken out by target architecture (25 targets, C++ vs TableGen) against the shared target-independent core |
| 13 | [SMTSizes.md](docs/SMTSizes.md) | Measured source sizes (tokei, tests excluded) of 18 SMT solvers; 3 closed-source ones noted as unmeasurable |
| 14 | [SMTCheckVerificationAndTCBandVCB.md](docs/SMTCheckVerificationAndTCBandVCB.md) | Which SMT solvers have a verified certificate checker, and the measured sizes of the Verified (VCB) vs Trusted (TCB) Computing Base against the unverified solvers |
| 15 | [ProofsOfProgrammingLanguagesSizes.md](docs/ProofsOfProgrammingLanguagesSizes.md) | Measured sizes of the verified language developments (CompCert, CakeML, VST, seL4, RustBelt, …) split into compiler / core library / proof via validated heuristics |
| 16 | [CostOfProvingEverything.md](docs/CostOfProvingEverything.md) | Defines "everything" to prove as one-column tables across eight sections (Semantics, PL, Std Library, OS, Utilities, Application Stack, Distributed Services, POP) |
| 17 | [ExamplesOfEverything.md](docs/ExamplesOfEverything.md) | For each category: LOC estimate, best formally-verified example, and best production (unverified) example |
| 18 | [BestProvenExamplesSizes.md](docs/BestProvenExamplesSizes.md) | Best verified example per category with In-Production (Yes/No) and proven-exec (PLoEC), proof (LoP), unproven-exec (UPLoEC) line counts, with section and grand totals |

