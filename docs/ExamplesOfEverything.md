<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Examples of Everything

This document mirrors the sections and rows of `CostOfProvingEverything.md` and, for
each category, names a concrete instance on two axes of assurance: the best
**formally verified** instance (a machine-checked proof discharges a specification)
and the best **unverified** production instance. The **LOC estimate** column gives the
order-of-magnitude size of a real instance of the category, not of either named
example specifically.

Two sourcing rules apply. Verified figures are the tokei **Code** measurements already
recorded in this repository and are cited to the measuring document
(`PLSizes.md`, `SMTSizes.md`, `SMTCheckVerificationAndTCBandVCB.md`,
`ProofsOfProgrammingLanguagesSizes.md`, `ProofsOfProgrammingLanguages.md`,
`ProofsOfProgramsSystems.md`); they are exact line counts, given without a `~`.
Unverified figures are order-of-magnitude counts from public code-size reports (Open
Hub, project sites) and carry a `~`. A cell reads `none` where no formally verified
instance exists, and `—` where no defensible size figure is available. Several
verified entries are research systems not measured in this repository (FSCQ, SeKVM,
miTLS, Verdi, Candle); they are named and marked as research rather than reported as
`none`, because a verified instance genuinely exists.

## 1. Semantics

| Semantics | LOC estimate | Best proven example | Best unproven example |
|-----------|--------------|---------------------|-----------------------|
| Proof Automation | ~10k–500k | SMTCoq — verified SMT-based reflexive proof automation for Rocq, 22,231 verified theories (`SMTCheckVerificationAndTCBandVCB.md`) | Sledgehammer / CoqHammer / Ltac — unverified tactic and hammer automation, bundled in the host prover (—) |
| SMT | ~350k–500k | CoqQFBV — certified QF_BV solver-and-checker extracted from Rocq, 43,635; decides QF_BV only, not full SMT (`SMTCheckVerificationAndTCBandVCB.md`) | Z3 — ~496,337 C++ (`SMTSizes.md`) |
| Certificate Checker | ~10k–22k | SMTCoq reflexive checker, 15,133 Rocq; cake_lpr 10,071 HOL4 (proof reaches emitted machine code) (`SMTCheckVerificationAndTCBandVCB.md`) | Carcara — unverified Alethe checker, ~22,420 Rust (`SMTCheckVerificationAndTCBandVCB.md`) |
| PL semantics framework | ~10k–100k | Iris — higher-order concurrent separation-logic framework mechanized in Rocq; trusted base is the Rocq kernel (`ProofsOfProgramsSystems.md`) | K framework — executable-semantics framework (KJS, C semantics); unverified engine (`ProofsOfProgrammingLanguages.md`) |
| PL semantics proof | ~15k–30k | RustBelt — semantic soundness of a λ-calculus model of Rust, 17,411 Rocq/Iris; JSCert ECMAScript semantics 17,122; Vellvm LLVM-IR 27,777 (`ProofsOfProgrammingLanguagesSizes.md`) | The Definition of Standard ML / the ISO C and C++ standards — rigorous prose semantics, not machine-checked (—) |

## 2. PL

| PL | LOC estimate | Best proven example | Best unproven example |
|----|--------------|---------------------|-----------------------|
| compiler | ~2×10⁵–10⁷ | CompCert — verified optimizing C compiler, 206,904 (170,633 Rocq proof + 29,335 OCaml) (`PLSizes.md`, `ProofsOfProgrammingLanguagesSizes.md`) | GCC — ~14.5M lines; Clang+LLVM ~4.36M (`PLSizes.md`) |
| linker | ~50k–150k | none — CompCert's theorem stops at assembly and trusts the linker; CompCertELF research extends verification through assembling and linking | GNU ld / LLVM lld — ~10⁵, part of binutils / LLVM |
| assembler | ~20k–100k | none — CompCert emits assembly text and trusts the system assembler; CompCertELF research verifies the encode-and-assemble step | GNU as (gas) — ~10⁵, part of binutils |
| debugger | ~1M | none | GDB — ~1M+, part of the binutils-gdb tree |
| test tools | ~1k–100k | none | Google Test / LLVM lit / DejaGnu (—) |
| performance tools | ~10⁵–10⁶ | none | Valgrind / Linux perf (~10⁵–10⁶) |
| package system | ~10k–200k | none | Cargo / npm (~10⁵) |

## 3. Std Library

| Std Library | LOC estimate | Best proven example | Best unproven example |
|-------------|--------------|---------------------|-----------------------|
| Core Library | ~24k–200k | CakeML `basis` — verified base library, 24,006 HOL4 (`PLSizes.md`, `ProofsOfProgrammingLanguagesSizes.md`) | Rust `core`+`alloc`+`std` — ~208,981 (`PLSizes.md`) |
| Alloc Library | ~1k–50k | none in production — VST verifies a `malloc`/`free` implementation in Rocq as a research case study | Rust `alloc` / glibc `malloc` / jemalloc — ~10⁴, part of the base library above |
| Std Library | ~200k–1.1M | CakeML `basis`, 24,006 (the only fully verified standard library); HACL\*/EverCrypt verifies the crypto library, 162,492 F\* (`ProofsOfProgrammingLanguagesSizes.md`) | glibc — ~1,104,158 C (`PLSizes.md`) |

