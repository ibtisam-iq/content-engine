#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, argparse
import yaml

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
                pdata = yaml.safe_load(f) or {}
        except Exception:
            continue
        tax = pdata.get("taxonomy", {}) or {}
        packets.append({
            "id": str(pdata.get("packet_id", os.path.basename(root))),
            "path": os.path.relpath(root, "."),
            "tags": set(tax.get("tags", []) or []),
            "pillars": set(tax.get("pillars", []) or []),
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
