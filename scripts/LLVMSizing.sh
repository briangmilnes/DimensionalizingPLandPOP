#!/usr/bin/env bash
# Per-target-architecture size of the LLVM backend.
#
# For every subdirectory of llvm/lib/Target/ it prints tokei's Code total,
# the C++ Code subset, and a raw physical-line count of the TableGen (.td)
# files. tokei 14 does NOT classify .td, so TableGen is counted separately
# with `wc -l` (raw lines, including blank and comment lines) and is NOT part
# of the tokei Code column. Rows are sorted descending by Code. The script
# also prints the target sum, the target-independent core (llvm/ excluding
# test+unittests, minus the target sum), and the full backend.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LLVM="$ROOT/sources/llvm-project/llvm"
TGT="$LLVM/lib/Target"

command -v tokei >/dev/null 2>&1 || { echo "tokei not found" >&2; exit 1; }

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

for d in "$TGT"/*/; do
  d="${d%/}"; a="$(basename "$d")"
  json="$(tokei --output json "$d" 2>/dev/null)"
  read -r code cpp < <(printf '%s' "$json" | python3 -c \
    "import sys,json;d=json.load(sys.stdin);print(d['Total']['code'],d.get('C++',{}).get('code',0))")
  td="$(find "$d" -name '*.td' -print0 2>/dev/null | xargs -0 cat 2>/dev/null | wc -l)"
  printf '%s\t%s\t%s\t%s\n' "$a" "$code" "$cpp" "$td" >> "$tmp"
done

# Full backend: llvm/ excluding test + unittests (tokei Code total).
BACKEND="$(tokei --exclude test --exclude unittests "$LLVM" 2>/dev/null \
  | awk '/^ Total/{print $(NF-2)}')"

python3 - "$tmp" "$BACKEND" <<'PY'
import sys
rows=[l.rstrip('\n').split('\t') for l in open(sys.argv[1])]
rows=[(r[0],int(r[1]),int(r[2]),int(r[3])) for r in rows]
rows.sort(key=lambda r:-r[1])
backend=int(sys.argv[2])
tc=sum(r[1] for r in rows); tcpp=sum(r[2] for r in rows); ttd=sum(r[3] for r in rows)
print(f"{'Architecture':13}{'Code':>9}{'C++':>9}{'TableGen':>10}{'%tgt':>7}")
for a,code,cpp,td in rows:
    print(f"{a:13}{code:>9}{cpp:>9}{td:>10}{100*code/tc:>6.1f}%")
print("-"*48)
print(f"{'target-specific sum':13}{tc:>9}{tcpp:>9}{ttd:>10}")
print(f"target-independent core = {backend} - {tc} = {backend-tc}")
print(f"full backend (llvm/ excl test+unittests) = {backend}")
print(f"target-specific fraction of backend = {100*tc/backend:.1f}%")
PY
