#!/usr/bin/env bash
# Script: create-packet.sh
# Role: Scaffolds new content packets or synchronizes existing packet files when metadata or channel targets change.
# Inputs: CLI arguments or issue body fields (--update, --from-issue). Outputs: content/YYYY/MM/<id>/ files and catalog index.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

python3 - "$@" <<'EOF'
import os, sys, argparse, re, json, shutil, subprocess, glob
from datetime import datetime, timezone

VALID_LIFECYCLE = [
    "idea", "briefing", "drafting", "review", "ready",
    "distributing", "published", "evergreen", "archived"
]

VALID_PLATFORMS = {"linkedin", "x", "facebook", "blog", "newsletter"}

PLATFORM_TEMPLATE_MAP = {
    "linkedin": "linkedin-post.md",
    "x": "x-post.md",
    "facebook": "facebook-post.md",
    "blog": "blog-article.md",
    "newsletter": "newsletter-issue.md"
}

parser = argparse.ArgumentParser(
    prog="create-packet.sh",
    description="Create or update a content packet under content/YYYY/MM/YYYY-MM-DD-topic-slug/."
)
parser.add_argument("--date", help="Publication/event date YYYY-MM-DD")
parser.add_argument("--topic", help="Topic slug (lowercase, hyphens)")
parser.add_argument("--title", help="Packet title")
parser.add_argument("--status", default="idea", choices=VALID_LIFECYCLE, help="Initial lifecycle status")
parser.add_argument("--context", default="", help="Strategic context text provided by issue intake or user")
parser.add_argument("--pillars", default="", help="Comma-separated pillars")
parser.add_argument("--tags", default="", help="Comma-separated tags")
parser.add_argument("--campaign", default="", help="Campaign name")
parser.add_argument("--series", default="", help="Series name")
parser.add_argument("--related-project", default="", help="Related project identifier (e.g. ISSUE-101)")
parser.add_argument("--platforms", default="linkedin,x,facebook,blog", help="Comma-separated target platforms")
parser.add_argument("--from-issue", default="", help="Create packet from GitHub issue number")
parser.add_argument("--from", dest="from_packet", default="", help="Clone from existing packet directory")
parser.add_argument("--author", default="", help="Author name or GitHub handle")
parser.add_argument("--update", action="store_true", help="Update existing packet if it already exists")

args = parser.parse_args()

def get_default_author():
    if args.author.strip():
        return args.author.strip()
    try:
        res = subprocess.run(["git", "config", "user.name"], capture_output=True, text=True)
        if res.returncode == 0 and res.stdout.strip():
            return res.stdout.strip()
    except Exception:
        pass
    return os.environ.get("USER", "content-engine")

author_val = get_default_author()

def parse_section_multiline(body, label):
    pattern = r"(?:###|\*\*)\s*" + re.escape(label) + r"(?:\*\*|)\s*\n+([\s\S]*?)(?=\n(?:###|\*\*)|\Z)"
    m = re.search(pattern, body, re.IGNORECASE)
    if m:
        val = m.group(1).strip()
        if val != "_No response_":
            return val
    return ""

def parse_checkboxes(section_text):
    selected = []
    for line in section_text.splitlines():
        if re.match(r"^\s*-\s*\[[xX]\]\s*", line):
            val = re.sub(r"^\s*-\s*\[[xX]\]\s*", "", line).strip().lower()
            selected.append(val)
    return selected

