#!/usr/bin/env bash
# Script: report-packets.sh
# Role: Scans active packets under content/ and renders a formatted ASCII summary table of status, taxonomy, and metrics.
# Inputs: --status, --tag, --pillar filters. Outputs: Formatted summary report to stdout.
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
                c_str = f.read()
            pdata = (yaml.safe_load(c_str) or {}) if has_yaml else fallback_parse_packet_yaml(c_str)
        except Exception:
            continue
        
        tax = pdata.get("taxonomy", {}) if isinstance(pdata.get("taxonomy"), dict) else {}
        metrics = pdata.get("aggregate_metrics", {}) if isinstance(pdata.get("aggregate_metrics"), dict) else {}

        status = str(pdata.get("lifecycle_status", "")).strip()
        tags = tax.get("tags", []) if isinstance(tax.get("tags"), list) else []
        pillars = tax.get("pillars", []) if isinstance(tax.get("pillars"), list) else []

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
