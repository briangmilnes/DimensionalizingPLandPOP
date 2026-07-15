<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Typing Dimensions

A deeper cut on the type systems of the thirteen languages in `ThirteenPLs.md`:
runtime tagging for GC, low-level expressibility, the null/option split, the
algebraic-data-type ladder, and the polymorphism mechanism.

## Sub-dimensions

| # | Sub-dimension | Values |
|---|---------------|--------|
| 1 | GC tagging | none / tagged / boxed / headers |
| 2 | Low-level expressibility | full / partial / none |
| 3 | Null vs option | null / option |
| 4 | Data types | structs / enums / ADT / GADT |
| 5 | Polymorphism mechanism | mono / templ / poly / typeclasses |

Reading of the value ladders:

- **GC tagging** — how runtime values carry type info for the collector: `none`
  (no GC, untagged), `tagged` (tag bits / info pointers), `boxed` (every value a
  boxed dynamic object), `headers` (object headers, primitives unboxed).
- **Low-level** — whether the type system can express unboxed/raw layout and
  pointers: `full` / `partial` / `none`.
- **Data types** — the algebraic ladder: `structs` (products) → `enums` (C-style /
  weak sums) → `ADT` (sums of products) → `GADT`.
- **Polymorphism** — `mono` → `templ` (compile-time expansion) → `poly` (parametric)
  → `typeclasses` (ad-hoc dispatch).

## The Thirteen on these Dimensions

| # | Sub-dimension | Python | C | C++ | Java | C# | JS | TS | Rust | Lisp | Haskell | SML | OCaml | OxCaml |
|---|---------------|--------|---|-----|------|----|----|----|------|------|---------|-----|-------|--------|
| 1 | GC tagging | boxed | none | none | headers | headers | boxed | boxed | none | boxed | tagged | tagged | tagged | tagged |
| 2 | Low-level | none | full | full | partial | partial | none | none | full | none | partial | none | none | partial |
| 3 | Null vs option | null | null | null | null | null | null | null | option | null | option | option | option | option |
| 4 | Data types | structs | enums | enums | enums | enums | structs | ADT | ADT | structs | GADT | ADT | GADT | GADT |
| 5 | Polymorphism | poly | mono | templ | poly | poly | poly | poly | typeclasses | poly | typeclasses | poly | poly | poly |