if args.from_issue:
    issue_num = args.from_issue.strip()
    print(f"INFO: Fetching Issue #{issue_num} metadata...")
    issue_data = None
    try:
        res = subprocess.run(["gh", "issue", "view", issue_num, "--json", "title,body"], capture_output=True, text=True)
        if res.returncode == 0:
            issue_data = json.loads(res.stdout)
    except Exception:
        pass

    if not issue_data and os.environ.get("GITHUB_TOKEN"):
        import urllib.request
        repo = os.environ.get("GITHUB_REPOSITORY", "ibtisam-iq/content-engine")
        url = f"https://api.github.com/repos/{repo}/issues/{issue_num}"
        req = urllib.request.Request(url, headers={"Authorization": f"token {os.environ['GITHUB_TOKEN']}", "User-Agent": "content-engine-cli"})
        try:
            with urllib.request.urlopen(req) as resp:
                issue_data = json.loads(resp.read().decode())
        except Exception as e:
            print(f"WARNING: Could not fetch issue #{issue_num} via API: {e}", file=sys.stderr)

    if issue_data:
        body_txt = issue_data.get("body", "")
        title_val = parse_section_multiline(body_txt, "Title")
        date_val = parse_section_multiline(body_txt, "Date")
        topic_val = parse_section_multiline(body_txt, "Topic Slug") or parse_section_multiline(body_txt, "Topic slug")
        status_val = parse_section_multiline(body_txt, "Initial Lifecycle Status") or parse_section_multiline(body_txt, "Status")
        context_val = parse_section_multiline(body_txt, "Strategic Context") or parse_section_multiline(body_txt, "Context")
        plat_section = parse_section_multiline(body_txt, "Target Platforms") or parse_section_multiline(body_txt, "Platforms")
        plat_checked = parse_checkboxes(plat_section)

        if not args.author:
            author_val = issue_data.get("author", {}).get("login") or issue_data.get("user", {}).get("login") or author_val
        if not args.title:
            args.title = title_val or issue_data.get("title") or f"Issue #{issue_num}"
        if status_val and args.status == "idea":
            clean_status = status_val.split("\n")[0].strip().lower()
            if clean_status in VALID_LIFECYCLE:
                args.status = clean_status
        if not args.date:
            args.date = date_val.split("\n")[0].strip() if date_val else ""
        if not args.topic:
            args.topic = topic_val.split("\n")[0].strip() if topic_val else f"issue-{issue_num}"
        if not args.context:
            args.context = context_val
        if plat_checked:
            args.platforms = ",".join(plat_checked)
        if not args.related_project:
            args.related_project = f"ISSUE-{issue_num}"

source_packet_id = ""
source_dir = ""
if args.from_packet:
    source_dir = args.from_packet.strip()
    if not os.path.exists(source_dir):
        print(f"ERROR: Source packet directory not found: {source_dir}", file=sys.stderr)
        sys.exit(1)
    source_packet_id = os.path.basename(source_dir.rstrip("/"))
    py_src = os.path.join(source_dir, "packet.yaml")
    if os.path.exists(py_src):
        with open(py_src, encoding="utf-8") as f:
            src_content = f.read()
        m_title = re.search(r"^title:\s*\"?([^\"]+)\"?", src_content, re.M)
        if m_title and not args.title:
            args.title = f"Repurposed: {m_title.group(1)}"

date_str = args.date.strip() if args.date else ""
if not date_str:
    date_str = input("Enter packet date (YYYY-MM-DD): ").strip()

if not re.match(r"^\d{4}-\d{2}-\d{2}$", date_str):
    print("ERROR: Date must be in YYYY-MM-DD format.", file=sys.stderr)
    sys.exit(1)

topic_str = args.topic.strip() if args.topic else ""
if not topic_str:
    topic_str = input("Enter topic slug (lowercase, hyphens): ").strip()

if not re.match(r"^[a-z0-9]+(-[a-z0-9]+)*$", topic_str):
    print("ERROR: Topic slug must contain only lowercase letters, digits, and hyphens.", file=sys.stderr)
    sys.exit(1)

title_str = args.title.strip() if args.title else ""
if not title_str:
    title_str = input("Enter packet title: ").strip()
    if not title_str:
        title_str = f"Content Event: {topic_str}"

year, month, _ = date_str.split("-")
packet_id = f"{date_str}-{topic_str}"
packet_dir = os.path.join("content", year, month, packet_id)

existing_packet_dir = ""
if os.path.exists(packet_dir):
    existing_packet_dir = packet_dir
elif args.related_project.strip():
    target_rel = args.related_project.strip()
    for py_file in glob.glob("content/*/*/*/packet.yaml"):
        with open(py_file, encoding="utf-8") as f:
            c = f.read()
        if f'related_project: "{target_rel}"' in c:
            existing_packet_dir = os.path.dirname(py_file)
            break

now_iso = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

def format_yaml_field(key, items, indent=2):
    pad = " " * indent
    if not items:
        return f"{pad}{key}: []"
    lines = [f"{pad}{key}:"]
    for item in items:
        lines.append(f"{pad}  - {item}")
    return "\n".join(lines)

