<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# LLVM Backend Size by Target Architecture

`docs/PLSizes.md` measures the LLVM backend as one shared 2,895,123-line block
(`llvm/` excluding `test/` and `unittests/`, tokei Code). This document
decomposes that block into its per-architecture targets versus the shared,
target-independent core. Each target — the code generator for one instruction
set — lives in `sources/llvm-project/llvm/lib/Target/<Arch>/`. The 25 target
subdirectories present are measured individually below; their sum is the
architecture-specific fraction of the backend, and the remainder (register
allocation, instruction selection framework, IR, optimization passes, the
TableGen tool, object-file writers, and the rest) is the code every target
shares.

Each target is written in two languages: hand-written C++ (the lowering,
instruction selection, and target-machine glue) and TableGen (`.td` files —
instruction, register, calling-convention, and scheduling definitions that the
`llvm-tblgen` tool expands into C++ at build time). The table reports both.

## Sizes by target architecture

Sorted descending by tokei Code. **Code** and **C++** are tokei Code lines
(physical lines, neither blank nor comment); Code is the directory total across
all languages tokei recognizes, of which C++ is the dominant subset. **TableGen**
is a separate raw physical-line count of the `.td` files (see methodology) and is
**not** part of the Code column. **% of target-specific** is the target's Code as
a fraction of the 967,033-line target sum.

| Architecture | Code | C++ | TableGen | % of target-specific |
|--------------|-----:|----:|---------:|---------------------:|
| AMDGPU | 173,023 | 157,104 | 56,506 | 17.9% |
| X86 | 129,285 | 120,058 | 89,319 | 13.4% |
| AArch64 | 121,934 | 115,148 | 113,061 | 12.6% |
| ARM | 93,121 | 81,490 | 51,743 | 9.6% |
| Hexagon | 74,342 | 66,088 | 81,769 | 7.7% |
| RISCV | 64,882 | 60,638 | 59,464 | 6.7% |
| PowerPC | 58,601 | 47,623 | 34,139 | 6.1% |
| Mips | 38,650 | 35,281 | 29,589 | 4.0% |
| SPIRV | 32,467 | 29,618 | 5,425 | 3.4% |
| SystemZ | 25,209 | 22,776 | 26,825 | 2.6% |
| WebAssembly | 22,487 | 20,223 | 4,792 | 2.3% |
| LoongArch | 19,183 | 17,951 | 11,606 | 2.0% |
| NVPTX | 18,760 | 16,697 | 9,422 | 1.9% |
| DirectX | 13,442 | 12,293 | 1,554 | 1.4% |
| M68k | 9,794 | 8,151 | 4,534 | 1.0% |
| BPF | 9,616 | 8,361 | 1,739 | 1.0% |
| Sparc | 9,318 | 8,326 | 5,557 | 1.0% |
| VE | 9,193 | 7,753 | 7,111 | 1.0% |
| AVR | 9,123 | 8,121 | 3,334 | 0.9% |
| CSKY | 8,663 | 7,389 | 5,682 | 0.9% |
| Xtensa | 6,508 | 5,612 | 3,147 | 0.7% |
| Lanai | 6,305 | 5,210 | 1,674 | 0.7% |
| XCore | 4,751 | 4,132 | 1,770 | 0.5% |
| MSP430 | 4,739 | 4,097 | 1,647 | 0.5% |
| ARC | 3,637 | 3,085 | 2,221 | 0.4% |
| **Target-specific sum (25 targets)** | **967,033** | **873,225** | **613,630** | 100% |

The five largest targets — AMDGPU, X86, AArch64, ARM, Hexagon — hold 591,705
Code lines, 61.2% of all architecture-specific code. The 11 smallest targets
(M68k and below) together hold 81,647 lines, 8.4%.

## Backend decomposition

The full backend (tokei Code) splits into the target sum above and the shared
core that is the remainder.

| Part | Code | Fraction of backend |
|------|-----:|--------------------:|
| Target-specific (sum of `lib/Target/*`) | 967,033 | 33.4% |
| Target-independent core (remainder) | 1,928,090 | 66.6% |
| **Full backend** (`llvm/`, excl. `test/` + `unittests/`) | **2,895,123** | 100% |

