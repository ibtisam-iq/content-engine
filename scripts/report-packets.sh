#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Helper: usage
usage() {
  cat <<EOF
Usage: $0 [--status <status>] [--tag <tag>] [--pillar <pillar>]
  Generate a summary report of packets.
  Options can be repeated to filter on multiple values.
EOF
  exit 1
}

# Parse arguments
FILTER_STATUS=()
FILTER_TAGS=()
FILTER_PILLARS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    --status)
      FILTER_STATUS+=("$2")
      shift 2
      ;;
    --tag)
      FILTER_TAGS+=("$2")
      shift 2
      ;;
    --pillar)
      FILTER_PILLARS+=("$2")
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done

# Find all packet.yaml files
declare -a PACKETS
while IFS= read -r -d '' file; do
  PACKETS+=("$file")
 done < <(find "$REPO_ROOT/content" -type f -name packet.yaml -print0)

# Header
printf "%s\t%s\t%s\t%s\t%s\t%s\n" "Packet ID" "Status" "Tags" "Pillars" "Metrics" "Path"

for yaml in "${PACKETS[@]}"; do
  # Load fields using grep & sed (lightweight parsing)
  packet_id=$(grep -E '^packet_id:' "$yaml" | cut -d' ' -f2- | tr -d '"')
  status=$(grep -E '^status:' "$yaml" | cut -d' ' -f2- | tr -d '"')
  tags=$(grep -E '^tags:' "$yaml" | sed -E 's/^tags:\s*\[?(.*)\]?/\1/' | tr -d '"')
  pillars=$(grep -E '^pillars:' "$yaml" | sed -E 's/^pillars:\s*\[?(.*)\]?/\1/' | tr -d '"')
  metrics=$(grep -E '^metrics:' "$yaml" | cut -d' ' -f2- | tr -d '"')

  # Apply filters
  if [[ ${#FILTER_STATUS[@]} -gt 0 ]]; then
    match=false
    for f in "${FILTER_STATUS[@]}"; do
      [[ "$status" == "$f" ]] && match=true && break
    done
    $match || continue
  fi
  if [[ ${#FILTER_TAGS[@]} -gt 0 ]]; then
    match=false
    for t in "${FILTER_TAGS[@]}"; do
      [[ "$tags" == *"$t"* ]] && match=true && break
    done
    $match || continue
  fi
  if [[ ${#FILTER_PILLARS[@]} -gt 0 ]]; then
    match=false
    for p in "${FILTER_PILLARS[@]}"; do
      [[ "$pillars" == *"$p"* ]] && match=true && break
    done
    $match || continue
  fi

  rel_path=$(realpath --relative-to "$REPO_ROOT" "$yaml")
  printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$packet_id" "$status" "$tags" "$pillars" "$metrics" "$rel_path"

done | column -t -s $'\t'

# End of report
