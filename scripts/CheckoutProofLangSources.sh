#!/usr/bin/env bash
# Clone the FORMALLY VERIFIED language developments sized in
# docs/ProofsOfProgrammingLanguagesSizes.md into sources/ (git-ignored).
# Clones are shallow and per-repo non-fatal: one failure does not abort the run.
# compcert and cakeml are assumed already present (see CheckoutPLSources.sh).
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/sources"
mkdir -p "$SRC"
cd "$SRC" || exit 1

clone() {  # clone NAME URL [extra git args...]
  local name="$1" url="$2"; shift 2
  if [ -d "$name" ]; then echo "SKIP (exists): $name"; return 0; fi
  echo "CLONING $name <- $url"
  if git clone --depth 1 "$@" "$url" "$name" 2>&1 | tail -2; then
    echo "  ok: $name"
  else
    echo "  FAILED: $name (continuing)"
  fi
}

# Coq/Rocq developments
clone vst          https://github.com/PrincetonUniversity/VST.git
clone lambda-rust  https://gitlab.mpi-sws.org/iris/lambda-rust.git
clone jscert       https://github.com/jscert/jscert.git
clone vellvm       https://github.com/vellvm/vellvm.git
clone hs-to-coq    https://github.com/plclub/hs-to-coq.git
clone fiat-crypto  https://github.com/mit-plv/fiat-crypto.git

# F* development (large; shallow only)
clone hacl-star    https://github.com/hacl-star/hacl-star.git

# Isabelle: Jinja / JinjaThreads live in the Archive of Formal Proofs.
# Sparse-checkout only those two entries from the AFP GitHub mirror.
if [ -d afp-jinja ]; then
  echo "SKIP (exists): afp-jinja"
else
  echo "CLONING afp-jinja (sparse: thys/Jinja thys/JinjaThreads)"
  if git clone --no-checkout --depth 1 --filter=blob:none \
       https://github.com/isabelle-prover/mirror-afp-devel.git afp-jinja 2>&1 | tail -2; then
    ( cd afp-jinja \
      && git sparse-checkout init --cone \
      && git sparse-checkout set thys/Jinja thys/JinjaThreads \
      && git checkout ) 2>&1 | tail -2
  else
    echo "  FAILED: afp-jinja (continuing)"
  fi
fi

# Isabelle: seL4 proofs (l4v). VERY large history; shallow clone keeps it ~70 MB.
clone l4v          https://github.com/seL4/l4v.git

echo
echo "Done. sources/ is git-ignored; clones are not committed."
