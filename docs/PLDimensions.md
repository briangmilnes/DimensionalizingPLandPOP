<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Programming Language Dimensions

The axes along which programming languages vary. Values listed are only those
actually spanned by the eleven languages in `ElevenPLs.md`.

Abbreviations used in the grid: comp = compiled, interp = interpreted,
dyn = dynamic, nom = nominal, struct = structural, monom = monomorphic,
gen = generics, mut = mutable, immut = immutable, proc = procedural,
func = functional, ptrs = pointers, excptns = exceptions, tclass = typeclasses,
obj = objects.

## Dimensions

| # | Dimension | Values |
|---|-----------|--------|
| 1 | Compilation | compiled / interpreted / both |
| 2 | Evaluation strategy | eager / lazy |
| 3 | Typing discipline | static / dynamic |
| 4 | Type strength | strong / weak |
| 5 | Type inference | none / local / global |
| 6 | Nominal vs structural | nominal / structural / duck |
| 7 | Algebraic types | no / enum / ADT / GADT |
| 8 | Subtyping | yes / no / refinement |
| 9 | Polymorphism | monomorphic / generics / ad-hoc |
| 10 | Memory management | manual / RAII / GC / borrow |
| 11 | Mutability default | mutable / immutable |
| 12 | Pure fns | yes / no |
| 13 | Paradigm | procedural / OO / functional / multi |
| 14 | First-class functions | yes / pointers |
| 15 | Error handling | exceptions / values / codes |
| 16 | Null model | null / option |
| 17 | Modularity | weak / typeclasses / strong |
| 18 | Interfaces | strong / weak / objects / none |
| 19 | Bit-layout | yes / no |
| 20 | Unsafe escape | yes / no / n/a |

## The eleven, dimensionalized

| # | Dimension | Python | C | C++ | Java | C# | JS | TS | Rust | Lisp | Haskell | SML |
|---|-----------|--------|---|-----|------|----|----|----|------|------|---------|-----|
| 1 | Compilation | interp | comp | comp | both | both | interp | comp | comp | both | both | both |
| 2 | Evaluation | eager | eager | eager | eager | eager | eager | eager | eager | eager | lazy | eager |
| 3 | Typing | dyn | static | static | static | static | dyn | static | static | dyn | static | static |
| 4 | Strength | strong | weak | weak | strong | strong | weak | strong | strong | strong | strong | strong |
| 5 | Type inference | none | none | local | local | local | none | local | local | none | global | global |
| 6 | Nom/struct | duck | nom | nom | nom | nom | duck | struct | nom | duck | nom | nom |
| 7 | ADTs | enum | enum | enum | enum | enum | no | ADT | ADT | no | GADT | ADT |
| 8 | Subtyping | no | no | yes | yes | yes | no | yes | no | no | no | no |
| 9 | Polymorphism | dyn | monom | gen | gen | gen | dyn | gen | gen | dyn | gen | gen |
| 10 | Memory | GC | manual | RAII | GC | GC | GC | GC | borrow | GC | GC | GC |
| 11 | Mutability | mut | mut | mut | mut | mut | mut | mut | immut | mut | immut | immut |
| 12 | Pure fns | no | no | no | no | no | no | no | no | no | yes | no |
| 13 | Paradigm | multi | proc | multi | OO | multi | multi | multi | multi | multi | func | func |
| 14 | First-class fns | yes | ptrs | yes | yes | yes | yes | yes | yes | yes | yes | yes |
| 15 | Errors | excptns | codes | excptns | excptns | excptns | excptns | excptns | values | excptns | values | excptns |
| 16 | Null model | null | null | null | null | null | null | null | option | null | option | option |
| 17 | Modularity | weak | weak | tclass | weak | weak | weak | weak | tclass | weak | tclass | strong |
| 18 | Interfaces | weak | none | obj | obj | obj | weak | obj | strong | weak | strong | strong |
| 19 | Bit-layout | no | yes | yes | no | no | no | no | yes | no | no | no |
| 20 | Unsafe escape | no | n/a | n/a | yes | yes | no | no | yes | yes | yes | no |
