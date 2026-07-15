<style>
body, .markdown-body, article, main, .markdown-preview, .markdown-preview-view {
  max-width: 95% !important;
  width: 95% !important;
  margin: 0 auto;
}
</style>

# Programming Language Featurefulness

An early scoring exercise built on `PLDimensions.md`. Each dimension's values are
placed on an ordinal scale ordered by complexity, least featureful first, and
given an integer score starting at 0. A language's **featurefulness** is the sum
of its per-dimension scores.

## Dimensions, scored (least → most featureful)

| # | Dimension | Values (score) |
|---|-----------|----------------|
| 1 | Compilation | interpreted (0) / compiled (1) / both (2) |
| 2 | Evaluation strategy | lazy (0) / eager (1) |
| 3 | Typing discipline | dynamic (0) / static (1) |
| 4 | Type strength | weak (0) / strong (1) |
| 5 | Type inference | none (0) / local (1) / global (2) |
| 6 | Nominal vs structural | duck (0) / structural (1) / nominal (2) |
| 7 | Algebraic types | no (0) / enum (1) / ADT (2) / GADT (3) |
| 8 | Subtyping | no (0) / yes (1) / refinement (2) |
| 9 | Polymorphism | monomorphic (0) / generics (1) / ad-hoc (2) / polymorphic (3) |
| 10 | Memory management | manual (0) / RAII (1) / GC (2) / borrow (3) |
| 11 | Mutability default | immutable (0) / mutable (1) |
| 12 | Pure fns | no (0) / yes (1) |
| 13 | Paradigm | procedural (0) / OO (1) / functional (2) / multi (3) |
| 14 | First-class functions | pointers (0) / yes (1) |
| 15 | Error handling | codes (0) / values (1) / exceptions (2) |
| 16 | Null model | null (0) / option (1) |
| 17 | Modularity | weak (0) / typeclasses (1) / strong (2) |
| 18 | Interfaces | none (0) / weak (1) / objects (2) / strong (3) |
| 19 | Bit-layout | no (0) / yes (1) |
| 20 | Unsafe escape | n/a (0) / no (1) / yes (2) |
| 21 | Concurrent | none (0) / threads (1) |
| 22 | Linear + borrow | no (0) / lin+bor (1) |

## The Thirteen on these Dimensions

Same grid as `PLDimensions.md`, with a summed featurefulness row.

| # | Dimension | Python | C | C++ | Java | C# | JS | TS | Rust | Lisp | Haskell | SML | OCaml | OxCaml |
|---|-----------|--------|---|-----|------|----|----|----|------|------|---------|-----|-------|--------|
| 1 | Compilation | interp | comp | comp | both | both | interp | comp | comp | both | both | both | both | both |
| 2 | Evaluation | eager | eager | eager | eager | eager | eager | eager | eager | eager | lazy | eager | eager | eager |
| 3 | Typing | dyn | static | static | static | static | dyn | static | static | dyn | static | static | static | static |
| 4 | Strength | strong | weak | weak | strong | strong | weak | strong | strong | strong | strong | strong | strong | strong |
| 5 | Type inference | none | none | local | local | local | none | local | local | none | global | global | global | global |
| 6 | Nom/struct | duck | nom | nom | nom | nom | duck | struct | nom | duck | nom | nom | nom | nom |
| 7 | ADTs | enum | enum | enum | enum | enum | no | ADT | ADT | no | GADT | ADT | GADT | GADT |
| 8 | Subtyping | no | no | yes | yes | yes | no | yes | no | no | no | no | yes | yes |
| 9 | Polymorphism | dyn | monom | gen | gen | gen | dyn | gen | gen | dyn | gen | gen | gen | gen |
| 10 | Memory | GC | manual | RAII | GC | GC | GC | GC | borrow | GC | GC | GC | GC | GC |
| 11 | Mutability | mut | mut | mut | mut | mut | mut | mut | immut | mut | immut | immut | immut | immut |
| 12 | Pure fns | no | no | no | no | no | no | no | no | no | yes | no | no | no |
| 13 | Paradigm | multi | proc | multi | OO | multi | multi | multi | multi | multi | func | func | multi | multi |
| 14 | First-class fns | yes | ptrs | yes | yes | yes | yes | yes | yes | yes | yes | yes | yes | yes |
| 15 | Errors | excptns | codes | excptns | excptns | excptns | excptns | excptns | values | excptns | values | excptns | excptns | excptns |
| 16 | Null model | null | null | null | null | null | null | null | option | null | option | option | option | option |
| 17 | Modularity | weak | weak | tclass | weak | weak | weak | weak | tclass | weak | tclass | strong | strong | strong |
| 18 | Interfaces | weak | none | obj | obj | obj | weak | obj | strong | weak | strong | strong | strong | strong |
| 19 | Bit-layout | no | yes | yes | no | no | no | no | yes | no | no | no | no | yes |
| 20 | Unsafe escape | no | n/a | n/a | yes | yes | no | no | yes | yes | yes | no | yes | yes |
| 21 | Concurrent | threads | threads | threads | threads | threads | threads | threads | threads | threads | threads | none | threads | threads |
| 22 | Lin+bor | no | no | no | no | no | no | no | lin+bor | no | no | no | no | lin+bor |
| Σ | **Featurefulness** | **18** | **9** | **22** | **23** | **25** | **16** | **23** | **28** | **20** | **27** | **26** | **31** | **33** |

## Languages ordered by featurefulness

| Rank | Language | Featurefulness |
|------|----------|----------------|
| 1 | C | 9 |
| 2 | JavaScript | 16 |
| 3 | Python | 18 |
| 4 | Common Lisp | 20 |
| 5 | C++ | 22 |
| 6 | Java | 23 |
| 6 | TypeScript | 23 |
| 8 | C# | 25 |
| 9 | SML | 26 |
| 10 | Haskell | 27 |
| 11 | Rust | 28 |
| 12 | OCaml | 31 |
| 13 | OxCaml | 33 |
