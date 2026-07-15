# Programming Language Dimensions

The axes along which programming languages vary. Values listed are only those
actually spanned by the eleven languages in `ElevenPLs.md`.

Abbreviations used in the grids: comp = compiled, interp = interpreted,
dyn = dynamic, nom = nominal, struct = structural, monom = monomorphic,
gen = generics, mut = mutable, immut = immutable, proc = procedural,
func = functional, ptrs = pointers, excptns = exceptions, tclass = typeclasses,
obj = objects.

## Dimensions

| # | Dimension | Values |
|---|-----------|--------|
| 1 | Compilation | comp / interp / both |
| 2 | Evaluation strategy | eager / lazy |
| 3 | Typing discipline | static / dyn |
| 4 | Type strength | strong / weak |
| 5 | Type inference | none / local / global |
| 6 | Nominal vs structural | nom / struct / duck |
| 7 | Subtyping | yes / no / refinement |
| 8 | Polymorphism | monom / gen / ad-hoc |
| 9 | Memory management | manual / RAII / GC / borrow |
| 10 | Mutability default | mut / immut |
| 11 | Pure fns | yes / no |
| 12 | Paradigm | proc / OO / func / multi |
| 13 | First-class functions | yes / ptrs |
| 14 | Error handling | excptns / values / codes |
| 15 | Null model | null / option |
| 16 | Modularity | weak / tclass / strong |
| 17 | Interfaces | strong / weak / obj / none |
| 18 | Bit-layout | yes / no |
| 19 | Unsafe escape | yes / no / n/a |

## The eleven, dimensionalized

| # | Dimension | Python | C | C++ | Java | C# | JS | TS | Rust | Lisp | Haskell | SML |
|---|-----------|--------|---|-----|------|----|----|----|------|------|---------|-----|
| 1 | Compilation | interp | comp | comp | both | both | interp | comp | comp | both | both | both |
| 2 | Evaluation | eager | eager | eager | eager | eager | eager | eager | eager | eager | lazy | eager |
| 3 | Typing | dyn | static | static | static | static | dyn | static | static | dyn | static | static |
| 4 | Strength | strong | weak | weak | strong | strong | weak | strong | strong | strong | strong | strong |
| 5 | Type inference | none | none | local | local | local | none | local | local | none | global | global |
| 6 | Nom/struct | duck | nom | nom | nom | nom | duck | struct | nom | duck | nom | nom |
| 7 | Subtyping | no | no | yes | yes | yes | no | yes | no | no | no | no |
| 8 | Polymorphism | dyn | monom | gen | gen | gen | dyn | gen | gen | dyn | gen | gen |
| 9 | Memory | GC | manual | RAII | GC | GC | GC | GC | borrow | GC | GC | GC |
| 10 | Mutability | mut | mut | mut | mut | mut | mut | mut | immut | mut | immut | immut |
| 11 | Pure fns | no | no | no | no | no | no | no | no | no | yes | no |
| 12 | Paradigm | multi | proc | multi | OO | multi | multi | multi | multi | multi | func | func |
| 13 | First-class fns | yes | ptrs | yes | yes | yes | yes | yes | yes | yes | yes | yes |
| 14 | Errors | excptns | codes | excptns | excptns | excptns | excptns | excptns | values | excptns | values | excptns |
| 15 | Null model | null | null | null | null | null | null | null | option | null | option | option |
| 16 | Modularity | weak | weak | tclass | weak | weak | weak | weak | tclass | weak | tclass | strong |
| 17 | Interfaces | weak | none | obj | obj | obj | weak | obj | strong | weak | strong | strong |
| 18 | Bit-layout | no | yes | yes | no | no | no | no | yes | no | no | no |
| 19 | Unsafe escape | no | n/a | n/a | yes | yes | no | no | yes | yes | yes | no |
