#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
CONTENT_DIR="${REPO_ROOT}/content"

# Extract a YAML scalar field (same semantics as validate-packet.sh).
extract_field() {
  local file="${1}" field="${2}"
  [[ -f "$file" ]] || return 0
  grep -E "^${field}:" "$file" | head -n1 |
    sed -E "s/^${field}:[[:space:]]*//" |
    sed -E 's/^"//; s/"$//' |
    sed -E 's/[[:space:]]*#.*$//'
}

# Parse a YAML list literal like [a, b, "c d"] into a space-separated set
# of words. Quoted entries containing spaces are kept intact.
parse_list() {
  local raw="$1"
  # Strip surrounding brackets/quotes/spaces.
  raw="${raw#\[}"
  raw="${raw%\]}"
  raw="$(echo "$raw" | sed -E "s/\"//g; s/,/ /g; s/^[[:space:]]*//; s/[[:space:]]*$//")"
  echo "$raw"
}

usage() {
  cat <<'EOF'
Usage: ./scripts/suggest-reuse.sh [options]

Scans all packets and reports pairs that share tags, pillars, or a series,
which are good candidates for reuse/adaptation.

Options:
  --packet <dir>   Restrict suggestions to packets related to this one
                   (still compares against all others).
  --min-score N    Minimum shared-signal score to report (default: 1).
  --format text|csv   Output format (default: text).
  --help           Show this help.
EOF
}

TARGET=""
MIN_SCORE=1
FORMAT="text"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --packet) TARGET="${2:-}"; shift 2 ;;
    --min-score) MIN_SCORE="${2:-1}"; shift 2 ;;
    --format) FORMAT="${2:-text}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

# Collect all packet.yaml paths.
shopt -s nullglob
PACKETS=()
while IFS= read -r -d '' file; do
  PACKETS+=("$file")
done < <(find "$CONTENT_DIR" -type f -name packet.yaml -print0 | sort -z)

if [[ ${#PACKETS[@]} -eq 0 ]]; then
  echo "No packets found under $CONTENT_DIR" >&2
  exit 1
fi

declare -a IDS TAGSETS PILLARSETS SERIESSETS
idx=0
for yaml in "${PACKETS[@]}"; do
  id="$(extract_field "$yaml" packet_id)"
  IDS[$idx]="$id"
  TAGSETS[$idx]="$(parse_list "$(extract_field "$yaml" tags)")"
  PILLARSETS[$idx]="$(parse_list "$(extract_field "$yaml" pillars)")"
  SERIESSETS[$idx]="$(extract_field "$yaml" series)"
  ((idx++)) || true
done

overlap() {
  # Returns count of shared words between two space-separated sets.
  local a="$1" b="$2" n=0 w
  [[ -z "$a" || -z "$b" ]] && { echo 0; return; }
  for w in $a; do
    for v in $b; do
      [[ "$w" == "$v" ]] && { ((n++)) || true; break; }
    done
  done
  echo "$n"
}

# Header for CSV
if [[ "$FORMAT" == "csv" ]]; then
  echo "packet_a,packet_b,shared_tags,shared_pillars,shared_series,score"
fi

found=0
for ((i=0; i<${#IDS[@]}; i++)); do
  for ((j=i+1; j<${#IDS[@]}; j++)); do
    # If a target is set, at least one side must match it.
    if [[ -n "$TARGET" ]]; then
      tdir="${REPO_ROOT}/${TARGET}/packet.yaml"
      tid="$(extract_field "$tdir" packet_id 2>/dev/null || true)"
      [[ "$tid" != "${IDS[$i]}" && "$tid" != "${IDS[$j]}" ]] && continue
    fi

    st=$(overlap "${TAGSETS[$i]}" "${TAGSETS[$j]}")
    sp=$(overlap "${PILLARSETS[$i]}" "${PILLARSETS[$j]}")
    ss=0
    if [[ -n "${SERIESSETS[$i]}" && "${SERIESSETS[$i]}" == "${SERIESSETS[$j]}" ]]; then
      ss=1
    fi
    score=$(( st + sp + 2*ss ))

    if [[ $score -ge $MIN_SCORE ]]; then
      found=1
      if [[ "$FORMAT" == "csv" ]]; then
        echo "${IDS[$i]},${IDS[$j]},$st,$sp,$ss,$score"
      else
        echo "${IDS[$i]}  <->  ${IDS[$j]}"
        [[ $st -gt 0 ]] && echo "    shared tags: $st"
        [[ $sp -gt 0 ]] && echo "    shared pillars: $sp"
        [[ $ss -gt 0 ]] && echo "    shared series: ${SERIESSETS[$i]}"
        echo "    score: $score"
        echo
      fi
    fi
  done
done

if [[ $found -eq 0 ]]; then
  echo "No reuse candidates found (min-score=$MIN_SCORE)."
fi
