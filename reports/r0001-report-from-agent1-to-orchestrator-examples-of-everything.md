---
round: r0001
from: agent1
to: orchestrator
subject: examples-of-everything
date: 2026-0721-16:31
started: 2026-0721-16:25
finished: 2026-0721-16:31
related: plans/r0001-plan-from-orchestrator-to-agent1-examples-of-everything.md
---

# Report: docs/ExamplesOfEverything.md

## Deliverable

`docs/ExamplesOfEverything.md` is written. It keeps the leading 95%-width `<style>`
block and mirrors the eight numbered section headings of `CostOfProvingEverything.md`
**exactly as they currently stand**, including the duplicated `## 4.` (both `## 4. OS`
and `## 4. Utilities`) and the source file's original spellings (`Intrustion
Detection`). Each one-column table is expanded to
`| <Category> | LOC estimate | Best proven example | Best unproven example |`.

## Row set mirrored

Taken verbatim from `docs/CostOfProvingEverything.md`:

- **1. Semantics** — Proof Automation; SMT; Certificate Checker; PL semantics framework; PL semantics proof
- **2. PL** — compiler; linker; assembler; debugger; test tools; performance tools; package system
- **3. Std Library** — Core Library; Alloc Library; Std Library
- **4. OS** — boot; OS kernel; OS networking; OS file system; OS driver system; Hypervisor; Firewall
- **4. Utilities** — Base servers (DNS, ...); Command Line Services; Intrustion Detection
- **5. Application Stack** — HTTP Server; In Memory DB; On Disk DB; Application Server
- **6. Distributed Services** — Authentication; Distributed Logging; Distributed FS; Key Value Store (S3); Load Balancing; Distributed DB; Distributed Config; Distributed Perf Monitoring; Revision Control (git)
- **7. Proof of Programs (POP)** — Proof Assistant

## Proven examples, and which repo doc each came from

Exact tokei Code figures reused from this repository:

- CompCert 206,904 (compiler) — `PLSizes.md`, `ProofsOfProgrammingLanguagesSizes.md`
- CakeML `basis` 24,006 (Core/Std Library) — `PLSizes.md`, `ProofsOfProgrammingLanguagesSizes.md`
- HACL\*/EverCrypt 162,492 (verified crypto library) — `ProofsOfProgrammingLanguagesSizes.md`
- seL4 l4v 803,647 (OS kernel) — `ProofsOfProgrammingLanguagesSizes.md`
- RustBelt 17,411 / JSCert 17,122 / Vellvm 27,777 (PL semantics proof) — `ProofsOfProgrammingLanguagesSizes.md`
- CoqQFBV 43,635 (verified QF_BV solver+checker, SMT row) — `SMTCheckVerificationAndTCBandVCB.md`
- SMTCoq reflexive checker 15,133; all verified theories 22,231 (Certificate Checker, Proof Automation) — `SMTCheckVerificationAndTCBandVCB.md`
- cake_lpr 10,071 (Certificate Checker) — `SMTCheckVerificationAndTCBandVCB.md`
- HOL4 kernel 2,210; Rocq kernel 30,411 (Proof Assistant trusted cores) — `SMTCheckVerificationAndTCBandVCB.md`
- Iris; K framework; Rocq/Lean/Isabelle/HOL4 named as systems — `ProofsOfProgramsSystems.md`, `ProofsOfProgrammingLanguages.md`

Verified **research** systems named where a verified instance genuinely exists but is
not measured in this repo (marked "research" in the doc, not reported as `none`):

- FSCQ — certified crash-safe file system in Rocq, ~30,000 lines (OS file system). Source: https://github.com/mit-pdos/fscq , https://people.csail.mit.edu/nickolai/papers/chen-fscq.pdf
- SeKVM — verified KVM-hypervisor core (Hypervisor). Named as research.
- miTLS / Project Everest — verified TLS 1.3 in F\*, handshake proof incomplete (Authentication). Source: https://github.com/project-everest/mitls-fstar , https://project-everest.github.io/
- Verdi verdi-raft — Raft consensus + fault-tolerant KV store verified in Rocq (Distributed Config / Key Value Store). Source: https://github.com/uwplse/verdi-raft
- IronFleet — replicated state machine / Paxos KV store verified in Dafny (Distributed DB / Key Value Store). Source: https://github.com/microsoft/Ironclad , https://cacm.acm.org/research/ironfleet/
- Candle — verified HOL Light implemented in CakeML, sound to machine code (Proof Assistant). Source: https://cakeml.org/candle/ , https://cakeml.org/itp22-candle.pdf

## Unverified LOC figures sourced (with URLs)

Order-of-magnitude, all marked `~`:

- GCC ~14.5M — https://www.phoronix.com/news/MTg3OTQ , https://www.linux.com/news/gcc-soars-past-145-million-lines-code-im-real-excited-gcc-5/
- Clang+LLVM ~4.36M (1,469,561 + 2,895,123) — `PLSizes.md`
- Z3 496,337 — `SMTSizes.md`; Carcara 22,420 — `SMTCheckVerificationAndTCBandVCB.md`
- Linux ~40M (2024, 39,819,522) — https://www.stackscale.com/blog/linux-kernel-surpasses-40-million-lines-code/ , https://commandlinux.com/statistics/linux-kernel-contributors-lines-of-code-statistics/
- glibc 1,104,158; Rust std/core/alloc 208,981 — `PLSizes.md`
- GNU coreutils 97,567 — https://openhub.net/p/coreutils
- Redis 329,658 — https://openhub.net/p/redis
- PostgreSQL ~1.3M — https://www.cybertec-postgresql.com/en/code-size-over-time/ , https://openhub.net/p/postgres ; SQLite ~155,800 (155.8 KSLOC) — https://sqlite.org/testing.html
- nginx ~250,000 — https://openhub.net/p/nginx
- Apache Kafka 1,119,998 — https://openhub.net/p/apache-kafka , https://blog.2minutestreaming.com/p/apache-kafka-lines-of-code
- CockroachDB ~125,000 non-generated Go — https://www.cockroachlabs.com/blog/why-go-was-the-right-choice-for-cockroachdb/
- git ~1.3M whole tree (openhub) — https://openhub.net/p/git
- BIND9 — https://openhub.net/p/bind (exact LOC not shown in the summary; left as "~ several hundred k")
- GDB — part of https://github.com/bminor/binutils-gdb (~1M+, not separately measured)

## Cells left `none` or `—`, and why

`none` in the proven column — no formally verified production instance exists:

- PL: linker, assembler (CompCert trusts both; CompCertELF research noted), debugger, test tools, performance tools, package system
- Std Library: Alloc Library (only a VST research `malloc`/`free`)
- OS: boot, OS networking, OS driver system, Firewall
- Utilities: Base servers, Command Line Services, Intrustion Detection
- Application Stack: HTTP Server, In Memory DB, On Disk DB, Application Server
- Distributed Services: Distributed Logging, Distributed FS, Key Value Store (S3), Load Balancing, Distributed Perf Monitoring, Revision Control (git)

`—` (no defensible size figure or prose-only artifact): PL semantics proof unproven
example (prose language standards); test tools, Firewall, Application Server,
Key Value Store, Distributed Config unproven LOC; Proof Automation unproven LOC
(automation is bundled inside the host prover, not separately measurable).

## Cells I was unsure about

- **Section 1 rows are the most interpretive.** "Proof Automation", "PL semantics
  framework", and "PL semantics proof" have no single canonical instance; I chose
  SMTCoq, Iris, and RustBelt/JSCert/Vellvm respectively and stated the reasoning in
  the cells. An alternate reading (e.g. Twelf or the K framework as the "framework",
  or CompCert/CakeML semantics as the "proof") is defensible.
- **Std Library** maps naturally to Rust's `core`/`alloc`/`std` split, but `PLSizes.md`
  reports only the combined 208,981; I could not source per-sublibrary figures, so the
  three unproven cells share that combined number with a note.
- **git** LOC: Open Hub returned a COCOMO effort figure but the summary did not expose
  the exact line count; I used ~1.3M (whole tree) with core C ~250k as an estimate.
- **BIND9** LOC: Open Hub summary gave effort, not lines; left as "~ several hundred k".
- **Whole-system proof-assistant LOC** (Rocq/Lean/Isabelle): only the kernels are
  measured in-repo (2,210 / 30,411); the whole-system size is given as an
  order-of-magnitude ~10⁵–10⁶.

No `README.md` edit, no `git commit`, nothing under `sources/` touched.
