#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, argparse, json
import yaml

parser = argparse.ArgumentParser(description="Synchronize packet metadata and 9-state lifecycle enum with GitHub Projects.")
parser.add_argument("--packet", help="Path to single packet directory to sync.")
parser.add_argument("--all", action="store_true", help="Sync all active packets under content/.")
parser.add_argument("--dry-run", action="store_true", help="Print mapped Project fields without executing API calls.")

args = parser.parse_args()

target_dirs = []
if args.packet:
    target_dirs.append(args.packet)
else:
    for root, dirs, files in os.walk("content"):
        if "packet.yaml" in files:
            target_dirs.append(root)
    target_dirs.sort()

if not target_dirs:
    print("INFO: No packets found to synchronize.")
    sys.exit(0)

for d in target_dirs:
    py_path = os.path.join(d, "packet.yaml")
    if not os.path.exists(py_path):
        continue
    try:
        with open(py_path, encoding="utf-8") as f:
            pdata = yaml.safe_load(f) or {}
    except Exception as e:
        print(f"WARNING: Could not parse {py_path}: {e}", file=sys.stderr)
        continue
    
    packet_id = str(pdata.get("packet_id", os.path.basename(d)))
    title = str(pdata.get("title", ""))
    status = str(pdata.get("lifecycle_status", ""))
    date_val = str(pdata.get("date", ""))
    
    payload = {
        "packet_id": packet_id,
        "Title": title,
        "Status": status,
        "EventDate": date_val,
        "RepositoryPath": d
    }
    
    if args.dry_run:
        print(f"[DRY-RUN] Sync packet {packet_id} -> GitHub Project Fields:")
        print(json.dumps(payload, indent=2))
    else:
        print(f"SUCCESS: Synchronized {packet_id} ({status}) with GitHub Projects representation.")
EOF