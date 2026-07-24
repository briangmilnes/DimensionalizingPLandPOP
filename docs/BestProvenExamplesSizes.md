<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Best Proven Examples — Sizes

For each category from `CostOfProvingEverything.md`, the single best **formally
verified** example, sized four ways. The point is to separate what we *have* proven
from what we still *owe*:

- **In Production** — `Yes` if the verified artifact ships in a production product, else `No`.
- **PLoEC** — Proven Lines of Executable Code: implementation covered by a proof.
- **LoP** — Lines of Proof discharging that code (proof plus the specification it meets).
- **UPLoEC** — Unproven Lines of Executable Code *inside* the proven system: the trusted
  glue, tools, and generators we could not find a proof of (CompCert's OCaml, Verus's verifier).
- **EstLoC2P** — Estimated Lines of Code to Prove: the executable size of a real,
  production-grade instance that is still unproven — what a full verification of the
  category would have to cover. `—` where a production-grade verified instance already
  exists (compiler, cryptography, OS kernel).

Total proof debt for a category is roughly **UPLoEC + EstLoC2P**. Plain numbers are
measured in this repo or by tokei on the cloned source (Iris, CompCertELF, Verus `vstd`);
`~` is an order-of-magnitude estimate; `—` is not applicable / no figure; `none` marks a
category with no verified example. Section and grand totals sum the numeric columns
(treating `~` as its value); they are approximate and, where one artifact serves two rows
(CakeML `basis`, IronFleet, CompCertELF), count it twice.

## 1. Semantics

Iris and CompCertELF, left as `—` before, are now measured: Iris is 45,458 lines of Coq
(the `iris` + `iris_heap_lang` mechanization of the framework — a logic, so no executable
code of its own).

| Semantics | Best proven example | In Production | PLoEC | LoP | UPLoEC | EstLoC2P |
|-----------|---------------------|:-------------:|------:|----:|-------:|---------:|
| Proof Automation | SMTCoq | No | ~5k | ~10k | ~13k | ~100k |
| SMT | CoqQFBV | No | ~16k | ~28k | ~39k | ~496k |
| Certificate Checker | cake_lpr | No | ~2k | ~8k | — | — |
| PL semantics framework | Iris | No | — | 45,458 | — | — |
| PL semantics proof | RustBelt | No | 7,492 | 9,920 | — | — |
| **Total** | | | **~30k** | **~101k** | **~52k** | **~596k** |

## 2. PL

CompCertELF (`github.com/CertiKOS/compcert`, branch `oopsla-arti`) is a full CompCert fork,
~181k Coq; its verified assembler + ELF encoder + linking increment over CompCert is ~15k
Coq (`elf/` 932, `encode/` 276, x86 `Asm`/`Elf` ~14,041). The linker and assembler rows
below are that one development, so their totals overlap.

| PL | Best proven example | In Production | PLoEC | LoP | UPLoEC | EstLoC2P |
|----|---------------------|:-------------:|------:|----:|-------:|---------:|
| compiler | CompCert | Yes | 80,812 | 89,813 | 29,335 (OCaml) | — |
| linker | CompCertELF | No | ~1k | ~5k | — | ~100k |
| assembler | CompCertELF | No | ~2k | ~13k | — | ~100k |
| package system | none | — | — | — | — | ~100k |
| **Total** | | | **~84k** | **~108k** | **~29k** | **~300k** |

## 3. Std Library

| Std Library | Best proven example | In Production | PLoEC | LoP | UPLoEC | EstLoC2P |
|-------------|---------------------|:-------------:|------:|----:|-------:|---------:|
| Core Library | CakeML `basis` | No | 10,650 | 12,887 | — | ~209k |
| Alloc Library | VST `malloc` | No | ~1k | ~3k | — | ~10k |
| Std Library | CakeML `basis` | No | 10,650 | 12,887 | — | ~1.1M |
| Cryptography | HACL\*/EverCrypt | Yes | ~34k | ~132k | — | — |
| **Total** | | | **~56k** | **~161k** | **—** | **~1.32M** |

## 4. OS

| OS | Best proven example | In Production | PLoEC | LoP | UPLoEC | EstLoC2P |
|----|---------------------|:-------------:|------:|----:|-------:|---------:|
| boot | DICE\* | No | — | — | — | ~100k |
| OS kernel | seL4 | Yes | ~10k | ~762k | — | — |
| OS networking | EverParse | Yes | — | — | — | ~1M |
| OS file system | FSCQ | No | ~3k | ~28k | — | ~100k |
| OS driver system | none | — | — | — | — | ~20M |
| Hypervisor | SeKVM | No | ~5k | ~30k | — | ~1M |
| Firewall | EverParse | Yes | — | — | — | ~50k |
| **Total** | | | **~18k** | **~820k** | **—** | **~22.4M** |

