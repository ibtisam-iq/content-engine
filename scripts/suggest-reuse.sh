#!/usr/bin/env bash
# Script: suggest-reuse.sh
# Role: Computes shared-signal scores across content packets to recommend repurposing and cross-linking pairs.
# Inputs: --min-score, --packet filters. Outputs: Candidate packet pairs in text or CSV format.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, argparse, re

try:
    import yaml
    has_yaml = True
except ImportError:
    has_yaml = False

def fallback_parse_packet_yaml(text):
    data = {}
    current_dict = data
    current_key = None
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        indent = len(line) - len(line.lstrip(" "))
        m_kv = re.match(r"^([a-zA-Z0-9_-]+):\s*(.*)$", stripped)
        if m_kv:
            key, val = m_kv.group(1), m_kv.group(2).strip().strip('"\'')
            if indent == 0:
                if not val:
                    data[key] = {}
                    current_dict = data[key]
                else:
                    data[key] = val
            else:
                if not val:
                    current_dict[key] = []
                else:
                    current_dict[key] = val
            current_key = key
        elif stripped.startswith("- "):
            item = stripped[2:].strip().strip('"\'')
            if current_key and isinstance(current_dict.get(current_key), list):
                current_dict[current_key].append(item)
            elif current_key and current_key not in current_dict:
                current_dict[current_key] = [item]
    return data

parser = argparse.ArgumentParser(description="Scan content packets and report pairs that share tags, pillars, or series.")
parser.add_argument("--packet", default="", help="Restrict suggestions to pairs involving this packet directory")
parser.add_argument("--min-score", type=int, default=1, help="Minimum shared-signal score to report (default: 1)")
parser.add_argument("--format", choices=["text", "csv"], default="text", help="Output format (default: text)")
args = parser.parse_args()

packets = []
for root, dirs, files in os.walk("content"):
    if "packet.yaml" in files:
        py_path = os.path.join(root, "packet.yaml")
        try:
            with open(py_path, encoding="utf-8") as f:
                c_str = f.read()
            pdata = (yaml.safe_load(c_str) or {}) if has_yaml else fallback_parse_packet_yaml(c_str)
        except Exception:
            continue
        tax = pdata.get("taxonomy", {}) if isinstance(pdata.get("taxonomy"), dict) else {}
        packets.append({
            "id": str(pdata.get("packet_id", os.path.basename(root))),
            "path": os.path.relpath(root, "."),
            "tags": set(tax.get("tags", []) if isinstance(tax.get("tags"), list) else []),
            "pillars": set(tax.get("pillars", []) if isinstance(tax.get("pillars"), list) else []),
            "series": str(tax.get("series", "")).strip()
        })

packets.sort(key=lambda x: x["id"])

if args.format == "csv":
    print("packet_a,packet_b,shared_tags,shared_pillars,shared_series,score")

found = 0
for i in range(len(packets)):
    for j in range(i + 1, len(packets)):
        pa, pb = packets[i], packets[j]
        if args.packet:
            target_clean = args.packet.rstrip("/")
            if pa["path"] != target_clean and pb["path"] != target_clean:
                continue
        
        st = len(pa["tags"].intersection(pb["tags"]))
        sp = len(pa["pillars"].intersection(pb["pillars"]))
        ss = 1 if (pa["series"] and pa["series"] == pb["series"]) else 0
        score = st + sp + (2 * ss)

        if score >= args.min_score:
            found = 1
            if args.format == "csv":
                print(f"{pa['id']},{pb['id']},{st},{sp},{ss},{score}")
            else:
                print(f"{pa['id']}  <->  {pb['id']}")
                if st > 0:
                    print(f"    shared tags: {st} ({', '.join(sorted(pa['tags'].intersection(pb['tags'])))})")
                if sp > 0:
                    print(f"    shared pillars: {sp} ({', '.join(sorted(pa['pillars'].intersection(pb['pillars'])))})")
                if ss > 0:
                    print(f"    shared series: {pa['series']}")
                print(f"    score: {score}\n")

if found == 0 and args.format != "csv":
    print(f"No reuse candidates found (min-score={args.min_score}).")
EOF
