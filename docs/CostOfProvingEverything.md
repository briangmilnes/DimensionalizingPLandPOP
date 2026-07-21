<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# The Cost of Proving Everything

"Everything" is the full computing stack you would have to formally verify to hold
an end-to-end machine-checked guarantee — from the processor and its instruction
set, through the compiler, runtime, operating system, libraries, and application
programs, down to the proof tools doing the checking. This document begins by
defining "everything" as a concrete list of **products** — one verified (or
yet-to-be-verified) artifact per line, grouped by stack layer.

This is the product list only. The cost columns come next: total LOC, proof LOC,
proof-to-code ratio, person-years, and whether the artifact lands in the Trusted
(TCB) or Verified (VCB) computing base. Where we have already measured a product
its size is noted with the doc that measured it; `—` marks a product not yet
measured here, and *(none yet)* marks a layer with no production verified artifact.

## Tier 0 — Proof foundations and automation

The tools that do the proving, and the residual trusted base underneath them.

| Product | Prover / language | Role | Measured LOC |
|---------|-------------------|------|-------------:|
| Rocq (Coq) | OCaml | Interactive proof assistant; its kernel is trusted | kernel 30,411 · `SMTCheck…TCBandVCB` |
| Lean 4 | Lean/C++ | Interactive proof assistant | — |
| Isabelle/HOL | SML/Scala | Interactive proof assistant | — |
| HOL4 | SML | Interactive proof assistant | kernel 2,210 · `SMTCheck…TCBandVCB` |
| Agda | Haskell | Dependently-typed proof assistant | — |
| Twelf | SML | LF logical framework for metatheory | — |
| Z3 | C++ | SMT solver (unverified; certificate-checked) | 496,337 · `SMTSizes` |
| cvc5 | C++ | SMT solver (unverified; certificate-checked) | 358,821 · `SMTSizes` |
| veriT | C | SMT solver (unverified; certificate-checked) | 55,561 · `SMTSizes` |
| SMTCoq | Rocq | Verified SMT proof checker (VCB) | 15,133 · `SMTCheck…` |
| cake_lpr | HOL4 | Verified LRAT/SAT checker to machine code (VCB) | 10,071 · `SMTCheck…` |
| GRAT / gratchk | Isabelle | Verified SAT-certificate checker (VCB) | 11,605 · `SMTCheck…` |
| CoqQFBV | Rocq | Certified QF_BV solver + checker (VCB) | 43,635 · `SMTCheck…` |

## Tier 1 — Hardware

| Product | Prover / language | Role | Measured LOC |
|---------|-------------------|------|-------------:|
| Sail ISA models | Sail | Formal semantics of ARM / RISC-V / x86 instruction sets | — |
| Kami | Rocq | Verified hardware / processor design framework | — |
| riscv-formal / verified cores | (various) | A CPU that provably implements its ISA | — |
| Verified firmware / boot | (various) | Correct bootloader and firmware | *(none yet)* |

## Tier 2 — Toolchain: compilers, language semantics, runtime

| Product | Prover / language | Role | Measured LOC |
|---------|-------------------|------|-------------:|
| CompCert | Rocq + OCaml | Verified optimizing C compiler | 206,904 · `ProofsOfProgrammingLanguagesSizes` |
| CakeML | HOL4 | Verified ML compiler + runtime + GC | 362,817 (+ basis 24,006) · same |
| Vellvm | Rocq | Verified LLVM IR semantics + interpreter | 27,777 · same |
| Jinja | Isabelle | Verified Java-subset source→bytecode compiler | 15,510 · same |
| JinjaThreads | Isabelle | Verified Java compiler + memory model + threads | 79,414 · same |
| RustBelt (λRust) | Rocq / Iris | Semantic soundness of the Rust type system | 17,411 · same |
| JSCert / JSRef | Rocq | Mechanized JS semantics + verified reference interpreter | 17,122 · same |
| hs-to-coq | Rocq | Haskell→Coq translation for verifying Haskell | 115,848 · same |
| Osiris (OLang) | Rocq / Iris | Mechanized OCaml-fragment semantics | — |

## Tier 3 — Operating systems, hypervisors, subsystems

| Product | Prover / language | Role | Measured LOC |
|---------|-------------------|------|-------------:|
| seL4 | Isabelle | Verified microkernel (functional correctness) | l4v 803,647 · `ProofsOfProgrammingLanguagesSizes` |
| CertiKOS | Rocq | Verified concurrent OS kernel | — |
| SeKVM (MicroV) | Rocq | Verified multiprocessor hypervisor | — |
| Hyperkernel | Z3 (SMT) | Push-button verified OS kernel | — |
| Atmosphere | Verus (Rust) | Verified microkernel in Rust | — |
| Verve | Boogie/Z3 | Type- and memory-safe OS | — |
| Pip / Pip-MPU | Rocq | Verified separation kernel for constrained devices | — |
| FSCQ | Rocq | Verified crash-safe file system | — |
| Yggdrasil | Z3 (SMT) | Verified file-system toolkit (crash refinement) | — |
| BilbyFs / Cogent | Isabelle / Cogent | Verified file system + certifying compiler | — |
| eChronos | Isabelle | Verified RTOS scheduler | — |
| vostd (Asterinas) | Verus (Rust) | Verified OS standard library / TCB | — |
| CortenMM | Verus (Rust) | Verified memory-management module | — |
| VeriSMo | Verus (Rust) | Verified confidential-VM security module | — |

## Tier 4 — Libraries, protocols, verification frameworks

| Product | Prover / language | Role | Measured LOC |
|---------|-------------------|------|-------------:|
| HACL\* / EverCrypt | F\* | Verified cryptographic library (compiles to C) | 162,492 · `ProofsOfProgrammingLanguagesSizes` |
| Fiat-Crypto | Rocq | Verified field-arithmetic code generator | 157,671 · same |
| CakeML basis | HOL4 | Verified standard library | 24,006 · same |
| VST | Rocq | Verified separation-logic program logic for C | 504,090 · same |
| Iris | Rocq | Concurrent separation logic framework | — (Rocq library) |
| IronFleet | Dafny | Verified distributed systems | — |
| miTLS / EverParse | F\* | Verified TLS stack / verified parsers | — |

## Tier 5 — Program verifiers (the tools that prove application programs)

| Product | Prover / language | Role | Measured LOC |
|---------|-------------------|------|-------------:|
| F\* | F\*/OCaml | Dependently-typed verification language (SMT-backed) | — |
| Verus | Rust | SMT-based deductive verifier for Rust | — |
| Dafny | C# | SMT-based auto-active verifier | — |
| Why3 | OCaml | Deductive-verification platform / backend | — |

## Notes

- The layers are ordered bottom-to-top; a genuine end-to-end guarantee requires every
  layer below the property of interest to be verified, or else trusted.
- Many products verify *different* things (a compiler's semantic preservation, a
  kernel's functional correctness, a library's spec, a type system's soundness), so
  the eventual cost table must record *what* each proves alongside how much it cost.
- Measured sizes come from `PLSizes.md`, `SMTSizes.md`,
  `ProofsOfProgrammingLanguagesSizes.md`, and `SMTCheckVerificationAndTCBandVCB.md`;
  the OS/subsystem rows are drawn from the survey in
  `prompts/Formally Proven Operating Systems.txt` and are not yet tokei-measured here.
