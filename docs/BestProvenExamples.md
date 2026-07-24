<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Best Proven Examples

For each category from `CostOfProvingEverything.md`, the single best **formally
verified** example.

- **In Production** — `Yes` if the verified artifact ships in a production product, else `No`.
- **LoEC** — Lines of Executable Code (the running implementation, or its definitions).
- **LoP** — Lines of Proof (the machine-checked correctness proof).

Plain numbers are measured in this repo (`ProofsOfProgrammingLanguagesSizes.md`,
`SMTCheckVerificationAndTCBandVCB.md`); `~` is a rough estimate; `—` is no published
figure; `none` marks a category with no verified example (the row is kept). **Section
totals** sum the numeric LoEC/LoP (treating `~` as its value, skipping `—`) and are
approximate; where one artifact is the best example for two rows (CakeML `basis`,
IronFleet) the total counts it twice.

## 1. Semantics

| Semantics | Best proven example | In Production | LoEC | LoP |
|-----------|---------------------|:-------------:|-----:|----:|
| Proof Automation | SMTCoq | No | ~5k | ~10k |
| SMT | CoqQFBV | No | ~16k | ~28k |
| Certificate Checker | cake_lpr | No | ~2k | ~8k |
| PL semantics framework | Iris | No | — | — |
| PL semantics proof | RustBelt | No | 7,492 | 9,920 |
| **Total** | | | **~30k** | **~56k** |

## 2. PL

| PL | Best proven example | In Production | LoEC | LoP |
|----|---------------------|:-------------:|-----:|----:|
| compiler | CompCert | Yes | 80,812 (+29,335 OCaml) | 89,813 |
| linker | CompCertELF | No | — | — |
| assembler | CompCertELF | No | — | — |
| package system | none | — | — | — |
| **Total** | | | **~81k (+29k OCaml)** | **~90k** |

## 3. Std Library

| Std Library | Best proven example | In Production | LoEC | LoP |
|-------------|---------------------|:-------------:|-----:|----:|
| Core Library | CakeML `basis` | No | 10,650 | 12,887 |
| Alloc Library | VST `malloc` | No | ~1k | ~3k |
| Std Library | CakeML `basis` | No | 10,650 | 12,887 |
| Cryptography | HACL\*/EverCrypt | Yes | ~34k | ~132k |
| **Total** | | | **~56k** | **~161k** |

## 4. OS

| OS | Best proven example | In Production | LoEC | LoP |
|----|---------------------|:-------------:|-----:|----:|
| boot | DICE\* | No | — | — |
| OS kernel | seL4 | Yes | ~10k | ~762k |
| OS networking | EverParse | Yes | — | — |
| OS file system | FSCQ | No | ~3k | ~28k |
| OS driver system | none | — | — | — |
| Hypervisor | SeKVM | No | ~5k | ~30k |
| Firewall | EverParse | Yes | — | — |
| **Total** | | | **~18k** | **~820k** |

## 4. Utilities

| Utilities | Best proven example | In Production | LoEC | LoP |
|-----------|---------------------|:-------------:|-----:|----:|
| Base servers (DNS, ...) | none | — | — | — |
| Command Line Services | none | — | — | — |
| Intrustion Detection | none | — | — | — |
| **Total** | | | **—** | **—** |

## 5. Application Stack

| Application Stack | Best proven example | In Production | LoEC | LoP |
|-------------------|---------------------|:-------------:|-----:|----:|
| HTTP Server | none | — | — | — |
| In Memory DB | none | — | — | — |
| On Disk DB | none | — | — | — |
| Application Server | none | — | — | — |
| **Total** | | | **—** | **—** |

## 6. Distributed Services

| Distributed Services | Best proven example | In Production | LoEC | LoP |
|----------------------|---------------------|:-------------:|-----:|----:|
| Authentication | miTLS | No | — | — |
| Distributed Logging | none | — | — | — |
| Distributed FS | none | — | — | — |
| Key Value Store (S3) | IronFleet | No | ~4k | ~30k |
| Load Balancing | none | — | — | — |
| Distributed DB | IronFleet | No | ~4k | ~30k |
| Distributed Config | Verdi verdi-raft | No | ~5k | ~45k |
| Distributed Perf Monitoring | none | — | — | — |
| Revision Control (git) | none | — | — | — |
| **Total** | | | **~13k** | **~105k** |

## 7. Proof of Programs (POP)

Verus is a *verifier*, not a proof assistant, and — like an SMT solver — it is
trusted, not itself proven, so its own LoP is `—`; its verified standard library
`vstd` is ~39k Rust. LoEC ~231k is the verifier source (Rust; includes vendored rustc
forks). The alternative reading — the LoEC/LoP of a program *verified with* Verus — is
project-specific (e.g. Atmosphere ~7.5:1 proof-to-code, VeriSMo ~2:1).

| POP | Best proven example | In Production | LoEC | LoP |
|-----|---------------------|:-------------:|-----:|----:|
| Program Verifier | Verus | No | ~231k | — |
| **Total** | | | **~231k** | **—** |
