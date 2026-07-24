<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Best Proven Examples — Sizes

For each category from `CostOfProvingEverything.md`, the single best **formally
verified** example, split three ways:

- **In Production** — `Yes` if the verified artifact ships in a production product, else `No`.
- **PLoEC** — Proven Lines of Executable Code: implementation covered by the proof.
- **LoP** — Lines of Proof: the machine-checked proof (and the specification it discharges).
- **UPLoEC** — Unproven Lines of Executable Code: code the system needs but that is *not*
  proven — the trusted glue, tools, and generators we could not find proofs of.

Plain numbers are measured in this repo (`ProofsOfProgrammingLanguagesSizes.md`,
`SMTCheckVerificationAndTCBandVCB.md`, and a tokei/heuristic count of Verus `vstd`);
`~` is a rough estimate; `—` is no published figure; `none` marks a category with no
verified example. Section totals sum the numeric columns (treating `~` as its value,
skipping `—`) and are approximate; where one artifact is the best example for two rows
(CakeML `basis`, IronFleet) the total counts it twice.

## 1. Semantics

| Semantics | Best proven example | In Production | PLoEC | LoP | UPLoEC |
|-----------|---------------------|:-------------:|------:|----:|-------:|
| Proof Automation | SMTCoq | No | ~5k | ~10k | ~13k |
| SMT | CoqQFBV | No | ~16k | ~28k | ~39k |
| Certificate Checker | cake_lpr | No | ~2k | ~8k | — |
| PL semantics framework | Iris | No | — | — | — |
| PL semantics proof | RustBelt | No | 7,492 | 9,920 | — |
| **Total** | | | **~30k** | **~56k** | **~52k** |

## 2. PL

| PL | Best proven example | In Production | PLoEC | LoP | UPLoEC |
|----|---------------------|:-------------:|------:|----:|-------:|
| compiler | CompCert | Yes | 80,812 | 89,813 | 29,335 (OCaml) |
| linker | CompCertELF | No | — | — | — |
| assembler | CompCertELF | No | — | — | — |
| package system | none | — | — | — | — |
| **Total** | | | **~81k** | **~90k** | **~29k** |

## 3. Std Library

| Std Library | Best proven example | In Production | PLoEC | LoP | UPLoEC |
|-------------|---------------------|:-------------:|------:|----:|-------:|
| Core Library | CakeML `basis` | No | 10,650 | 12,887 | — |
| Alloc Library | VST `malloc` | No | ~1k | ~3k | — |
| Std Library | CakeML `basis` | No | 10,650 | 12,887 | — |
| Cryptography | HACL\*/EverCrypt | Yes | ~34k | ~132k | — |
| **Total** | | | **~56k** | **~161k** | **—** |

## 4. OS

| OS | Best proven example | In Production | PLoEC | LoP | UPLoEC |
|----|---------------------|:-------------:|------:|----:|-------:|
| boot | DICE\* | No | — | — | — |
| OS kernel | seL4 | Yes | ~10k | ~762k | — |
| OS networking | EverParse | Yes | — | — | — |
| OS file system | FSCQ | No | ~3k | ~28k | — |
| OS driver system | none | — | — | — | — |
| Hypervisor | SeKVM | No | ~5k | ~30k | — |
| Firewall | EverParse | Yes | — | — | — |
| **Total** | | | **~18k** | **~820k** | **—** |

## 4. Utilities

| Utilities | Best proven example | In Production | PLoEC | LoP | UPLoEC |
|-----------|---------------------|:-------------:|------:|----:|-------:|
| Base servers (DNS, ...) | none | — | — | — | — |
| Command Line Services | none | — | — | — | — |
| Intrustion Detection | none | — | — | — | — |
| **Total** | | | **—** | **—** | **—** |

## 5. Application Stack

| Application Stack | Best proven example | In Production | PLoEC | LoP | UPLoEC |
|-------------------|---------------------|:-------------:|------:|----:|-------:|
| HTTP Server | none | — | — | — | — |
| In Memory DB | none | — | — | — | — |
| On Disk DB | none | — | — | — | — |
| Application Server | none | — | — | — | — |
| **Total** | | | **—** | **—** | **—** |

## 6. Distributed Services

| Distributed Services | Best proven example | In Production | PLoEC | LoP | UPLoEC |
|----------------------|---------------------|:-------------:|------:|----:|-------:|
| Authentication | miTLS | No | — | — | — |
| Distributed Logging | none | — | — | — | — |
| Distributed FS | none | — | — | — | — |
| Key Value Store (S3) | IronFleet | No | ~4k | ~30k | — |
| Load Balancing | none | — | — | — | — |
| Distributed DB | IronFleet | No | ~4k | ~30k | — |
| Distributed Config | Verdi verdi-raft | No | ~5k | ~45k | — |
| Distributed Perf Monitoring | none | — | — | — | — |
| Revision Control (git) | none | — | — | — | — |
| **Total** | | | **~13k** | **~105k** | **—** |

## 7. Proof of Programs (POP)

Verus is a *verifier* — trusted, not itself proven — so it contributes a large UPLoEC.
Its verified standard library `vstd` is 39,216 Rust lines, of which only ~1,650 are
executable (PLoEC); the remaining ~37k are specification and proof (LoP), ~11.7k of it
in explicit `proof`/`spec` function bodies. The verifier proper is ~231k Rust (includes
vendored rustc forks). Precise Verus proof/exec splits need Verus's own `line_count`
tool; the figures here are a heuristic count.

| POP | Best proven example | In Production | PLoEC | LoP | UPLoEC |
|-----|---------------------|:-------------:|------:|----:|-------:|
| Program Verifier | Verus (`vstd`) | No | ~2k | ~37k | ~231k |
| **Total** | | | **~2k** | **~37k** | **~231k** |

## Total

Grand totals across all sections (approximate; the same double-counting caveat applies).

| Section | PLoEC | LoP | UPLoEC |
|---------|------:|----:|-------:|
| 1. Semantics | ~30k | ~56k | ~52k |
| 2. PL | ~81k | ~90k | ~29k |
| 3. Std Library | ~56k | ~161k | — |
| 4. OS | ~18k | ~820k | — |
| 4. Utilities | — | — | — |
| 5. Application Stack | — | — | — |
| 6. Distributed Services | ~13k | ~105k | — |
| 7. POP | ~2k | ~37k | ~231k |
| **Total** | **~200k** | **~1.27M** | **~312k** |

Reading the total: across the best verified examples we have, roughly **200k lines of
proven executable code** rest on roughly **1.27M lines of proof** (a ~6:1 proof-to-code
ratio, dominated by seL4's ~762k), while roughly **312k lines of executable code remain
unproven** (UPLoEC — mostly the Verus verifier, CompCert's OCaml, and the SMT-checker
glue). Whole tiers — Utilities, Application Stack, most Distributed Services — contribute
nothing to any column: the majority of "everything" has no verified example at all.
