#!/usr/bin/env bash
# Lines-of-code counts for the checked-out language implementations.
# Measures the COMPILER/runtime and the BASE LIBRARY of each system separately.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/sources"

# ---- auto-detect a LOC tool at run time -------------------------------------
TOOL=""
for t in cloc tokei scc; do
  if command -v "$t" >/dev/null 2>&1; then TOOL="$t"; break; fi
done
[ -z "$TOOL" ] && TOOL="fallback"
echo "LOC tool: $TOOL"
echo

# EXCLUDES: basename-of-directory names to drop from a measurement.
EXCLUDES=()

# measure LABEL PATH [PATH ...]
# Prints a per-language line-count table for the union of the given paths,
# honouring the current EXCLUDES[] directory-basename filter.
measure() {
  local label="$1"; shift
  local paths=() p
  for p in "$@"; do
    if [ -e "$SRC/$p" ]; then paths+=("$SRC/$p"); else
      echo "  WARNING: path missing, skipped: $p" >&2
    fi
  done
  echo "----- $label -----"
  if [ "${#paths[@]}" -eq 0 ]; then echo "  (no existing paths)"; echo; return; fi

  case "$TOOL" in
    cloc)
      local ex=""
      if [ "${#EXCLUDES[@]}" -gt 0 ]; then
        local IFS=,; ex="--exclude-dir=${EXCLUDES[*]}"
      fi
      cloc --quiet $ex "${paths[@]}"
      ;;
    tokei)
      local exargs=() e
      for e in "${EXCLUDES[@]:-}"; do [ -n "$e" ] && exargs+=(--exclude "$e"); done
      tokei "${exargs[@]}" "${paths[@]}"
      ;;
    scc)
      local exargs=() e
      for e in "${EXCLUDES[@]:-}"; do [ -n "$e" ] && exargs+=(--exclude-dir "$e"); done
      scc "${exargs[@]}" "${paths[@]}"
      ;;
    fallback)
      # Count non-blank lines of source files by extension.
      local exts="v ml mli rs c cc cpp cxx h hpp hxx sml sig lem"
      local findargs=() first=1 e
      for e in $exts; do
        if [ $first -eq 1 ]; then findargs+=(-name "*.$e"); first=0
        else findargs+=(-o -name "*.$e"); fi
      done
      local prune=() ed
      for ed in "${EXCLUDES[@]:-}"; do
        [ -n "$ed" ] && prune+=(-name "$ed" -o)
      done
      local total=0 pth
      for pth in "${paths[@]}"; do
        local n
        if [ "${#prune[@]}" -gt 0 ]; then
          n=$(find "$pth" \( "${prune[@]}" -false \) -prune -o -type f \( "${findargs[@]}" \) -print0 \
               | xargs -0 grep -chv '^[[:space:]]*$' 2>/dev/null | paste -sd+ | bc 2>/dev/null)
        else
          n=$(find "$pth" -type f \( "${findargs[@]}" \) -print0 \
               | xargs -0 grep -chv '^[[:space:]]*$' 2>/dev/null | paste -sd+ | bc 2>/dev/null)
        fi
        total=$(( total + ${n:-0} ))
      done
      echo "  non-blank source lines (extensions: $exts): $total"
      ;;
  esac
  echo
}

echo "############################################################"
echo "# CompCert  (verified C compiler; Rocq .v + OCaml .ml)"
echo "############################################################"
EXCLUDES=(test doc)
measure "CompCert compiler (whole repo excluding test/ and doc/)" compcert
EXCLUDES=()
echo "CompCert base library: none (targets the host system's libc)."
echo

echo "############################################################"
echo "# CakeML  (verified SML-dialect compiler; HOL4 proof scripts)"
echo "# NOTE: these are HOL4 proof scripts (.sml / SML), not ordinary source."
echo "############################################################"
measure "CakeML compiler (compiler/)" cakeml/compiler
measure "CakeML base library (basis/)" cakeml/basis

echo "############################################################"
echo "# Rust  (rustc + std)"
echo "############################################################"
measure "Rust compiler (compiler/)" rust/compiler
measure "Rust base library (library/std + core + alloc)" \
  rust/library/std rust/library/core rust/library/alloc

echo "############################################################"
echo "# LLVM project  (clang front end, llvm backend, libc++ base library)"
echo "# test/ and unittests/ excluded: those hold .ll / .s / C/C++ TEST"
echo "# CORPORA (millions of lines), not the tools' own hand-written source."
echo "############################################################"
EXCLUDES=(test unittests)
measure "Clang C/C++ front end (clang/, excl. test+unittests)" llvm-project/clang
measure "LLVM shared backend (llvm/, excl. test+unittests)" llvm-project/llvm
measure "libc++ C++ base library (libcxx/, excl. test)" llvm-project/libcxx
EXCLUDES=()

echo "############################################################"
echo "# OxCaml  (Jane Street's OCaml branch)"
echo "# Compiler figure = explicit OCaml compiler + C runtime dirs from the map."
echo "############################################################"
measure "OxCaml compiler + runtime (parsing typing bytecomp asmcomp backend middle_end lambda driver toplevel utils file_formats runtime)" \
  oxcaml/parsing oxcaml/typing oxcaml/bytecomp oxcaml/asmcomp oxcaml/backend oxcaml/middle_end \
  oxcaml/lambda oxcaml/driver oxcaml/toplevel oxcaml/utils oxcaml/file_formats oxcaml/runtime
measure "OxCaml base library (stdlib/)" oxcaml/stdlib

echo "############################################################"
echo "# glibc  (GNU C Library; the C base library that CompCert- and"
echo "# Clang-compiled C link against). Dominant language: C."
echo "#"
echo "# Test exclusion is by directory basename AND by file-name glob,"
echo "# because glibc interleaves per-directory test files inside source"
echo "# dirs (tst-*.c, test-*.c) that a directory exclude alone misses:"
echo "#   dirs  : test  tests  benchtests  (and any test* basename)"
echo "#   files : tst-*  test-*  (tokei gitignore-style name globs; this"
echo "#           empirically drops the ~3300 interleaved tst-*/test-* files"
echo "#           and the htl/tests, localedata/tests, nptl tst-* corpora)"
echo "#"
echo "# CAVEAT: a residual set of differently-named test programs"
echo "# (bug-*.c, check-*.c, ~130 files) is NOT matched by these globs and"
echo "# remains in the C count. The figure is therefore a slight OVER-count"
echo "# of pure library source, not an under-count."
echo "#"
echo "# localedata/ (locale definition tables, ~39M) is reported BOTH ways."
echo "# It is data, not C code: excluding it changes the C figure by only"
echo "# ~566 lines (its bulk is locale tables tokei classifies as PO/Autoconf/"
echo "# Plain Text, never C). The HEADLINE run excludes localedata."
echo "#"
echo "# The library-code figure of record for the doc is the sum of the"
echo "# actual implementation languages: C + C Header + GNU-style Assembly"
echo "# (glibc's per-architecture hand-written asm in sysdeps IS library"
echo "# code). Translation catalogs (PO files), build files (Makefile,"
echo "# Autoconf, M4) and docs (TeX, Markdown) are NOT library source and"
echo "# are read off the table but not summed into the headline figure."
echo "############################################################"
GLIBC_EX=(test tests benchtests 'test*' 'tst-*')
EXCLUDES=("${GLIBC_EX[@]}" localedata)
measure "glibc base library (whole repo; tests + localedata excluded) [HEADLINE]" glibc
EXCLUDES=("${GLIBC_EX[@]}")
measure "glibc base library (whole repo; tests excluded, localedata INCLUDED)" glibc
EXCLUDES=()
