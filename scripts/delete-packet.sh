#!/usr/bin/env bash
# Script: delete-packet.sh
# Role: Permanently removes a target content packet directory, prunes empty month/year folders, and re-indexes the catalog.
# Inputs: --packet (ID or relative path). Outputs: Removes target folder under content/ and regenerates registry/catalog.json.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, argparse, shutil, subprocess

parser = argparse.ArgumentParser(description="Delete a content packet and update registry/catalog.json.")
parser.add_argument("--packet", required=True, help="Packet ID (YYYY-MM-DD-slug) or directory path under content/.")
args = parser.parse_args()

target = args.packet.strip().rstrip("/")

packet_dir = ""
if os.path.isdir(target) and os.path.exists(os.path.join(target, "packet.yaml")):
    packet_dir = target
else:
    for root, dirs, files in os.walk("content"):
        if "packet.yaml" in files:
            if os.path.basename(root) == target or os.path.relpath(root, ".") == target:
                packet_dir = root
                break

if not packet_dir or not os.path.exists(packet_dir):
    print(f"ERROR: Could not locate packet directory matching '{args.packet}'.", file=sys.stderr)
    sys.exit(1)

print(f"INFO: Deleting content packet at {packet_dir}")
shutil.rmtree(packet_dir)

# Clean up empty parent directories (MM and YYYY) under content/
parent_mm = os.path.dirname(packet_dir)
if os.path.exists(parent_mm) and not os.listdir(parent_mm):
    os.rmdir(parent_mm)
    parent_yyyy = os.path.dirname(parent_mm)
    if os.path.exists(parent_yyyy) and not os.listdir(parent_yyyy):
        os.rmdir(parent_yyyy)

cat_script = os.path.join("scripts", "generate-catalog.sh")
if os.path.exists(cat_script):
    subprocess.run([cat_script], check=True)

print(f"SUCCESS: Deleted content packet '{args.packet}' and updated catalog.")
EOF