## 4. OS

| OS | LOC estimate | Best proven example | Best unproven example |
|----|--------------|---------------------|-----------------------|
| boot | ~50k–500k | none — verified-bootloader work is research-only | GRUB / U-Boot (~10⁵) |
| OS kernel | ~10⁴ kernel C / ~10⁷ monolithic | seL4 — functional-correctness proof, l4v 803,647 Isabelle over a ~10k-line kernel C (`ProofsOfProgrammingLanguagesSizes.md`) | Linux — ~40M lines (2024) |
| OS networking | ~1M+ | none in production — verified TCP/IP stacks are research | Linux `net/` stack / lwIP (~10⁶) |
| OS file system | ~30k verified / ~10⁵ production | FSCQ — certified crash-safe file system in Rocq, ~30,000 lines (research, not in repo docs) | Linux ext4 + VFS (~10⁵) |
| OS driver system | ~2×10⁷ | none | Linux `drivers/` — the majority of the ~40M-line kernel tree |
| Hypervisor | ~50k–1M | SeKVM — verified core of a KVM hypervisor (research, not in repo docs); otherwise none in production | KVM / Xen (~10⁵–10⁶) |
| Firewall | ~20k–100k | none | Linux netfilter (iptables/nftables) / OpenBSD pf (—) |

## 4. Utilities

| Utilities | LOC estimate | Best proven example | Best unproven example |
|-----------|--------------|---------------------|-----------------------|
| Base servers (DNS, ...) | ~100k–500k | none | BIND9 — reference DNS implementation (~ several hundred k); Knot DNS |
| Command Line Services | ~100k | none in production — verified-coreutils work is research | GNU coreutils — ~97,567 |
| Intrustion Detection | ~200k–500k | none | Snort / Suricata (~10⁵) |

## 5. Application Stack

| Application Stack | LOC estimate | Best proven example | Best unproven example |
|-------------------|--------------|---------------------|-----------------------|
| HTTP Server | ~250k | none in production — verified HTTP-parser fragments exist as research | nginx — ~250,000 |
| In Memory DB | ~330k | none | Redis — ~329,658 C |
| On Disk DB | ~156k–1.3M | none in production — verified storage/DB work is research | PostgreSQL — ~1.3M; SQLite ~155,800 |
| Application Server | ~10⁵–10⁶ | none | Apache Tomcat / Node.js (—) |

## 6. Distributed Services

| Distributed Services | LOC estimate | Best proven example | Best unproven example |
|----------------------|--------------|---------------------|-----------------------|
| Authentication       | ~50k–500k | miTLS — verified TLS 1.3 in F\*, Project Everest (research; handshake proof left incomplete) | OpenSSL / Kerberos / an OAuth server (~10⁵) |
| Distributed Logging  | ~1.1M | none | Apache Kafka — ~1,119,998 (Java) |
| Distributed FS       | ~1M+ | none | Ceph / HDFS (~10⁶) |
| Key Value Store (S3) | ~10⁵–10⁶ | none in production — Verdi and IronFleet verify small key-value stores as research | etcd / Cassandra / Amazon S3 (—) |
| Load Balancing       | ~50k–200k | none | HAProxy / nginx (~10⁵) |
| Distributed DB       | ~125k+ Go | none in production — IronFleet verifies a replicated state machine / Paxos KV store in Dafny (research, not a full SQL DB) | CockroachDB — ~125,000 non-generated Go; Cassandra; Spanner |
| Distributed Config   | ~10k–50k | Verdi verdi-raft — Raft consensus and a fault-tolerant key-value store verified in Rocq (research, not production) | ZooKeeper / etcd (—) |
| Distributed Perf Monitoring | ~10⁵–10⁶ | none | Prometheus (~10⁵) |
| Revision Control (git) | ~1.3M | none | git — ~1.3M whole tree (core C ~250k) |

## 7. Proof of Programs (POP) 

| POP | LOC estimate | Best proven example | Best unproven example |
|-----|--------------|---------------------|-----------------------|
| Proof Assistant | ~2k kernel / ~10⁵–10⁶ whole | Candle — verified HOL Light implemented in CakeML, soundness proved down to machine code (research); the trusted kernels alone measure HOL4 2,210, Rocq 30,411 (`SMTCheckVerificationAndTCBandVCB.md`) | Rocq (Coq) / Lean 4 / Isabelle / HOL4 — unverified proof assistants with small trusted kernels (`ProofsOfProgramsSystems.md`) (~10⁵–10⁶) |
