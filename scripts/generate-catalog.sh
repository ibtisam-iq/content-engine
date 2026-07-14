#!/usr/bin/env bash
# Script: generate-catalog.sh
# Role: Scans all packet.yaml files under content/ to build the master registry/catalog.json index.
# Inputs: content/**/packet.yaml. Outputs: registry/catalog.json. Uses PyYAML when available or fallback standalone parser.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - <<'EOF'
import os, sys, json, re
from datetime import datetime, timezone

try:
    import yaml
    has_yaml = True
except ImportError:
    has_yaml = False

def fallback_parse_packet_yaml(text):
    data = {}
    current_dict = data
    stack = [data]
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

packets = []
for root, dirs, files in os.walk("content"):
    if "packet.yaml" in files:
        py_path = os.path.join(root, "packet.yaml")
        try:
            with open(py_path, encoding="utf-8") as f:
                content_str = f.read()
            if has_yaml:
                pdata = yaml.safe_load(content_str) or {}
            else:
                pdata = fallback_parse_packet_yaml(content_str)
        except Exception as e:
            print(f"WARNING: Skipping {py_path}: {e}", file=sys.stderr)
            continue
        
        tax = pdata.get("taxonomy", {}) if isinstance(pdata.get("taxonomy"), dict) else {}
        lin = pdata.get("lineage", {}) if isinstance(pdata.get("lineage"), dict) else {}
        gov = pdata.get("governance", {}) if isinstance(pdata.get("governance"), dict) else {}
        agg = pdata.get("aggregate_metrics", {}) if isinstance(pdata.get("aggregate_metrics"), dict) else {}

        ch_manifest = pdata.get("channels_manifest", [])
        if not isinstance(ch_manifest, list):
            ch_manifest = []

        pkt_entry = {
            "packet_id": str(pdata.get("packet_id", os.path.basename(root))),
            "title": str(pdata.get("title", "")),
            "date": str(pdata.get("date", "")),
            "topic": str(pdata.get("topic", "")),
            "lifecycle_status": str(pdata.get("lifecycle_status", "")),
            "path": os.path.relpath(root, "."),
            "taxonomy": {
                "pillars": tax.get("pillars", []) if isinstance(tax.get("pillars"), list) else [],
                "tags": tax.get("tags", []) if isinstance(tax.get("tags"), list) else [],
                "campaign": str(tax.get("campaign", "")),
                "series": str(tax.get("series", ""))
            },
            "lineage": {
                "repurposed_from": str(lin.get("repurposed_from", "")),
                "related_project": str(lin.get("related_project", ""))
            },
            "governance": {
                "created_at": str(gov.get("created_at", "")),
                "updated_at": str(gov.get("updated_at", "")),
                "author": str(gov.get("author", ""))
            },
            "aggregate_metrics": {
                "total_impressions": int(agg.get("total_impressions", 0)) if str(agg.get("total_impressions", 0)).isdigit() else 0,
                "total_engagements": int(agg.get("total_engagements", 0)) if str(agg.get("total_engagements", 0)).isdigit() else 0,
                "last_updated": str(agg.get("last_updated", ""))
            },
            "channels": ch_manifest
        }
        packets.append(pkt_entry)

packets.sort(key=lambda x: x["packet_id"], reverse=True)

now_iso = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
catalog_data = {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "generated_at": now_iso,
    "total_packets": len(packets),
    "packets": packets
}

os.makedirs("registry", exist_ok=True)
cat_path = os.path.join("registry", "catalog.json")
with open(cat_path, "w", encoding="utf-8") as f:
    json.dump(catalog_data, f, indent=2)

print(f"SUCCESS: Generated registry/catalog.json indexing {len(packets)} packet(s).")
EOF
