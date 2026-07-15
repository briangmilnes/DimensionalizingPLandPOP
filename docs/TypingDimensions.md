# Typing Dimensions

A deeper cut on the type systems of the eleven languages in `ElevenPLs.md`:
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

## The eleven

| # | Sub-dimension | Python | C | C++ | Java | C# | JS | TS | Rust | Lisp | Haskell | SML |
|---|---------------|--------|---|-----|------|----|----|----|------|------|---------|-----|
| 1 | GC tagging | boxed | none | none | headers | headers | boxed | boxed | none | boxed | tagged | tagged |
| 2 | Low-level | none | full | full | partial | partial | none | none | full | none | partial | none |
| 3 | Null vs option | null | null | null | null | null | null | null | option | null | option | option |
| 4 | Data types | structs | enums | ADT | ADT | enums | structs | ADT | ADT | structs | GADT | ADT |
| 5 | Polymorphism | poly | mono | templ | poly | poly | poly | poly | typeclasses | poly | typeclasses | poly |
