#!/usr/bin/env bash
# Shallow-clone the open-source SMT solvers from docs/SMTs.md into sources/.
# Same pattern as CheckoutPLSources.sh: a name|git-url list, shallow single-branch
# clone, skip-if-present. Closed-source / binary-only solvers (MathSAT5, iSAT3,
# the original CEA Colibri) are NOT here because they have no public source; they
# are recorded as unmeasurable in docs/SMTSizes.md. veriT has no public git repo
# and is fetched as a source tarball at the end of this script.
set -uo pipefail
SOURCES=(
  # General-purpose
  "z3|https://github.com/Z3Prover/z3.git"
  "cvc5|https://github.com/cvc5/cvc5.git"
  "yices2|https://github.com/SRI-CSL/yices2.git"
  "alt-ergo|https://github.com/OCamlPro/alt-ergo.git"
  "opensmt|https://github.com/usi-verification-and-security/opensmt.git"
  # Specialized
  "dreal4|https://github.com/dreal/dreal4.git"
  "smtrat|https://github.com/ths-rwth/smtrat.git"
  "boolector|https://github.com/Boolector/boolector.git"
  "bitwuzla|https://github.com/bitwuzla/bitwuzla.git"
  "stp|https://github.com/stp/stp.git"
  "z3-noodler|https://github.com/VeriFIT/z3-noodler.git"
  "ostrich|https://github.com/uuverifiers/ostrich.git"
  "princess|https://github.com/uuverifiers/princess.git"
  "metitarski|https://bitbucket.org/lcpaulson/metitarski-git.git"
  "rasat|https://github.com/tungvx/raSAT.git"
  "colibrics|https://git.frama-c.com/pub/colibrics.git"
  "smtinterpol|https://github.com/ultimate-pa/smtinterpol.git"
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

# veriT: no public git repo (LORIA ships source tarballs only). Fetch the latest
# stable source tarball and extract it into sources/verit so it can be measured.
VERIT_URL="https://verit.loria.fr/download/2021.06.2/verit-2021.06.2-rmx.tar.gz"
VERIT_DIR="$DEST/verit"
if [ -d "$VERIT_DIR" ]; then
  echo "== verit present, skipping =="
else
  echo "== fetching verit source tarball =="
  tmp="$DEST/verit.tar.gz"
  if curl -fsSL "$VERIT_URL" -o "$tmp"; then
    mkdir -p "$VERIT_DIR"
    if ! tar -xzf "$tmp" -C "$VERIT_DIR" --strip-components=1; then
      echo "WARNING: could not extract verit tarball" >&2; rm -rf "$VERIT_DIR"
    fi
    rm -f "$tmp"
  else
    echo "WARNING: could not download verit tarball ($VERIT_URL)" >&2
  fi
fi

du -sh "$DEST"/* 2>/dev/null || true