def run_catalog_sync():
    cat_script = os.path.join("scripts", "generate-catalog.sh")
    if os.path.exists(cat_script):
        subprocess.run([cat_script], capture_output=True)

pillars_list = [p.strip() for p in args.pillars.split(",") if p.strip()]
tags_list = [t.strip() for t in args.tags.split(",") if t.strip()]
platforms_list = [p.strip().lower() for p in args.platforms.split(",") if p.strip()]

if existing_packet_dir:
    if not args.update:
        print(f"ERROR: Packet directory already exists: {existing_packet_dir}. Use --update to synchronize changes.", file=sys.stderr)
        sys.exit(1)
    if existing_packet_dir != packet_dir:
        print(f"INFO: Renaming packet directory from {existing_packet_dir} to {packet_dir}")
        os.makedirs(os.path.dirname(packet_dir), exist_ok=True)
        os.rename(existing_packet_dir, packet_dir)
    else:
        print(f"INFO: Synchronizing updates into existing packet at {packet_dir}")

    py_path = os.path.join(packet_dir, "packet.yaml")
    with open(py_path, encoding="utf-8") as f:
        py_content = f.read()

    # Prune unchecked draft channels
    for f_ch in glob.glob(os.path.join(packet_dir, "channels", "*.md")):
        p_name = os.path.splitext(os.path.basename(f_ch))[0]
        if platforms_list and p_name not in platforms_list:
            with open(f_ch, encoding="utf-8") as cf:
                cf_text = cf.read()
            if 'channel_status: "draft"' in cf_text:
                print(f"INFO: Removing unchecked draft channel {p_name}.md")
                os.remove(f_ch)

    # Generate newly checked channels
    for plat in platforms_list:
        if plat not in VALID_PLATFORMS:
            continue
        ch_rel = f"channels/{plat}.md"
        ch_path = os.path.join(packet_dir, ch_rel)
        if not os.path.exists(ch_path):
            tpl_file = PLATFORM_TEMPLATE_MAP.get(plat, "linkedin-post.md")
            tpl_path = os.path.join("templates", "channels", tpl_file)
            fmt = "post" if plat in ["linkedin", "x", "facebook"] else ("article" if plat == "blog" else "newsletter")
            if os.path.exists(tpl_path):
                with open(tpl_path, encoding="utf-8") as f:
                    c_text = f.read()
                c_text = re.sub(r'source_packet:\s*"[^"\n]*"', f'source_packet: "{packet_id}"', c_text)
                c_text = re.sub(r'channel_id:\s*"[^"\n]*"', f'channel_id: "{plat}-primary"', c_text)
                c_text = re.sub(r'platform:\s*"[^"\n]*"', f'platform: "{plat}"', c_text)
                with open(ch_path, "w", encoding="utf-8") as f:
                    f.write(c_text)
            else:
                fm_content = f"""---
channel_id: "{plat}-primary"
platform: "{plat}"
format: "{fmt}"
source_packet: "{packet_id}"
channel_status: "draft"

dates:
  planned_date: ""
  published_date: ""

distribution:
  published_url: ""
  syndication_canonical_url: ""

content_spec:
  hook: "{title_str} adaptation for {plat}."
  cta_type: "none"
  cta_text: ""
  media_paths: []

performance_metrics:
  impressions: 0
  engagements: 0
  likes: 0
  comments: 0
  shares: 0
  clicks: 0
  conversions: 0
  last_measured_at: ""
---

# {title_str} ({plat.upper()} Adaptation)

Write the channel-native draft here.
"""
                with open(ch_path, "w", encoding="utf-8") as f:
                    f.write(fm_content)

    # Re-scan remaining channels for manifest and table
    channels_manifest = []
    channel_table_rows = []
    for f_ch in sorted(glob.glob(os.path.join(packet_dir, "channels", "*.md"))):
        rel_ch = os.path.relpath(f_ch, packet_dir)
        channels_manifest.append(rel_ch)
        p_name = os.path.splitext(os.path.basename(f_ch))[0]
        fmt = "post" if p_name in ["linkedin", "x", "facebook"] else ("article" if p_name == "blog" else "newsletter")
        channel_table_rows.append(f"| [`{rel_ch}`]({rel_ch}) | `{p_name}` | `{fmt}` | `draft` |")

    # Update taxonomy block
    pillars_yaml = format_yaml_field("pillars", pillars_list, indent=2)
    tags_yaml = format_yaml_field("tags", tags_list, indent=2)
    manifest_yaml = format_yaml_field("channels_manifest", sorted(list(set(channels_manifest))), indent=0)

    created_at_val = now_iso
    m_created = re.search(r'created_at:\s*"([^"]+)"', py_content)
    if m_created:
        created_at_val = m_created.group(1)

    updated_py_content = f"""packet_id: "{packet_id}"
title: "{title_str}"
date: "{date_str}"
topic: "{topic_str}"
lifecycle_status: "{args.status}"

taxonomy:
{pillars_yaml}
{tags_yaml}
  campaign: "{args.campaign.strip()}"
  series: "{args.series.strip()}"

lineage:
  repurposed_from: "{source_packet_id}"
  related_project: "{args.related_project.strip()}"

governance:
  created_at: "{created_at_val}"
  updated_at: "{now_iso}"
  author: "{author_val}"
  reviewers: []

aggregate_metrics:
  total_impressions: 0
  total_engagements: 0
  last_updated: ""

{manifest_yaml}
"""
    with open(py_path, "w", encoding="utf-8") as f:
        f.write(updated_py_content)

    # Update context.md if context submitted
    ctx_path = os.path.join(packet_dir, "context.md")
    if os.path.exists(ctx_path) and args.context.strip():
        with open(ctx_path, encoding="utf-8") as f:
            c_data = f.read()
        if "## Submitted Issue Context" in c_data:
            c_data = re.sub(r'## Submitted Issue Context\n\n.*?(?=\n---\n|\Z)', f'## Submitted Issue Context\n\n{args.context.strip()}', c_data, flags=re.S)
        else:
            c_data = f"# Strategic Context: {title_str}\n\n## Submitted Issue Context\n\n{args.context.strip()}\n\n---\n\n" + c_data
        with open(ctx_path, "w", encoding="utf-8") as f:
            f.write(c_data)

    # Rewrite README.md
    channel_table_str = "\n".join(channel_table_rows) if channel_table_rows else "| No channels selected | | | |"
    pillars_display = ", ".join(pillars_list) if pillars_list else "N/A"
    tags_display = ", ".join(tags_list) if tags_list else "N/A"
    campaign_display = args.campaign.strip() if args.campaign.strip() else "N/A"
    series_display = args.series.strip() if args.series.strip() else "N/A"
    project_display = args.related_project.strip() if args.related_project.strip() else "N/A"
    context_summary_display = args.context.strip() if args.context.strip() else "Detailed strategic context and messaging thesis live in [context.md](context.md)."

    readme_content = f"""# Content Packet: {title_str}

## 1. Packet Executive Summary

| Metadata Field | Value |
| :--- | :--- |
| **Packet ID** | `{packet_id}` |
| **Title** | {title_str} |
| **Event Date** | `{date_str}` |
| **Topic Slug** | `{topic_str}` |
| **Lifecycle Status** | `{args.status}` |
| **Content Pillars** | {pillars_display} |
| **Tags** | {tags_display} |
| **Campaign** | {campaign_display} |
| **Series** | {series_display} |
| **Repurposed From** | N/A |
| **Related Project** | {project_display} |

---

## 2. Strategic Context Summary

{context_summary_display}

---

## 3. Channel Adaptations Manifest

| Channel File | Platform | Output Format | Initial Status |
| :--- | :--- | :--- | :--- |
{channel_table_str}

---

## 4. Packet Directory Guide

- **[`packet.yaml`](packet.yaml)**: Single source of truth for all packet metadata, taxonomy, governance, and aggregate metrics.
- **[`context.md`](context.md)**: Full strategic brief detailing target audience personas, messaging thesis, and editorial tone.
- **[`source-material.md`](source-material.md)**: Technical research, architecture diagram links, terminal output logs, and reproducible code snippets.
- **[`notes.md`](notes.md)**: Ongoing editorial notes, peer review feedback, and post-publish retrospectives.
- **`assets/raw/`**: Uncompressed source diagrams, slide decks, or raw screenshots.
- **`assets/exports/`**: Platform-optimized images ready for upload.

---

## 5. Quick Operational Commands

Validate this content packet:
```bash
./scripts/validate-packet.sh --packet {packet_dir}
```

Record post-publish telemetry metrics:
```bash
./scripts/update-metrics.sh --packet {packet_dir} --channel channels/linkedin.md --impressions <N> --engagements <N>
```
"""
    with open(os.path.join(packet_dir, "README.md"), "w", encoding="utf-8") as f:
        f.write(readme_content)

    run_catalog_sync()
    print(f"SUCCESS: Synchronized updates into packet at {packet_dir}")
    sys.exit(0)

