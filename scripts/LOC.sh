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
echo "############################################################"
measure "Clang C/C++ front end (clang/)" llvm-project/clang
measure "LLVM shared backend (llvm/)" llvm-project/llvm
measure "libc++ C++ base library (libcxx/)" llvm-project/libcxx

echo "############################################################"
echo "# OxCaml  (Jane Street's OCaml branch)"
echo "# Compiler figure = explicit OCaml compiler + C runtime dirs from the map."
echo "############################################################"
measure "OxCaml compiler + runtime (parsing typing bytecomp asmcomp backend middle_end lambda driver toplevel utils file_formats runtime)" \
  oxcaml/parsing oxcaml/typing oxcaml/bytecomp oxcaml/asmcomp oxcaml/backend oxcaml/middle_end \
  oxcaml/lambda oxcaml/driver oxcaml/toplevel oxcaml/utils oxcaml/file_formats oxcaml/runtime
measure "OxCaml base library (stdlib/)" oxcaml/stdlib