The full-backend figure is identical to the LLVM row in `docs/PLSizes.md`
(2,895,123). The target-independent core is that figure minus the target sum:
2,895,123 − 967,033 = 1,928,090. Two thirds of the LLVM backend is
target-independent framework shared by every architecture; one third is the
per-architecture target code. Because the target sum is a strict subset of the
full-backend measurement (same tool, same exclusions), the two reconcile by
construction, not by approximation.

## Methodology and caveats

- **Code lines are tokei's Code column.** Physical lines that are neither blank
  nor comment, from tokei 14.0.0. The **Code** column is each target
  directory's total across all recognized languages; **C++** is the dominant
  subset. The small gap between them (Code − C++) is C headers, CMake, and
  module-definition files in the target directory.

- **`lib/Target` is already test-free.** LLVM keeps its per-architecture tests
  under `llvm/test/CodeGen/<Arch>/` (`.ll` / `.mir` corpora), not inside
  `lib/Target`. A search of `lib/Target` for any `test`, `tests`, or
  `unittests` subdirectory returns nothing, so no test exclusion is needed at
  the target level; the target measurements are pure implementation source. The
  `test/CodeGen` tree does hold one directory per architecture (34 of them,
  including MIR/Generic framework tests), confirming that is where per-target
  tests live.

- **TableGen `.td` files are counted separately by raw line count.** tokei
  14.0.0 does not classify `.td` files at all — they appear in no language row
  and contribute nothing to the Code column (verified: X86's 65 `.td` files are
  absent from its tokei output). The TableGen column is therefore
  `find <arch> -name '*.td' | xargs cat | wc -l`: raw physical lines
  **including** blank and comment lines. This differs from tokei Code (which
  strips both), so the TableGen figures are not on the same footing as the Code
  and C++ columns and are not additive with them — they are reported as an
  independent measure of each target's declarative definition size. Because
  tokei ignores `.td` entirely, the 2,895,123-line backend headline excludes all
  TableGen; the 613,630 target-specific TableGen lines are additional declarative
  source, expanded into C++ by `llvm-tblgen` during the build rather than
  compiled directly.

- **Target-independent core by subtraction.** The core is the full-backend
  tokei figure minus the target sum. tokei's `--exclude` matches path basenames
  (gitignore-style globs), so `--exclude lib/Target` does not remove the target
  tree; the subtraction method is used instead and is exact, since both operands
  are tokei Code over the same file set.

- **Reproducible.** Run `scripts/LLVMSizing.sh` to reproduce the per-architecture
  table, the target sum, the target-independent core, and the full-backend
  figure. It reads the checkout under `sources/llvm-project` (git-ignored, not
  committed) and requires `tokei` and `python3`.

## Notable observations

- **AMDGPU is the largest target** at 173,023 Code lines — larger than X86 —
  driven by its C++ (157,104), the biggest hand-written body of any target. It
  is the GPU compute backend and carries substantial custom lowering.
- **TableGen can exceed C++ within a target.** For Hexagon (81,769 TableGen vs
  66,088 C++), SystemZ (26,825 vs 22,776), and nearly for AArch64 (113,061 vs
  115,148), the declarative `.td` definitions rival or outweigh the hand-written
  code. Hexagon is a VLIW DSP whose instruction-packet and scheduling tables are
  unusually large; AArch64's SVE/SVE2 and NEON instruction tables dominate its
  `.td` size.
- **Newer, higher-level targets carry little TableGen** relative to their C++:
  SPIRV (5,425 vs 29,618) and DirectX (1,554 vs 12,293) target virtual ISAs and
  lean on C++ translation rather than large instruction-selection tables.
- **The long tail is real.** 11 of the 25 targets (AVR, MSP430, XCore, ARC,
  Lanai, Xtensa, and the like — embedded and legacy ISAs) are each under 10,000
  Code lines and together are 8.4% of target-specific code.
