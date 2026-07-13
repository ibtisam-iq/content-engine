#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, json, re
from datetime import datetime, timezone

def parse_simple_yaml(text):
    data = {}
    current_key = None
    current_obj = None
    lines = text.splitlines()
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            i += 1
            continue
        if line.startswith("  - ") or line.startswith("    - "):
            val = stripped[2:].strip().strip("\"'")
            if isinstance(current_obj, list):
                current_obj.append(val)
            i += 1
            continue
        m_top = re.match(r"^([a-zA-Z0-9_-]+):[ \t]*(.*)$", line)
        if m_top:
            key = m_top.group(1)
            raw_val = m_top.group(2).strip()
            raw_val = re.sub(r"[ \t]+#.*$", "", raw_val).strip()
            if not raw_val:
                if i + 1 < len(lines) and lines[i + 1].strip().startswith("- "):
                    data[key] = []
                    current_obj = data[key]
                else:
                    data[key] = {}
            elif raw_val.startswith("[") and raw_val.endswith("]"):
                inner = raw_val[1:-1].strip()
                if not inner:
                    data[key] = []
                else:
                    data[key] = [x.strip().strip("\"'") for x in inner.split(",") if x.strip()]
            else:
                data[key] = raw_val.strip("\"'")
            current_key = key
            i += 1
            continue
        i += 1
    return data

packets = []
for root, dirs, files in os.walk("content"):
    if "packet.yaml" in files:
        py_path = os.path.join(root, "packet.yaml")
        with open(py_path, encoding="utf-8") as f:
            pdata = parse_simple_yaml(f.read())
        
        packet_entry = {
            "packet_id": pdata.get("packet_id", os.path.basename(root)),
            "title": pdata.get("title", ""),
            "date": pdata.get("date", ""),
            "topic": pdata.get("topic", ""),
            "lifecycle_status": pdata.get("lifecycle_status", ""),
            "path": root,
            "pillars": pdata.get("pillars", []) if isinstance(pdata.get("pillars"), list) else [],
            "channels": pdata.get("channels_manifest", []) if isinstance(pdata.get("channels_manifest"), list) else []
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
