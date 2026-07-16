#!/usr/bin/env bash
set -euo pipefail
SOURCES=(
  "compcert|https://github.com/AbsInt/CompCert.git"
  "cakeml|https://github.com/CakeML/cakeml.git"
  "rust|https://github.com/rust-lang/rust.git"
  "llvm-project|https://github.com/llvm/llvm-project.git"
  "oxcaml|https://github.com/oxcaml/oxcaml.git"
  "glibc|https://sourceware.org/git/glibc.git"
)
DEST="$(cd "$(dirname "$0")/.." && pwd)/sources"
mkdir -p "$DEST"
for entry in "${SOURCES[@]}"; do
  name="${entry%%|*}"; url="${entry#*|}"; dir="$DEST/$name"
  if [ -d "$dir/.git" ]; then echo "== $name present, skipping =="; continue; fi
  echo "== cloning $name =="
  git clone --depth 1 --single-branch --no-tags "$url" "$dir"
done
du -sh "$DEST"/* 2>/dev/null || true