# ================= NEW PACKET SCAFFOLDING =================
os.makedirs(os.path.join(packet_dir, "assets", "raw"), exist_ok=True)
os.makedirs(os.path.join(packet_dir, "assets", "exports"), exist_ok=True)
os.makedirs(os.path.join(packet_dir, "channels"), exist_ok=True)

with open(os.path.join(packet_dir, "assets", "raw", ".gitkeep"), "w") as f:
    f.write("# Placeholder to preserve assets/raw in git\n")
with open(os.path.join(packet_dir, "assets", "exports", ".gitkeep"), "w") as f:
    f.write("# Placeholder to preserve assets/exports in git\n")

channels_manifest = []
channel_table_rows = []

for plat in platforms_list:
    if plat not in VALID_PLATFORMS:
        print(f"WARNING: Unknown platform '{plat}', skipping.", file=sys.stderr)
        continue
    ch_file = f"{plat}.md"
    ch_rel = f"channels/{ch_file}"
    channels_manifest.append(ch_rel)
    ch_path = os.path.join(packet_dir, ch_rel)

    tpl_file = PLATFORM_TEMPLATE_MAP.get(plat, "linkedin-post.md")
    tpl_path = os.path.join("templates", "channels", tpl_file)
    fmt = "post" if plat in ["linkedin", "x", "facebook"] else ("article" if plat == "blog" else "newsletter")
    channel_table_rows.append(f"| [`{ch_rel}`]({ch_rel}) | `{plat}` | `{fmt}` | `draft` |")

    if os.path.exists(tpl_path):
        with open(tpl_path, encoding="utf-8") as f:
            c_text = f.read()
        c_text = re.sub(r'source_packet:\s*"[^"\n]*"', f'source_packet: "{packet_id}"', c_text)
        c_text = re.sub(r'channel_id:\s*"[^"\n]*"', f'channel_id: "{plat}-primary"', c_text)
        c_text = re.sub(r'platform:\s*"[^"\n]*"', f'platform: "{plat}"', c_text)
        with open(ch_path, "w", encoding="utf-8") as f:
            f.write(c_text)
    else:
        fm_content = f"""---
channel_id: "{plat}-primary"
platform: "{plat}"
format: "{fmt}"
source_packet: "{packet_id}"
channel_status: "draft"

dates:
  planned_date: ""
  published_date: ""

distribution:
  published_url: ""
  syndication_canonical_url: ""

content_spec:
  hook: "{title_str} adaptation for {plat}."
  cta_type: "none"
  cta_text: ""
  media_paths: []

performance_metrics:
  impressions: 0
  engagements: 0
  likes: 0
  comments: 0
  shares: 0
  clicks: 0
  conversions: 0
  last_measured_at: ""
---

# {title_str} ({plat.upper()} Adaptation)

Write the channel-native draft here.
"""
        with open(ch_path, "w", encoding="utf-8") as f:
            f.write(fm_content)

