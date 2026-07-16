#!/usr/bin/env bash
# Shallow-clone the SMT certificate-checker sources and the trusted prover kernels
# they rest on, for docs/SMTCheckVerificationAndTCP.md. Same pattern as
# CheckoutSMTSources.sh: a name|git-url list, shallow single-branch clone,
# skip-if-present. Per-clone failures are non-fatal so one bad repo does not abort
# the rest.
#
# NOT here:
#   - cake_lpr: already inside the existing sources/cakeml clone
#     (examples/lpr_checker). Not re-cloned.
#   - GRAT/gratchk: no public git repo. Peter Lammich (TU Munich) ships tarballs;
#     the verified checker with its Isabelle theories is fetched below as
#     gratchk.tgz.
#
# Verified checkers:      smtcoq (Rocq), coqqfbv (Rocq), grat/gratchk (Isabelle).
# Unverified contrast:    carcara (Rust), lfsc (C++).
# Trusted prover kernels: rocq (kernel/), hol4 (core logic).
set -uo pipefail
SOURCES=(
  # Verified certificate checkers (proof extracted / machine-checked)
  "smtcoq|https://github.com/smtcoq/smtcoq.git"
  "coqqfbv|https://github.com/fmlab-iis/coq-qfbv.git"
  # Unverified checkers (contrast)
  "carcara|https://github.com/ufmg-smite/carcara.git"
  "lfsc|https://github.com/cvc5/LFSC.git"
  # Trusted prover kernels (the residual TCB for the verified checkers)
  "rocq|https://github.com/rocq-prover/rocq.git"
  "hol4|https://github.com/HOL-Theorem-Prover/HOL.git"
)
DEST="$(cd "$(dirname "$0")/.." && pwd)/sources"
mkdir -p "$DEST"
for entry in "${SOURCES[@]}"; do
  name="${entry%%|*}"; url="${entry#*|}"; dir="$DEST/$name"
  if [ -d "$dir/.git" ]; then echo "== $name present, skipping =="; continue; fi
  echo "== cloning $name =="
  if ! git clone --depth 1 --single-branch --no-tags "$url" "$dir"; then
    echo "WARNING: clone failed for $name ($url); skipping" >&2
    rm -rf "$dir"
  fi
done

# GRAT/gratchk: no public git repo. Fetch the standard gratchk package, which
# bundles the Isabelle theories of the formally verified checker (gratchk). The
# unverified generator (gratgen) is a separate tarball and is not fetched.
GRAT_URL="https://www21.in.tum.de/~lammich/grat/gratchk.tgz"
GRAT_DIR="$DEST/grat"
if [ -d "$GRAT_DIR" ]; then
  echo "== grat present, skipping =="
else
  echo "== fetching gratchk source tarball (Isabelle theories) =="
  tmp="$DEST/gratchk.tgz"
  if curl -fsSL "$GRAT_URL" -o "$tmp"; then
    mkdir -p "$GRAT_DIR"
    if ! tar -xzf "$tmp" -C "$GRAT_DIR"; then
      echo "WARNING: could not extract gratchk tarball" >&2; rm -rf "$GRAT_DIR"
    fi
    rm -f "$tmp"
  else
    echo "WARNING: could not download gratchk tarball ($GRAT_URL)" >&2
  fi
fi

du -sh "$DEST"/{smtcoq,coqqfbv,carcara,lfsc,rocq,hol4,grat} 2>/dev/null || true
