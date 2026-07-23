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

- **In Product** — `Yes` if the verified artifact ships in a production product, else `No`.
- **LoEC** — Lines of Executable Code (the running implementation, or its definitions).
- **LoP** — Lines of Proof (the machine-checked correctness proof).

Plain numbers are measured in this repo (`ProofsOfProgrammingLanguagesSizes.md`,
`SMTCheckVerificationAndTCBandVCB.md`); `~` is a rough estimate; `—` is no published
figure; `none` marks a category with no verified example (the row is kept).

## 1. Semantics

| Semantics | Best proven example | In Product | LoEC | LoP |
|-----------|---------------------|:----------:|-----:|----:|
| Proof Automation | SMTCoq | No | ~5k | ~10k |
| SMT | CoqQFBV | No | ~16k | ~28k |
| Certificate Checker | cake_lpr | No | ~2k | ~8k |
| PL semantics framework | Iris | No | — | — |
| PL semantics proof | RustBelt | No | 7,492 | 9,920 |

## 2. PL

| PL | Best proven example | In Product | LoEC | LoP |
|----|---------------------|:----------:|-----:|----:|
| compiler | CompCert | Yes | 80,812 (+29,335 OCaml) | 89,813 |
| linker | CompCertELF | No | — | — |
| assembler | CompCertELF | No | — | — |
| package system | none | — | — | — |

## 3. Std Library

| Std Library | Best proven example | In Product | LoEC | LoP |
|-------------|---------------------|:----------:|-----:|----:|
| Core Library | CakeML `basis` | No | 10,650 | 12,887 |
| Alloc Library | VST `malloc` | No | ~1k | ~3k |
| Std Library | CakeML `basis` | No | 10,650 | 12,887 |
| Cryptography | HACL\*/EverCrypt | Yes | ~34k | ~132k |

## 4. OS

| OS | Best proven example | In Product | LoEC | LoP |
|----|---------------------|:----------:|-----:|----:|
| boot | DICE\* | No | — | — |
| OS kernel | seL4 | Yes | ~10k | ~762k |
| OS networking | EverParse | Yes | — | — |
| OS file system | FSCQ | No | ~3k | ~28k |
| OS driver system | none | — | — | — |
| Hypervisor | SeKVM | No | ~5k | ~30k |
| Firewall | EverParse | Yes | — | — |

## 4. Utilities

| Utilities | Best proven example | In Product | LoEC | LoP |
|-----------|---------------------|:----------:|-----:|----:|
| Base servers (DNS, ...) | none | — | — | — |
| Command Line Services | none | — | — | — |
| Intrustion Detection | none | — | — | — |

## 5. Application Stack

| Application Stack | Best proven example | In Product | LoEC | LoP |
|-------------------|---------------------|:----------:|-----:|----:|
| HTTP Server | none | — | — | — |
| In Memory DB | none | — | — | — |
| On Disk DB | none | — | — | — |
| Application Server | none | — | — | — |

## 6. Distributed Services

| Distributed Services | Best proven example | In Product | LoEC | LoP |
|----------------------|---------------------|:----------:|-----:|----:|
| Authentication | miTLS | No | — | — |
| Distributed Logging | none | — | — | — |
| Distributed FS | none | — | — | — |
| Key Value Store (S3) | IronFleet | No | ~4k | ~30k |
| Load Balancing | none | — | — | — |
| Distributed DB | IronFleet | No | ~4k | ~30k |
| Distributed Config | Verdi verdi-raft | No | ~5k | ~45k |
| Distributed Perf Monitoring | none | — | — | — |
| Revision Control (git) | none | — | — | — |

## 7. Proof of Programs (POP)

| POP | Best proven example | In Product | LoEC | LoP |
|-----|---------------------|:----------:|-----:|----:|
| Proof Assistant | Candle | No | ~2k | — |
