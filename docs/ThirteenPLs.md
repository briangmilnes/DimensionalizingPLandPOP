<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Programming Languages — Basic Dimensions

 Here we dimensionalize programming languages on three basic axes: compilation, typing,
and memory management. "Dynamic" typing is labeled "uni-typed" (after Dana Scott's
observation that a dynamically typed language is a statically typed language with a
single universal type).

| # | Language | Compilation | Typing | Memory management |
|---|----------|-------------|--------|-------------------|
| 1 | Python | interpreted (bytecode VM) | dynamic (uni-typed) | GC (refcount + cycles) |
| 2 | C | compiled | static | manual |
| 3 | C++ | compiled | static | manual (+ RAII/smart ptrs) |
| 4 | Java | both (bytecode + JIT) | static | GC |
| 5 | C# | both (bytecode + JIT) | static | GC |
| 6 | JavaScript | interpreted (JIT) | dynamic (uni-typed) | GC |
| 7 | TypeScript | compiled (to JS) | static (structural, gradual) | GC |
| 8 | Rust | compiled | static | ownership (+ borrow checker) |
| 9 | Common Lisp | both | dynamic (uni-typed) | GC |
| 10 | Haskell | both | static | GC |
| 11 | SML | both | static | GC |
| 12 | OCaml | both (native + bytecode) | static (HM inference) | GC |
| 13 | OxCaml | both (native + bytecode) | static (+ modes, layouts) | GC (+ alloc control) |
