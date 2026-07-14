#!/usr/bin/env bash
# Script: validate-packet.sh
# Role: Validates packet.yaml and channel front matter against schemas, lifecycle enums, manifest integrity, and typography rules.
# Inputs: --packet <path> or --all. Outputs: Exits non-zero on invariant violation; prints validation summary.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, argparse, re

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
        m_ind = re.match(r"^([ \t]+)([a-zA-Z0-9_-]+):[ \t]*(.*)$", line)
        if m_ind and current_key and isinstance(data.get(current_key), dict):
            k = m_ind.group(2)
            v = m_ind.group(3).strip().strip("\"'")
            if not v:
                data[current_key][k] = []
            else:
                data[current_key][k] = v
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

VALID_LIFECYCLE = {
    "idea", "briefing", "drafting", "review", "ready",
    "distributing", "published", "evergreen", "archived"
}

VALID_CHANNEL_STATUS = {
    "draft", "review", "ready", "scheduled", "published", "archived"
}

VALID_PLATFORMS = {"linkedin", "x", "facebook", "blog", "newsletter"}
VALID_FORMATS = {"post", "thread", "carousel", "article", "newsletter"}

def validate_packet(packet_dir):
    errors = 0
    rel_path = os.path.relpath(packet_dir, os.getcwd())
    packet_yaml = os.path.join(packet_dir, "packet.yaml")
    if not os.path.exists(packet_yaml):
        print(f"ERROR [{rel_path}]: missing packet.yaml", file=sys.stderr)
        return 1
    
    em_dash = "\u2014"
    for root, _, files in os.walk(packet_dir):
        for fname in files:
            if fname.endswith(".md") or fname.endswith(".yaml") or fname.endswith(".yml"):
                fpath = os.path.join(root, fname)
                with open(fpath, encoding="utf-8", errors="ignore") as f:
                    c = f.read()
                    if em_dash in c:
                        print(f"ERROR [{os.path.relpath(fpath)}]: contains forbidden em dash character", file=sys.stderr)
                        errors += 1

    with open(packet_yaml, encoding="utf-8") as f:
        py_content = f.read()
    data = parse_simple_yaml(py_content)
    
    req_fields = ["packet_id", "title", "date", "topic", "lifecycle_status"]
    for rf in req_fields:
        if rf not in data or not data[rf]:
            print(f"ERROR [{rel_path}/packet.yaml]: missing required field {rf}", file=sys.stderr)
            errors += 1
            
    status = data.get("lifecycle_status", "")
    if status and status not in VALID_LIFECYCLE:
        print(f"ERROR [{rel_path}/packet.yaml]: invalid lifecycle_status '{status}'", file=sys.stderr)
        errors += 1
        
    manifest = data.get("channels_manifest", [])
    if isinstance(manifest, list):
        for ch_rel in manifest:
            ch_full = os.path.join(packet_dir, ch_rel)
            if not os.path.exists(ch_full):
                print(f"ERROR [{rel_path}/packet.yaml]: manifest file not found: {ch_rel}", file=sys.stderr)
                errors += 1
            else:
                with open(ch_full, encoding="utf-8") as cf:
                    ch_text = cf.read()
                parts = ch_text.split("---")
                if len(parts) < 3:
                    print(f"ERROR [{os.path.relpath(ch_full)}]: missing YAML front matter delimiters", file=sys.stderr)
                    errors += 1
                else:
                    cfm = parse_simple_yaml(parts[1])
                    for crf in ["channel_id", "platform", "format", "source_packet", "channel_status"]:
                        if crf not in cfm or not cfm[crf]:
                            print(f"ERROR [{os.path.relpath(ch_full)}]: missing front matter field {crf}", file=sys.stderr)
                            errors += 1
                    if cfm.get("platform") and cfm["platform"] not in VALID_PLATFORMS:
                        print(f"ERROR [{os.path.relpath(ch_full)}]: invalid platform '{cfm['platform']}'", file=sys.stderr)
                        errors += 1
                    if cfm.get("format") and cfm["format"] not in VALID_FORMATS:
                        print(f"ERROR [{os.path.relpath(ch_full)}]: invalid format '{cfm['format']}'", file=sys.stderr)
                        errors += 1
                    if cfm.get("channel_status") and cfm["channel_status"] not in VALID_CHANNEL_STATUS:
                        print(f"ERROR [{os.path.relpath(ch_full)}]: invalid channel_status '{cfm['channel_status']}'", file=sys.stderr)
                        errors += 1
    return errors

parser = argparse.ArgumentParser(description="Validate content packets against schema and invariants.")
parser.add_argument("--packet", help="Path to a single packet directory to validate.")
parser.add_argument("--all", action="store_true", help="Validate all active packets under content/.")
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
    print("INFO: No packets found to validate.")
    sys.exit(0)

total_errors = 0
for d in target_dirs:
    err = validate_packet(d)
    total_errors += err
    if err == 0:
        print(f"PASS: {d}")

if total_errors > 0:
    print(f"VALIDATION FAILED: {total_errors} error(s) found.", file=sys.stderr)
    sys.exit(1)
else:
    print(f"VALIDATION PASSED: {len(target_dirs)} packet(s) verified.")
    sys.exit(0)
EOF
