#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, argparse, re
from datetime import datetime, timezone

parser = argparse.ArgumentParser(description="Update channel telemetry metrics and roll up packet aggregates.")
parser.add_argument("--packet", required=True, help="Path to packet directory.")
parser.add_argument("--channel", help="Relative path to channel file inside packet (e.g. channels/linkedin.md).")
parser.add_argument("--impressions", type=int, default=0, help="Number of impressions.")
parser.add_argument("--engagements", type=int, default=0, help="Number of engagements.")
parser.add_argument("--likes", type=int, default=0, help="Number of likes.")
parser.add_argument("--comments", type=int, default=0, help="Number of comments.")
parser.add_argument("--shares", type=int, default=0, help="Number of shares.")
parser.add_argument("--rollup-only", action="store_true", help="Only recompute aggregate_metrics across all channels.")

args = parser.parse_args()

packet_dir = args.packet
if not os.path.exists(packet_dir):
    print(f"ERROR: Packet directory not found: {packet_dir}", file=sys.stderr)
    sys.exit(1)

now_iso = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

if not args.rollup_only and args.channel:
    ch_path = os.path.join(packet_dir, args.channel)
    if not os.path.exists(ch_path):
        print(f"ERROR: Channel file not found: {ch_path}", file=sys.stderr)
        sys.exit(1)
        
    with open(ch_path, encoding="utf-8") as f:
        content = f.read()
        
    new_metrics_block = f'''performance_metrics:
  impressions: {args.impressions}
  engagements: {args.engagements}
  likes: {args.likes}
  comments: {args.comments}
  shares: {args.shares}
  last_measured_at: "{now_iso}"'''
    
    updated_content = re.sub(
        r"performance_metrics:\s*\n(?:[ \t]+[a-zA-Z0-9_-]+:.*(?:\n|$))+",
        new_metrics_block + "\n",
        content
    )
    with open(ch_path, "w", encoding="utf-8") as f:
        f.write(updated_content)
    print(f"SUCCESS: Updated metrics for {args.channel}")

total_imp = 0
total_eng = 0

channels_dir = os.path.join(packet_dir, "channels")
if os.path.exists(channels_dir):
    for cf in os.listdir(channels_dir):
        if cf.endswith(".md"):
            cf_path = os.path.join(channels_dir, cf)
            with open(cf_path, encoding="utf-8") as f:
                c = f.read()
            m_imp = re.search(r"impressions:\s*(\d+)", c)
            m_eng = re.search(r"engagements:\s*(\d+)", c)
            if m_imp:
                total_imp += int(m_imp.group(1))
            if m_eng:
                total_eng += int(m_eng.group(1))

py_path = os.path.join(packet_dir, "packet.yaml")
if os.path.exists(py_path):
    with open(py_path, encoding="utf-8") as f:
        py_content = f.read()
        
    new_agg = f'''aggregate_metrics:
  total_impressions: {total_imp}
  total_engagements: {total_eng}
  last_updated: "{now_iso}"'''
  
    updated_py = re.sub(
        r"aggregate_metrics:\s*\n(?:[ \t]+[a-zA-Z0-9_-]+:.*(?:\n|$))+",
        new_agg + "\n",
        py_content
    )
    with open(py_path, "w", encoding="utf-8") as f:
        f.write(updated_py)
    print(f"SUCCESS: Rolled up aggregate_metrics in packet.yaml (impressions={total_imp}, engagements={total_eng})")
EOF
