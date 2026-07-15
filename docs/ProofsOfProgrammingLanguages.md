<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Proofs of Programming Languages

This catalogs, for each of the thirteen programming languages dimensionalized in
`ThirteenPLs.md`, whether its implementation has been mechanically proven correct:
a verified compiler, interpreter, or runtime, and any verified libraries written in
or for the language. The object here is the toolchain and its proof, not the language
design and not the verification systems themselves (those are in
`ProofsOfProgramsSystems.md`).

The flagship is **CompCert**: a formally verified optimizing C compiler whose
correctness — a semantic-preservation theorem stating that the generated assembly
behaves as the C source semantics prescribes — is proved end to end in Rocq (Coq).
CompCert dominates this dimension because it is a proof about a production-scale
optimizing compiler for a real language subset, not a proof about a small model. The
other major point is **CakeML**: a verified compiler *and* runtime (including a
generational copying garbage collector and a bignum library) for an ML dialect close
to Standard ML, proved in HOL4 and bootstrapped inside the logic down to concrete
machine code for five architectures.

Most of the thirteen have no verified compiler. The honest distinctions this table
draws are: a **verified compiler or implementation** of the real language or a defined
subset; a **mechanized formal semantics** with type-safety metatheory but no verified
implementation; only **verified libraries or programs** written in the language while
the toolchain remains trusted; and **none**. Mechanized semantics is a real result but
is not a verified compiler, and this document does not conflate the two.

The **Extent** column uses this vocabulary: `compiler` (a verified compiler or
interpreter, of the full language or a stated subset), `subset` (a verified compiler
for a proper subset only), `semantics` (mechanized formal semantics and/or type-safety
proof, no verified implementation), `library-only` (verified libraries or programs, the
compiler unverified), and `none`.

## The Thirteen

| Language | Verified implementation | Prover | Extent | Verified libraries / notes |
|----------|-------------------------|--------|--------|----------------------------|
| Python | none | — | none | No verified implementation and no notable verified library. Partial mechanized-semantics fragments exist; PyPy/RPython are not verified. |
| C | CompCert | Rocq (Coq) | compiler | VST (separation-logic verification of C source, Rocq); seL4 (verified OS kernel written in C, Isabelle — a verified program, not a compiler); HACL\*/EverCrypt and Fiat-Crypto emit verified C. |
| C++ | none (semantics only) | Isabelle/HOL | semantics | Operational semantics with a multiple-inheritance type-safety proof (Wasserrab et al.); the C++11 concurrency memory model was mechanized (Batty et al.). No verified compiler. |
| Java | Jinja / JinjaThreads | Isabelle/HOL | subset | Verified non-optimizing source-to-bytecode compiler for a Java subset, plus a verified bytecode verifier and a type-safe multithreaded model under the Java memory model. |
| C# | none | — | none | Subset formalizations of C#/CLR exist; no verified compiler or notable verified library. |
| JS | JSCert + JSRef; KJS | Rocq (Coq); K | semantics | JSCert is a Coq-mechanized ECMAScript semantics with JSRef, a reference interpreter extracted to OCaml and proved correct against it; KJS is a complete executable semantics in the K framework. Mechanized semantics, not a verified production engine. |
| TS | Safe TypeScript | on-paper proof | semantics | Sound gradual type system for a TypeScript subset with a formal soundness treatment (Rastogi et al.); a type-system result, not a verified compiler. |
| Rust | RustBelt | Iris / Rocq (Coq) | semantics | Machine-checked semantic soundness (memory and thread safety) for a λ-calculus model of Rust and several unsafe-using stdlib APIs. Aeneas/Charon translate safe Rust to functional models for proof; Miri is an unverified interpreter. No verified rustc. |
| Lisp | VLISP (Scheme) | rigorous denotational (not machine-checked) | compiler | Verified Scheme-to-bytecode compiler plus a verified byte-code interpreter, based on the Clinger–Rees denotational semantics; the proofs are rigorous but not mechanized. ACL2 is a prover built on an applicative Common Lisp subset. |
| Haskell | none | Rocq (Coq) | semantics + library-only | hs-to-coq / CoreSpec: a formal semantics and type-soundness proof for GHC Core, and verification of subsets of `base` and `containers` (Map, Set, IntSet). No verified GHC. |
| SML | CakeML | HOL4 | compiler | Verified compiler and runtime for an ML dialect close to SML, bootstrapped to machine code, with a verified generational GC and bignum library. Standard ML also has mechanized definitions and type-safety proofs of its semantics. |
| OCaml | none (semantics fragment) | Rocq (Coq) | semantics | Osiris (OLang) mechanizes a sequential OCaml fragment with Iris-based program logics; coq-of-ocaml and Cameleer add proof/verification tooling. No verified OCaml compiler. |
| OxCaml | none | — | none | Jane Street's OCaml extension; no verified implementation. Inherits OCaml's unverified compiler and the fragment-level semantics work above. |

