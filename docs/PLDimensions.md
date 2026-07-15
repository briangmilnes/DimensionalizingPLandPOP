<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Programming Language Dimensions

The axes along which programming languages vary. Values listed are only those
actually spanned by the eleven languages in `ElevenPLs.md`. "Dynamic" typing is
called "uni-typed" after Dana Scott (a dynamically typed language is a statically
typed language with one universal type); in the grid the dynamic cell is `dynamic`
and the duck-typing cell is `duck`.

## Dimensions

| # | Dimension | Values |
|---|-----------|--------|
| 1 | Compilation | compiled / interpreted / both |
| 2 | Evaluation strategy | eager / lazy |
| 3 | Typing discipline | static / dynamic |
| 4 | Type strength | strong / weak |
| 5 | Type inference | none / local / global |
| 6 | Nominal vs structural | nominal / structural / duck |
| 7 | Subtyping | yes / no / refinement |
| 8 | Polymorphism | monomorphic / generics / ad-hoc |
| 9 | Memory management | manual / RAII / GC / borrow |
| 10 | Mutability default | mutable / immutable |
| 11 | Purity / effects | pure / impure |
| 12 | Paradigm | procedural / OO / functional / multi |
| 13 | First-class functions | yes / pointers |
| 14 | Error handling | exceptions / values / codes |
| 15 | Null model | null / option |
| 16 | Modularity | weak / typeclasses / strong |
| 17 | Interfaces | strong / weak / objects / none |

## The eleven, dimensionalized

| # | Dimension | Python | C | C++ | Java | C# | JS | TS | Rust | Lisp | Haskell | SML |
|---|-----------|--------|---|-----|------|----|----|----|------|------|---------|-----|
| 1 | Compilation | interpreted | compiled | compiled | both | both | interpreted | compiled | compiled | both | both | both |
| 2 | Evaluation | eager | eager | eager | eager | eager | eager | eager | eager | eager | lazy | eager |
| 3 | Typing | dynamic | static | static | static | static | dynamic | static | static | dynamic | static | static |
| 4 | Strength | strong | weak | weak | strong | strong | weak | strong | strong | strong | strong | strong |
| 5 | Inference | none | none | local | local | local | none | local | local | none | global | global |
| 6 | Nom/struct | duck | nominal | nominal | nominal | nominal | duck | structural | nominal | duck | nominal | nominal |
| 7 | Subtyping | no | no | yes | yes | yes | no | yes | no | no | no | no |
| 8 | Polymorphism | dynamic | monomorphic | generics | generics | generics | dynamic | generics | generics | dynamic | generics | generics |
| 9 | Memory | GC | manual | RAII | GC | GC | GC | GC | borrow | GC | GC | GC |
| 10 | Mutability | mutable | mutable | mutable | mutable | mutable | mutable | mutable | immutable | mutable | immutable | immutable |
| 11 | Purity | impure | impure | impure | impure | impure | impure | impure | impure | impure | pure | impure |
| 12 | Paradigm | multi | procedural | multi | OO | multi | multi | multi | multi | multi | functional | functional |
| 13 | First-class fns | yes | pointers | yes | yes | yes | yes | yes | yes | yes | yes | yes |
| 14 | Errors | exceptions | codes | exceptions | exceptions | exceptions | exceptions | exceptions | values | exceptions | values | exceptions |
| 15 | Null model | null | null | null | null | null | null | null | option | null | option | option |
| 16 | Modularity | weak | weak | typeclasses | weak | weak | weak | weak | typeclasses | weak | typeclasses | strong |
| 17 | Interfaces | weak | none | objects | objects | objects | weak | objects | strong | weak | strong | strong |
