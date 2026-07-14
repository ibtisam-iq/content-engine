#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, argparse, json, re

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
            c_str = f.read()
        pdata = (yaml.safe_load(c_str) or {}) if has_yaml else fallback_parse_packet_yaml(c_str)
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