---
marp: true
title: Costs of Proving 'Everything' You Need for Security
author: Brian G. Milnes
paginate: true
---

# Cost of Proving 'Everything' You Need for Security
## 20,570 KLOC · $90.9M · 3.0% proven today

| Section              | Unproven | Proven | Proofs |  Total |
|----------------------|---------:|-------:|-------:|-------:|
| 1 Semantics          |    3,000 |    228 |    252 |  3,480 |
| 2 PL                 |    8,173 |    178 |    206 |  8,557 |
| 3 Std Library        |    1,178 |    148 |    135 |  1,461 |
| 4 OS                 |    1,594 |     19 |    107 |  1,720 |
| 5 Utilities          |      879 |      0 |      0 |    879 |
| 6 Application Stack  |      579 |      0 |      0 |    579 |
| 7 Distributed Svcs   |    3,283 |     24 |     47 |  3,354 |
| 8 Proof of Programs  |      500 |      2 |     38 |    540 |
| **Total**            |**19,186**| **599**| **785**|**20,570**|

|                                     |                 |
|-------------------------------------|----------------:|
| Estimated cost of Total KLOC        |     $41,140,000 |
| Estimated cost of Total Proven KLOC |     $49,779,400 |
| **Estimated Total Cost**            | **$90,919,400** |

$2,000/KLOC to write · 1.1 proof lines per line · $2,200/KLOP to prove

---

# The Exemplars
### One measured system per artifact — **bold** = carries a machine-checked proof

- **Semantics** — **Rocq** · **CoqQFBV** · **cake_lpr** · **Iris** · **RustBelt**
- **PL** — **CompCert** · **CompCertELF** · **CakeML GC**
- **Std Library** — Rust core · **VST malloc** · **CakeML basis** · **HACL\*/EverCrypt**
- **OS boot** — U-Boot · **DICE\***
- **OS core** — **Atmosphere** · Asterinas OSTD/OSDK · Linux net/ · **FSCQ**
- **OS devices** — Linux drivers/base · **Pancake i.MX8 NIC** · **SeKVM** · **Vigor/Klint**
- **Utilities & Apps** — Unbound · chrony · BusyBox · Suricata · nginx · Redis · SQLite · NGINX Unit
- **Distributed & POP** — **CapybaraKV** · S3 ShardStore · **Verdi raft** · FoundationDB · git · **Verus (vstd)** · cvc5
