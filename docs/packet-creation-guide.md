# Packet Creation and Maintenance Guide

## 1. Overview

Content packets are the atomic operational units of this repository. Every active packet resides under `content/YYYY/MM/YYYY-MM-DD-topic-slug/` and contains canonical briefing files, a `packet.yaml` metadata manifest, and platform adaptations inside `channels/`.

Packets can be created via three production workflows:
1. **Automated GitHub Issue Intake (Preferred)**: Opening or editing an issue labeled `new-packet` triggers automated creation via GitHub Actions.
2. **Command-Line Scaffolding (`create-packet.sh`)**: Running the local scaffolding script via command-line flags or interactive prompts.
3. **Manual Scaffolding**: Copying production templates directly for custom engineering setups.

---

## 2. Option A: Automated GitHub Issue Intake (Preferred)

The repository provides automated issue form intake (`.github/ISSUE_TEMPLATE/new-content-packet.yml`) linked to the `.github/workflows/create-packet-from-issue.yml` GitHub Action.

### 2.1 Workflow Steps
1. Navigate to the repository **Issues** tab and select **New Content Packet**.
2. Complete the structured fields:
   - **Packet Title**: e.g., `Kubernetes Cluster Autoscaling Lessons`
   - **Target Publish Date**: `YYYY-MM-DD`
   - **Topic Slug**: Lowercase, hyphen-separated identifier (e.g., `k8s-autoscaling-lessons`)
   - **Target Platforms**: Multi-select (`linkedin`, `x`, `facebook`, `blog`, `newsletter`)
   - **Taxonomy & Governance**: Content pillars, tags, campaign, series, and related project ID.
3. Submit the issue.

### 2.2 Automated Execution
Upon submission, `.github/workflows/create-packet-from-issue.yml` executes:
```bash
./scripts/create-packet.sh --from-issue <issue-number>
```
The workflow creates the folder under `content/YYYY/MM/YYYY-MM-DD-topic-slug/`, populates `packet.yaml`, scaffolds canonical files (`README.md`, `context.md`, `source-material.md`, `notes.md`) and platform files (`channels/*.md`), re-indexes `registry/catalog.json`, commits, and pushes to `main`.

---

## 3. Option B: Local CLI Scaffolding (`create-packet.sh`)

Operators working locally can generate or update packets using `scripts/create-packet.sh`.

### 3.1 Non-Interactive Flag Execution
```bash
./scripts/create-packet.sh \
  --date 2026-07-20 \
  --topic k8s-autoscaling-lessons \
  --title "Kubernetes Cluster Autoscaling Lessons" \
  --platforms linkedin,x,blog
```

### 3.2 Interactive Execution
Running `./scripts/create-packet.sh` without arguments prompts for required fields (`title`, `date`, `topic`, `platforms`).

### 3.3 Generated Directory Structure
```
content/YYYY/MM/YYYY-MM-DD-topic-slug/
├── packet.yaml
├── README.md
├── context.md
├── source-material.md
├── notes.md
├── assets/
│   ├── raw/
│   └── exports/
└── channels/
    ├── linkedin.md
    ├── x.md
    └── blog.md
```

---

## 4. Option C: Manual Scaffolding

For manual setups, operators copy assets from `templates/`:

1. **Create Directory**:
   ```bash
   mkdir -p content/YYYY/MM/YYYY-MM-DD-topic-slug/channels
   mkdir -p content/YYYY/MM/YYYY-MM-DD-topic-slug/assets/raw
   mkdir -p content/YYYY/MM/YYYY-MM-DD-topic-slug/assets/exports
   ```
2. **Populate Metadata**: Copy `templates/packet/packet.yaml` to `content/YYYY/MM/YYYY-MM-DD-topic-slug/packet.yaml` and configure required fields conforming to `schemas/packet.schema.json`.
3. **Scaffold Canonical Briefing Files**: Copy `README.md`, `context.md`, `source-material.md`, and `notes.md` from `templates/packet/`.
4. **Scaffold Channel Adaptations**: Copy required platform templates from `templates/channels/` into `channels/` and rename them to standard filenames (`channels/linkedin.md`, `channels/x.md`, `channels/facebook.md`, `channels/blog.md`, `channels/newsletter.md`).

---

## 5. Lifecycle Maintenance and Telemetry

Once scaffolded, operators maintain packets across their lifecycle:

- **Validation**: Verify structural and schema compliance locally:
  ```bash
  ./scripts/validate-packet.sh --packet content/YYYY/MM/YYYY-MM-DD-topic-slug
  ```
  To validate all packets repository-wide:
  ```bash
  ./scripts/validate-packet.sh --all
  ```
- **Telemetry Recording**: Record quantitative metrics after publication:
  ```bash
  ./scripts/update-metrics.sh \
    --packet content/YYYY/MM/YYYY-MM-DD-topic-slug \
    --channel channels/linkedin.md \
    --impressions 1200 \
    --engagements 85 \
    --clicks 40
  ```
  Or submit an issue using the `.github/ISSUE_TEMPLATE/record-channel-metrics.yml` issue form.
- **Catalog Re-Indexing**: Regenerate the central registry catalog:
  ```bash
  ./scripts/generate-catalog.sh
  ```