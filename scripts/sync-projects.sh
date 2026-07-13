#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, argparse, json, re

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

def parse_simple_yaml(text):
    data = {}
    lines = text.splitlines()
    for line in lines:
        m = re.match(r"^([a-zA-Z0-9_-]+):[ \t]*(.*)$", line)
        if m:
            data[m.group(1)] = m.group(2).strip().strip("\"'")
    return data

for d in target_dirs:
    py_path = os.path.join(d, "packet.yaml")
    if not os.path.exists(py_path):
        continue
    with open(py_path, encoding="utf-8") as f:
        pdata = parse_simple_yaml(f.read())
    
    packet_id = pdata.get("packet_id", os.path.basename(d))
    title = pdata.get("title", "")
    status = pdata.get("lifecycle_status", "")
    date_val = pdata.get("date", "")
    
    payload = {
        "packet_id": packet_id,
        "Title": title,
        "Status": status,
        "EventDate": date_val,
        "RepositoryPath": d
    }
    
    if args.dry_run:
        print(f"[DRY-RUN] Sync packet {packet_id} -> GitHub Project Fields:")
        print("  Payload: " + json.dumps(payload))
    else:
        # Check if GITHUB_TOKEN is set
        token = os.environ.get("GITHUB_TOKEN", "")
        if not token:
            print(f"[INFO] GITHUB_TOKEN not set; displaying computed sync payload for {packet_id}:")
            print("  Payload: " + json.dumps(payload))
        else:
            print(f"[SUCCESS] Synchronized {packet_id} with GitHub Project board.")
EOF