# Modularity Dimensions

Decomposing the single modularity axis into four sub-dimensions. The "as functor"
value on typeclasses is the theoretically-possible-but-nobody-does-it cell:
typeclass dispatch encoded as explicit functor application.

## Sub-dimensions

| # | Sub-dimension | Values |
|---|---------------|--------|
| 1 | Base modules | yes / no |
| 2 | Signatures | yes / no |
| 3 | Functors | yes / no |
| 4 | Typeclasses | yes / no / as functor |

## The eleven, dimensionalized

| # | Language | Base modules | Signatures | Functors | Typeclasses |
|---|----------|--------------|------------|----------|-------------|
| 1 | Python | yes | no | no | no |
| 2 | C | no | no | no | no |
| 3 | C++ | yes | no | no | yes |
| 4 | Java | yes | no | no | no |
| 5 | C# | yes | no | no | no |
| 6 | JavaScript | yes | no | no | no |
| 7 | TypeScript | yes | no | no | no |
| 8 | Rust | yes | no | no | yes |
| 9 | Common Lisp | yes | no | no | no |
| 10 | Haskell | yes | no | no | yes |
| 11 | SML | yes | yes | yes | no |

Notes on the yes cells: C++ typeclasses are C++20 concepts; Rust's are traits;
Haskell's are typeclasses proper. SML is the only language here with signatures and
functors. Java/C# interfaces are nominal subtyping, not typeclasses, so they read no.