pillars_yaml = format_yaml_field("pillars", pillars_list, indent=2)
tags_yaml = format_yaml_field("tags", tags_list, indent=2)
manifest_yaml = format_yaml_field("channels_manifest", channels_manifest, indent=0)

packet_yaml_content = f"""packet_id: "{packet_id}"
title: "{title_str}"
date: "{date_str}"
topic: "{topic_str}"
lifecycle_status: "{args.status}"

taxonomy:
{pillars_yaml}
{tags_yaml}
  campaign: "{args.campaign.strip()}"
  series: "{args.series.strip()}"

lineage:
  repurposed_from: "{source_packet_id}"
  related_project: "{args.related_project.strip()}"

governance:
  created_at: "{now_iso}"
  updated_at: "{now_iso}"
  author: "{author_val}"
  reviewers: []

aggregate_metrics:
  total_impressions: 0
  total_engagements: 0
  last_updated: ""

{manifest_yaml}
"""

with open(os.path.join(packet_dir, "packet.yaml"), "w", encoding="utf-8") as f:
    f.write(packet_yaml_content)

if source_dir:
    for doc in ["context.md", "source-material.md", "notes.md"]:
        src_file = os.path.join(source_dir, doc)
        if os.path.exists(src_file):
            shutil.copyfile(src_file, os.path.join(packet_dir, doc))
        else:
            with open(os.path.join(packet_dir, doc), "w", encoding="utf-8") as f:
                f.write(f"# {doc}\n\nCloned from {source_packet_id}.\n")
