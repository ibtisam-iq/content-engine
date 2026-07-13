#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, argparse
import yaml

parser = argparse.ArgumentParser(description="Generate a summary report of content packets.")
parser.add_argument("--status", action="append", default=[], help="Filter by lifecycle status")
parser.add_argument("--tag", action="append", default=[], help="Filter by tag")
parser.add_argument("--pillar", action="append", default=[], help="Filter by pillar")
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
        metrics = pdata.get("aggregate_metrics", {}) or {}

        status = str(pdata.get("lifecycle_status", "")).strip()
        tags = tax.get("tags", []) or []
        pillars = tax.get("pillars", []) or []

        if args.status and status not in args.status:
            continue
        if args.tag and not any(t in tags for t in args.tag):
            continue
        if args.pillar and not any(p in pillars for p in args.pillar):
            continue

        impressions = metrics.get("total_impressions", 0)
        engagements = metrics.get("total_engagements", 0)
        metrics_str = f"i:{impressions}/e:{engagements}"

        packets.append({
            "packet_id": str(pdata.get("packet_id", os.path.basename(root))),
            "status": status,
            "tags": ", ".join(tags) if tags else "N/A",
            "pillars": ", ".join(pillars) if pillars else "N/A",
            "metrics": metrics_str,
            "path": os.path.relpath(root, ".")
        })

packets.sort(key=lambda x: x["packet_id"], reverse=True)

print(f"{'Packet ID':<30} {'Status':<12} {'Tags':<25} {'Pillars':<25} {'Metrics':<15} {'Path'}")
print("-" * 125)
for p in packets:
    print(f"{p['packet_id']:<30} {p['status']:<12} {p['tags']:<25} {p['pillars']:<25} {p['metrics']:<15} {p['path']}")
EOF