## Notes

CompCert is the standout of this dimension, and the reason is specific: its theorem
covers a multi-pass *optimizing* compiler for a large subset of C99 (Clight) targeting
ARM, PowerPC, RISC-V, x86, and x86-64, with each pass proved to preserve the program's
observable behavior. The formally verified passes are written and proved in Rocq
(Calculus of Inductive Constructions); the trusted base is small (the Rocq kernel, the
C and assembly semantics, and a little unverified glue). It is used for high-assurance
C and is the reference example of an end-to-end verified compiler. Led by Xavier Leroy
at INRIA, begun in 2005.

CakeML is the functional-language counterpart and, unlike CompCert, verifies the
*runtime* as well as the compiler. Its backend has twelve intermediate languages, the
whole development lives in HOL4, and it is bootstrapped inside the logic so the output
is verified concrete machine code; the emitted runtime includes a verified generational
copying garbage collector and verified arbitrary-precision arithmetic. Its source
language is an ML dialect closely related to, but not identical to, Standard ML.

The C entry is the richest ecosystem. Beyond CompCert as the verified compiler, three
distinct kinds of artifact sit around C: VST proves properties of C *source* via
separation logic in Rocq (and connects to CompCert's semantics); seL4 is a verified OS
kernel *written in* C, proved in Isabelle — a verified program, with the C-to-binary
step handled by a separate translation-validation argument, not a proof that a C
compiler is correct in general; and HACL\*, EverCrypt, and Fiat-Crypto *generate*
verified C from proofs done in F\* or Rocq.

Several rows are `semantics`, and the distinction matters. JSCert/JSRef, KJS, RustBelt,
Safe TypeScript, the C++ memory-model work, and the OCaml OLang fragment are mechanized
semantics or type-soundness results. They prove things about a model of the language;
none of them is a proof that the language's shipping compiler or engine is correct.
RustBelt in particular proves the *type system* sound (including specific unsafe
libraries), not that rustc compiles correctly. Reporting any of these as a "verified
compiler" would be an overstatement.

The Java entry is a genuine verified compiler but for a subset: Jinja and its successor
JinjaThreads (Andreas Lochbihler, building on Nipkow's group) verify a non-optimizing
compiler from a Java-source subset to bytecode, with the correctness proof guaranteeing
identical observable behavior even for nonterminating executions and under the Java
memory model.

VLISP occupies a middle position: it produced a verified compiler and interpreter for
Scheme (based on the Scheme48/PreScheme implementation and the Clinger–Rees denotational
semantics), but the proofs were done in rigorous mathematical style rather than checked
by a proof assistant, so its assurance level differs from CompCert's or CakeML's.

Verified libraries, distinct from verified compilers, are the other half of this
landscape. The largest deployed body of verified code is cryptographic: **HACL\*** is a
verified cryptographic library written in F\* and compiled to C (Curve25519, Ed25519,
AES-GCM, ChaCha20, Poly1305, SHA-2/3, HMAC, HKDF), and **EverCrypt** combines it with
**ValeCrypt** (verified assembly); this code is deployed in Firefox's NSS, the Linux
kernel, mbedTLS, and elsewhere. **Fiat-Crypto** generates verified field arithmetic
from Rocq specifications to C (used in BoringSSL). On the functional side, hs-to-coq
verified subsets of Haskell's `base` and `containers`, and CakeML and CompCert carry
their own verified supporting developments.

## Secondary: closely related verified artifacts

Two intermediate representations outside the thirteen shape this landscape and are worth
listing because verified compilers target or model them:

- **WebAssembly** — WasmCert-Coq and WasmCert-Isabelle are mechanized specifications of
  the Wasm 1.0 semantics with type-soundness proofs; WasmCert-Isabelle includes a
  verified executable interpreter. Wasm's compact official formal semantics makes these
  unusually complete and close to the standard.
- **LLVM IR** — Vellvm (Verified LLVM, University of Pennsylvania, DeepSpec) is a Rocq
  formalization of the semantics of a subset of LLVM IR, including a low-level memory
  model and an executable interpreter, used to verify LLVM-based program transformations.

## Sources

- CompCert — https://compcert.org/ , https://en.wikipedia.org/wiki/CompCert , https://arxiv.org/pdf/2201.10280 (trusted computing base)
- CakeML compiler backend — https://cakeml.org/ , https://trustworthy.systems/publications/abstracts/Tan_MKFON_19.abstract
- CakeML verified generational garbage collector — https://cakeml.org/itp17.pdf
- Jinja / JinjaThreads — https://link.springer.com/article/10.1007/s10817-018-9452-x , http://www.andreas-lochbihler.de/pub/lochbihler2018jar.pdf
- RustBelt — https://plv.mpi-sws.org/rustbelt/ , https://iris-project.org/pdfs/2021-rustbelt-cacm-final.pdf
- Aeneas / Charon — https://github.com/AeneasVerif/aeneas , https://github.com/AeneasVerif/charon
- JSCert / JSRef — https://dl.acm.org/doi/abs/10.1145/2535838.2535876
- KJS (K framework) — https://pi2labs.org/papers/kjs-formal-semantics-javascript
- Safe TypeScript — https://dl.acm.org/doi/10.1145/2676726.2676971 , https://goto.ucsd.edu/~pvekris/docs/safets.pdf
- VLISP — https://link.springer.com/article/10.1007/BF01128406 , https://link.springer.com/article/10.1007/BF01128407
- hs-to-coq / CoreSpec — https://github.com/antalsz/hs-to-coq , https://www.cis.upenn.edu/~plclub/blog/2020-10-09-hs-to-coq/
- OCaml semantics (Osiris / OLang) — https://iris-project.org/pdfs/2025-icfp-osiris.pdf ; coq-of-ocaml — https://github.com/formal-land/coq-of-ocaml
- C++ semantics — https://ics.uci.edu/~lopes/teaching/inf212W12/readings/wasserrab.pdf (multiple-inheritance type safety); C++11 memory model (Batty et al.)
- HACL\* / EverCrypt — https://github.com/hacl-star/hacl-star , https://hacl-star.github.io/ , https://hacl-star.github.io/Applications.html
- Fiat-Crypto — referenced via HACL\* overview; https://hacl-star.github.io/Overview.html
- VST — https://vst.cs.princeton.edu/ ; seL4 — https://sel4.systems/
- Vellvm — https://github.com/vellvm/vellvm , https://www.cis.upenn.edu/~stevez/vellvm/ , https://dl.acm.org/doi/10.1145/3473572
- WasmCert — https://hal.science/hal-03353748 , https://github.com/WasmCert/WasmCert-Isabelle
