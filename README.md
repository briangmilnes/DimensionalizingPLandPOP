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
 then dimensionalize them along a set of dimensions. 

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

