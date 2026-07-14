# Content Engine Operator Manual

## 1. Purpose & Orientation

This manual serves as a procedural runbook for repository maintainers and content engineers operating the `content-engine` system. Rather than duplicating structural architecture specifications (found under [`docs/architecture/`](docs/architecture/)), this runbook details concrete operating procedures for daily and weekly content operations.

---

## 2. Daily Operations: Packet Creation & Drafting

### 2.1 Initiating a Packet via GitHub Issue (Automated Intake)
1. Open the repository **Issues** tab and select the **New Content Packet** template (`.github/ISSUE_TEMPLATE/new-content-packet.yml`).
2. Provide required fields: Title, Event Date, Topic Slug, and target platform adaptations (`linkedin`, `x`, `facebook`, `blog`, `newsletter`).
3. Submit the issue. The workflow `.github/workflows/create-packet-from-issue.yml` automatically creates `content/YYYY/MM/YYYY-MM-DD-topic-slug/`, populates `packet.yaml`, scaffolds channels, and commits to `main`.

### 2.2 Initiating a Packet Locally via CLI
Operators working locally run `scripts/create-packet.sh`:
```bash
./scripts/create-packet.sh \
  --date 2026-07-20 \
  --topic architecture-tradeoffs \
  --title "Architecture Trade-offs in Practice" \
  --platforms linkedin,x,facebook,blog,newsletter
```

### 2.3 Completing Strategic Briefing & Research
1. Open `content/YYYY/MM/YYYY-MM-DD-topic-slug/context.md` and define the target audience personas, core messaging thesis, and technical constraints.
2. Open `source-material.md` and record reproducible CLI commands, code configuration blocks, or benchmark citations.
3. Update `packet.yaml` to set `lifecycle_status: "briefing"`.

### 2.4 Drafting Platform Adaptations
1. Open each markdown file inside `content/YYYY/MM/YYYY-MM-DD-topic-slug/channels/`.
2. Adapt the strategic briefing into platform-native copy following the specifications under [`docs/platforms/`](docs/platforms/).
3. Update `channel_status: "draft"` to `"review"` when copy is ready for peer evaluation.
4. Update `packet.yaml` to `lifecycle_status: "drafting"`.

---

## 3. Weekly Operations: Validation, Publishing & Telemetry

### 3.1 Pre-Merge Verification
Run local validation across the repository before opening a pull request:
```bash
./scripts/validate-packet.sh --all
```
The script checks YAML front matter against JSON Schemas (`schemas/packet.schema.json` and `schemas/channel.schema.json`), verifies manifest integrity, checks date formatting, and flags any forbidden em dash characters.

### 3.2 Recording Post-Publish Telemetry
When channel adaptations go live, record quantitative performance metrics via CLI:
```bash
./scripts/update-metrics.sh \
  --packet content/YYYY/MM/YYYY-MM-DD-topic-slug \
  --channel channels/linkedin.md \
  --impressions 1500 \
  --engagements 120 \
  --likes 85 \
  --comments 20 \
  --shares 15 \
  --clicks 45 \
  --conversions 5
```
Or submit an issue using the `.github/ISSUE_TEMPLATE/record-channel-metrics.yml` form. The tool automatically updates channel front matter (`performance_metrics`) and recomputes `aggregate_metrics` inside `packet.yaml`.

### 3.3 Discovering Repurposing Opportunities
Run the signal scoring utility to discover related active or archived packets:
```bash
./scripts/suggest-reuse.sh --packet content/YYYY/MM/YYYY-MM-DD-topic-slug
```

---

## 4. Monthly Operations: Archival & Catalog Maintenance

### 4.1 Archiving Retired Packets
When a packet reaches end-of-life:
1. Set `lifecycle_status: "archived"` in `packet.yaml`.
2. Set `channel_status: "archived"` across all files under `channels/`.
3. Move the packet directory into the archive:
   ```bash
   mkdir -p archive/packets/YYYY/MM/
   git mv content/YYYY/MM/YYYY-MM-DD-topic-slug archive/packets/YYYY/MM/YYYY-MM-DD-topic-slug
   ```
4. Regenerate the central catalog index:
   ```bash
   ./scripts/generate-catalog.sh
   ```
5. Commit the archival migration. Archived files are strictly read-only.

---

## 5. Script & Workflow Quick Reference

| Command / File | Purpose |
| :--- | :--- |
| `./scripts/create-packet.sh` | Scaffold new packet directory or synchronize existing manifest. |
| `./scripts/validate-packet.sh --all` | Run full repository schema and invariant validation. |
| `./scripts/update-metrics.sh` | Record channel telemetry snapshot and recalculate packet rollups. |
| `./scripts/delete-packet.sh --packet <path>` | Permanently delete packet folder and clean catalog. |
| `./scripts/generate-catalog.sh` | Re-index active packets into `registry/catalog.json`. |
| `./scripts/report-packets.sh` | Print ASCII summary table of active packets. |
| `./scripts/suggest-reuse.sh --packet <path>` | Score shared taxonomy tags for repurposing suggestions. |
| `./scripts/sync-projects.sh` | Synchronize packet metadata with GitHub Projects custom fields. |
