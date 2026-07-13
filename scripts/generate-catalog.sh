#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, json
from datetime import datetime, timezone
import yaml

packets = []
for root, dirs, files in os.walk("content"):
    if "packet.yaml" in files:
        py_path = os.path.join(root, "packet.yaml")
        try:
            with open(py_path, encoding="utf-8") as f:
                pdata = yaml.safe_load(f) or {}
        except Exception as e:
            print(f"WARNING: Could not parse {py_path}: {e}", file=sys.stderr)
            continue
        
        taxonomy = pdata.get("taxonomy", {}) or {}
        lineage = pdata.get("lineage", {}) or {}
        governance = pdata.get("governance", {}) or {}
        metrics = pdata.get("aggregate_metrics", {}) or {}

        packet_entry = {
            "packet_id": pdata.get("packet_id", os.path.basename(root)),
            "title": pdata.get("title", ""),
            "date": pdata.get("date", ""),
            "topic": pdata.get("topic", ""),
            "lifecycle_status": pdata.get("lifecycle_status", ""),
            "path": root,
            "taxonomy": {
                "pillars": taxonomy.get("pillars", []) or [],
                "tags": taxonomy.get("tags", []) or [],
                "campaign": taxonomy.get("campaign", "") or "",
                "series": taxonomy.get("series", "") or ""
            },
            "lineage": {
                "repurposed_from": lineage.get("repurposed_from", "") or "",
                "related_project": lineage.get("related_project", "") or ""
            },
            "governance": {
                "created_at": governance.get("created_at", "") or "",
                "updated_at": governance.get("updated_at", "") or "",
                "author": governance.get("author", "content-engine") or "content-engine"
            },
            "aggregate_metrics": {
                "total_impressions": metrics.get("total_impressions", 0) or 0,
                "total_engagements": metrics.get("total_engagements", 0) or 0,
                "last_updated": metrics.get("last_updated", "") or ""
            },
            "channels": pdata.get("channels_manifest", []) or []
        }
        packets.append(packet_entry)

packets.sort(key=lambda x: x["date"], reverse=True)

now_iso = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
catalog_payload = {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "generated_at": now_iso,
    "total_packets": len(packets),
    "packets": packets
}

out_path = os.path.join("registry", "catalog.json")
with open(out_path, "w", encoding="utf-8") as f:
    json.dump(catalog_payload, f, indent=2)
    f.write("\n")

print(f"SUCCESS: Generated registry/catalog.json indexing {len(packets)} packet(s).")
EOF