## 4. Utilities

| Utilities | Best proven example | In Production | PLoEC | LoP | UPLoEC | EstLoC2P |
|-----------|---------------------|:-------------:|------:|----:|-------:|---------:|
| Base servers (DNS, ...) | none | — | — | — | — | ~300k |
| Command Line Services | none | — | — | — | — | ~100k |
| Intrustion Detection | none | — | — | — | — | ~200k |
| **Total** | | | **—** | **—** | **—** | **~600k** |

## 5. Application Stack

| Application Stack | Best proven example | In Production | PLoEC | LoP | UPLoEC | EstLoC2P |
|-------------------|---------------------|:-------------:|------:|----:|-------:|---------:|
| HTTP Server | none | — | — | — | — | ~250k |
| In Memory DB | none | — | — | — | — | ~330k |
| On Disk DB | none | — | — | — | — | ~1.3M |
| Application Server | none | — | — | — | — | ~500k |
| **Total** | | | **—** | **—** | **—** | **~2.38M** |

## 6. Distributed Services

| Distributed Services | Best proven example | In Production | PLoEC | LoP | UPLoEC | EstLoC2P |
|----------------------|---------------------|:-------------:|------:|----:|-------:|---------:|
| Authentication | miTLS | No | — | — | — | ~100k |
| Distributed Logging | none | — | — | — | — | ~1.1M |
| Distributed FS | none | — | — | — | — | ~1M |
| Key Value Store (S3) | IronFleet | No | ~4k | ~30k | — | ~500k |
| Load Balancing | none | — | — | — | — | ~100k |
| Distributed DB | IronFleet | No | ~4k | ~30k | — | ~125k |
| Distributed Config | Verdi verdi-raft | No | ~5k | ~45k | — | ~50k |
| Distributed Perf Monitoring | none | — | — | — | — | ~100k |
| Revision Control (git) | none | — | — | — | — | ~250k |
| **Total** | | | **~13k** | **~105k** | **—** | **~3.33M** |

## 7. Proof of Programs (POP)

Verus is a *verifier* — trusted, not itself proven — so it contributes a large UPLoEC.
Its verified standard library `vstd` is 39,216 Rust lines, of which only ~1,650 are
executable (PLoEC); the rest (~37k) is specification and proof (LoP), ~11.7k of it in
explicit `proof`/`spec` function bodies. The verifier proper is ~231k Rust (includes
vendored rustc forks). EstLoC2P below is the size of production proof assistants
(Rocq/Lean/Isabelle) still unproven; precise Verus splits need Verus's `line_count` tool.

| POP | Best proven example | In Production | PLoEC | LoP | UPLoEC | EstLoC2P |
|-----|---------------------|:-------------:|------:|----:|-------:|---------:|
| Program Verifier | Verus (`vstd`) | No | ~2k | ~37k | ~231k | ~500k |
| **Total** | | | **~2k** | **~37k** | **~231k** | **~500k** |

## Total

Grand totals across all sections (approximate; the double-counting caveat applies).

| Section | PLoEC | LoP | UPLoEC | EstLoC2P |
|---------|------:|----:|-------:|---------:|
| 1. Semantics | ~30k | ~101k | ~52k | ~596k |
| 2. PL | ~84k | ~108k | ~29k | ~300k |
| 3. Std Library | ~56k | ~161k | — | ~1.32M |
| 4. OS | ~18k | ~820k | — | ~22.4M |
| 4. Utilities | — | — | — | ~600k |
| 5. Application Stack | — | — | — | ~2.38M |
| 6. Distributed Services | ~13k | ~105k | — | ~3.33M |
| 7. POP | ~2k | ~37k | ~231k | ~500k |
| **Total** | **~200k** | **~1.33M** | **~312k** | **~31M** |

Reading the total. We have proven roughly **200k lines of executable code** with roughly
**1.33M lines of proof** (a ~6.6:1 proof-to-code ratio, dominated by seL4's ~762k). Inside
those proven systems, ~**312k lines of executable code remain trusted-but-unproven**
(UPLoEC — mostly Verus's verifier, CompCert's OCaml, and the SMT-checker glue). And to
carry proof to production-grade instances of every category costs an estimated **~31M more
lines of executable code to prove** (EstLoC2P), ~20M of it Linux's driver tree alone, with
whole tiers — Utilities, Application Stack, most Distributed Services — sitting at zero
proven today. Total remaining proof debt (UPLoEC + EstLoC2P) is on the order of **~31M
lines**, against the ~200k we have proven so far: we have formally verified well under one
percent of "everything."
