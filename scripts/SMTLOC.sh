#!/usr/bin/env bash
# Lines-of-code counts for the checked-out SMT solvers (docs/SMTs.md).
# Measures each solver's SOURCE with tests excluded where identifiable.
# Same measurement rule as scripts/LOC.sh: report tokei's Code column
# (non-blank, non-comment physical lines). Auto-detects a LOC tool.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/sources"

# ---- auto-detect a LOC tool at run time (prefer tokei; cloc/scc fall back) ----
TOOL=""
for t in tokei cloc scc; do
  if command -v "$t" >/dev/null 2>&1; then TOOL="$t"; break; fi
done
[ -z "$TOOL" ] && TOOL="none"
echo "LOC tool: $TOOL"
echo

# EXCLUDES: directory-basename / gitignore-style name globs to drop (tokei --exclude).
EXCLUDES=()

# measure LABEL PATH [PATH ...]
# Prints a per-solver tokei table for the union of the given paths (relative to
# sources/), honouring the current EXCLUDES[] filter. Read the Code column.
measure() {
  local label="$1"; shift
  local paths=() p
  for p in "$@"; do
    if [ -e "$SRC/$p" ]; then paths+=("$SRC/$p"); else
      echo "  WARNING: path missing, skipped: $p" >&2
    fi
  done
  echo "----- $label -----"
  if [ "${#paths[@]}" -eq 0 ]; then echo "  (no existing paths — not cloned)"; echo; return; fi
  if [ "${#EXCLUDES[@]}" -gt 0 ]; then echo "  excluded: ${EXCLUDES[*]}"; fi

  case "$TOOL" in
    tokei)
      local exargs=() e
      for e in "${EXCLUDES[@]:-}"; do [ -n "$e" ] && exargs+=(--exclude "$e"); done
      tokei "${exargs[@]}" "${paths[@]}"
      ;;
    cloc)
      local ex=""
      if [ "${#EXCLUDES[@]}" -gt 0 ]; then local IFS=,; ex="--exclude-dir=${EXCLUDES[*]}"; fi
      cloc --quiet $ex "${paths[@]}"
      ;;
    scc)
      local exargs=() e
      for e in "${EXCLUDES[@]:-}"; do [ -n "$e" ] && exargs+=(--exclude-dir "$e"); done
      scc "${exargs[@]}" "${paths[@]}"
      ;;
    none)
      echo "  no LOC tool found (install tokei, cloc, or scc)"
      ;;
  esac
  echo
}

# For each solver: measure the hand-written source directory where the repo has a
# clear one (src/ and friends), else the whole clone, with tests excluded by
# directory basename / name glob. What is excluded is stated per solver.

echo "############################################################"
echo "# GENERAL-PURPOSE SOLVERS"
echo "############################################################"

echo "== Z3 (C++) — src/, excluding src/test =="
EXCLUDES=(test)
measure "Z3 source (src/, excl. test)" z3/src
EXCLUDES=()

echo "== cvc5 (C++) — src/, tests live in test/ (outside src/) =="
measure "cvc5 source (src/)" cvc5/src

echo "== Yices2 (C) — src/, tests live in tests/ (outside src/) =="
measure "Yices2 source (src/)" yices2/src

echo "== Alt-Ergo (OCaml) — src/, tests live in tests/ (outside src/) =="
measure "Alt-Ergo source (src/)" alt-ergo/src

echo "== OpenSMT (C++) — src/, tests live in test/ (outside src/) =="
measure "OpenSMT source (src/)" opensmt/src

echo "############################################################"
echo "# SPECIALIZED SOLVERS"
echo "############################################################"

echo "== dReal (C++) — dreal/, excluding the test/ dir, 37 interleaved *_test.cc, examples =="
EXCLUDES=(test examples benchmarks '*_test.cc')
measure "dReal source (dreal/, excl. test/examples/benchmarks)" dreal4/dreal
EXCLUDES=()

echo "== SMT-RAT (C++) — src/, excluding tests =="
EXCLUDES=(test tests)
measure "SMT-RAT source (src/, excl. test)" smtrat/src
EXCLUDES=()

echo "== Boolector (C) — src/, excluding src/tests =="
EXCLUDES=(tests test)
measure "Boolector source (src/, excl. tests)" boolector/src
EXCLUDES=()

echo "== Bitwuzla (C++) — src/, tests live in test/ (outside src/) =="
measure "Bitwuzla source (src/)" bitwuzla/src

echo "== STP (C++) — lib/ + include/, tests live in tests/ (outside) =="
measure "STP source (lib/ + include/)" stp/lib stp/include

echo "== Z3-Noodler (C++) — src/, excluding src/test. FORK OF Z3: most LOC is"
echo "   inherited Z3; the Noodler-specific code is src/smt/theory_str_noodler =="
EXCLUDES=(test)
measure "Z3-Noodler whole source (src/, excl. test) — INCLUDES inherited Z3" z3-noodler/src
measure "Z3-Noodler string-solver only (src/smt/theory_str_noodler) — new code" z3-noodler/src/smt/theory_str_noodler
EXCLUDES=()

echo "== OSTRICH (Scala) — src/main, tests live in src/test (excluded) =="
EXCLUDES=(test)
measure "OSTRICH source (src/, excl. test)" ostrich/src
EXCLUDES=()

echo "== Princess (Scala) — src/main, tests live in src/test (excluded) =="
EXCLUDES=(test)
measure "Princess source (src/, excl. test)" princess/src
EXCLUDES=()

echo "== MetiTarski (Standard ML) — src/ =="
measure "MetiTarski source (src/)" metitarski/src

echo "== raSAT (OCaml) — whole clone minus tests/benchmarks (unmaintained prototype) =="
EXCLUDES=(test tests benchmarks benchmark examples)
measure "raSAT source (whole clone, excl. test/benchmarks)" rasat
EXCLUDES=()

echo "== Colibri2 (OCaml) — colibri2/ subdir of the colibrics repo, excl. tests =="
EXCLUDES=(tests test)
measure "Colibri2 source (colibrics/colibri2, excl. tests)" colibrics/colibri2
EXCLUDES=()

echo "== SMTInterpol (Java) — SMTInterpol/src, excl. tests =="
EXCLUDES=(test tests)
measure "SMTInterpol source (SMTInterpol/src, excl. test)" smtinterpol/SMTInterpol/src
EXCLUDES=()

echo "== veriT (C) — src/ of the source tarball (test/ is a sibling). Not a git repo. =="
measure "veriT source (tarball src/)" verit/src

echo "############################################################"
echo "# CLOSED / UNAVAILABLE (no public source; not measurable):"
echo "#   MathSAT5 (FBK, binary-only), iSAT3 (binary-only research tool),"
echo "#   Colibri original (CEA, binary-only). See docs/SMTSizes.md."
echo "############################################################"