else:
    context_tpl_path = os.path.join("templates", "packet", "context.md")
    if os.path.exists(context_tpl_path):
        with open(context_tpl_path, encoding="utf-8") as f:
            ctx_text = f.read()
        if args.context:
            ctx_text = f"# Strategic Context: {title_str}\n\n## Submitted Issue Context\n\n{args.context.strip()}\n\n---\n\n" + ctx_text
    else:
        ctx_text = f"# Strategic Context: {title_str}\n\n{args.context.strip() if args.context else ''}\n"
    with open(os.path.join(packet_dir, "context.md"), "w", encoding="utf-8") as f:
        f.write(ctx_text)

    for doc in ["source-material.md", "notes.md"]:
        tpl_doc = os.path.join("templates", "packet", doc)
        if os.path.exists(tpl_doc):
            shutil.copyfile(tpl_doc, os.path.join(packet_dir, doc))
        else:
            with open(os.path.join(packet_dir, doc), "w", encoding="utf-8") as f:
                f.write(f"# {doc}\n")

channel_table_str = "\n".join(channel_table_rows) if channel_table_rows else "| No channels selected | | | |"
pillars_display = ", ".join(pillars_list) if pillars_list else "N/A"
tags_display = ", ".join(tags_list) if tags_list else "N/A"
campaign_display = args.campaign.strip() if args.campaign.strip() else "N/A"
series_display = args.series.strip() if args.series.strip() else "N/A"
project_display = args.related_project.strip() if args.related_project.strip() else "N/A"
context_summary_display = args.context.strip() if args.context.strip() else "Detailed strategic context and messaging thesis live in [context.md](context.md)."

readme_content = f"""# Content Packet: {title_str}

## 1. Packet Executive Summary

| Metadata Field | Value |
| :--- | :--- |
| **Packet ID** | `{packet_id}` |
| **Title** | {title_str} |
| **Event Date** | `{date_str}` |
| **Topic Slug** | `{topic_str}` |
| **Lifecycle Status** | `{args.status}` |
| **Content Pillars** | {pillars_display} |
| **Tags** | {tags_display} |
| **Campaign** | {campaign_display} |
| **Series** | {series_display} |
| **Repurposed From** | N/A |
| **Related Project** | {project_display} |

---

## 2. Strategic Context Summary

{context_summary_display}

---

## 3. Channel Adaptations Manifest

| Channel File | Platform | Output Format | Initial Status |
| :--- | :--- | :--- | :--- |
{channel_table_str}

---

## 4. Packet Directory Guide

- **[`packet.yaml`](packet.yaml)**: Single source of truth for all packet metadata, taxonomy, governance, and aggregate metrics.
- **[`context.md`](context.md)**: Full strategic brief detailing target audience personas, messaging thesis, and editorial tone.
- **[`source-material.md`](source-material.md)**: Technical research, architecture diagram links, terminal output logs, and reproducible code snippets.
- **[`notes.md`](notes.md)**: Ongoing editorial notes, peer review feedback, and post-publish retrospectives.
- **`assets/raw/`**: Uncompressed source diagrams, slide decks, or raw screenshots.
- **`assets/exports/`**: Platform-optimized images ready for upload.

---

## 5. Quick Operational Commands

Validate this content packet:
```bash
./scripts/validate-packet.sh --packet {packet_dir}
```

Record post-publish telemetry metrics:
```bash
./scripts/update-metrics.sh --packet {packet_dir} --channel channels/linkedin.md --impressions <N> --engagements <N>
```
"""

with open(os.path.join(packet_dir, "README.md"), "w", encoding="utf-8") as f:
    f.write(readme_content)

run_catalog_sync()
print(f"SUCCESS: Created content packet at {packet_dir}")
EOF
