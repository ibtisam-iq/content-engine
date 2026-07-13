# Content Engine Operating Manual

Welcome to your user manual for the `content-engine` repository. This document is a procedural, step-by-step operating guide designed for day-to-day content creation, platform adaptation, publishing, telemetry tracking, and long-term archival.

---

## 1. Repository purpose

`content-engine` is a GitHub-first content operating system. Unlike standard note-taking apps or spreadsheets, this repository treats technical content creation like software engineering:
- **Single Source of Truth**: All content briefs, drafts, platform adaptations, publish dates, URLs, and telemetry metrics live inside Git-controlled markdown and YAML files.
- **The Packet Model**: Every content event or topic is packaged as a self-contained folder called a Content Packet (`content/YYYY/MM/YYYY-MM-DD-topic-slug/`).
- **Separation of Core Brief vs. Channel Adaptations**: High-level context (`context.md`) and raw technical notes (`source-material.md`) sit at the root of each packet. Platform-specific output variants sit inside the `channels/` subdirectory (`channels/linkedin.md`, `channels/x.md`, etc.).
- **Automated Quality & Schema Enforcement**: Automated CLI tools and GitHub Actions continuously validate that every packet conforms to strict JSON Schema invariants.

---

## 2. Feature inventory

Below is the complete inventory of features currently implemented and available in the repository:

| Feature / Tool | Category | Status | Operational Capability |
| :--- | :--- | :--- | :--- |
| **Formal JSON Schemas** | Architecture | Available Now | Enforces strict metadata contracts for packet manifests (`packet.schema.json`), channel front matter (`channel_id`, `channel_status`, `dates`, `performance_metrics`), and telemetry (`metrics.schema.json`). |
| **9-State Packet Lifecycle Engine** | Governance | Available Now | Tracks packets through `idea`, `briefing`, `drafting`, `review`, `ready`, `distributing`, `published`, `evergreen`, `archived`. |
| **6-State Channel Status Engine** | Governance | Available Now | Tracks individual channel adaptations through `draft`, `review`, `ready`, `scheduled`, `published`, `archived`. |
| **CLI Packet Generator** (`create-packet.sh`) | CLI Script | Available Now | Scaffolds complete packet directories with `channels/`, `assets/raw/`, `assets/exports/`, and schema-valid YAML manifests. Supports cloning existing packets (`--from`) and standalone issue intake (`--from-issue`). |
| **CLI Packet Validator** (`validate-packet.sh`) | CLI Script | Available Now | Validates packet schema, channel front matter, referential integrity (`channels_manifest`), and checks for forbidden characters across `--all` or a single `--packet`. |
| **Telemetry Snapshot Utility** (`update-metrics.sh`) | CLI Script | Available Now | Records post-publish analytics (`impressions`, `engagements`, `likes`, `comments`, `shares`) into channel front matter and automatically recomputes `aggregate_metrics` rollups inside `packet.yaml`. |
| **Central Catalog Indexer** (`generate-catalog.sh`) | CLI Script | Available Now | Traverses active packets under `content/` and compiles a searchable JSON catalog at `registry/catalog.json`. |
| **GitHub Projects Sync** (`sync-projects.sh`) | CLI Script | Available Now | Synchronizes packet manifests and the 9-state lifecycle enum with GitHub Projects custom fields (`--dry-run` and live API sync). |
| **Automated Issue Intake Workflow** | GitHub Action | Available Now | GitHub Issue Template (`new-content-packet.yml`) combined with action `create-packet-from-issue.yml` automatically scaffolds new packet folders when an issue is labeled `new-packet`. |
| **Continuous Validation Workflow** | GitHub Action | Available Now | `packet-validation.yml` triggers on PRs and main branch pushes to block non-compliant schemas. |
| **Platform Status & Telemetry Workflow** | GitHub Action | Available Now | `update-platform-status.yml` accepts manual `workflow_dispatch` inputs to update channel status, publish URLs, and record telemetry counts directly from GitHub UI. |
| **Historical Archive & Immutability Engine** | Archival | Available Now | Read-only preservation under `archive/packets/YYYY/MM/` and `archive/legacy-root-content/`. |

---

## 3. Folder guide

Here is the functional purpose of every major directory in your repository:

```text
content-engine/
├── .github/
│   ├── ISSUE_TEMPLATE/     # Structured forms for requesting new content packets
│   └── workflows/          # GitHub Actions for CI validation, scaffolding, and telemetry
├── .vscode/                # Editor config binding JSON Schemas to YAML files
├── docs/
│   ├── architecture/       # Core specifications: packet model, schemas, rules
│   ├── operations/         # Guides for publishing, archival, and repurposing
│   └── platforms/          # Native formatting rules for LinkedIn, X, Blog, etc.
├── schemas/                # JSON Schema draft-07 definitions
├── registry/               # Central catalog (catalog.json) and series definitions
├── templates/              # Base scaffolding templates for packets and channels
├── scripts/                # Python/Bash CLI scripts for everyday operation
├── content/                # Active content packets organized by YYYY/MM/
└── archive/                # Retired packets and read-only historical documentation
```

### Inside an Active Packet Folder (`content/YYYY/MM/YYYY-MM-DD-topic-slug/`)
- `packet.yaml`: Single source of truth for metadata, taxonomy, governance, and metrics.
- `README.md`: Quick summary table of the packet.
- `context.md`: Your strategic brief (event summary, target audience, core thesis, tone).
- `source-material.md`: Your technical research (diagram links, code snippets, reference URLs).
- `notes.md`: Your running editorial notes and post-publish retrospectives.
- `assets/raw/`: Original source diagrams, raw screenshots, or uncompressed slide decks.
- `assets/exports/`: Compressed, platform-ready images or diagrams ready for upload.
- `channels/`: Subdirectory containing platform-specific adaptations (`linkedin.md`, `x.md`, `blog.md`, `newsletter.md`).

---

## 4. Metadata guide

### 4.1 Filling `packet.yaml` (Packet Manifest)

Every packet contains a `packet.yaml` file at its root:

```yaml
packet_id: "2026-08-15-kubernetes-upgrade-lessons"
title: "Kubernetes 1.30 Upgrade Lessons Learned"
date: "2026-08-15"
topic: "kubernetes-upgrade-lessons"
lifecycle_status: "drafting" # Options: idea, briefing, drafting, review, ready, distributing, published, evergreen, archived

taxonomy:
  pillars:
    - platform-engineering
    - infrastructure
  tags:
    - kubernetes
    - devops
  campaign: "q3-reliability"
  series: "architecture-deep-dives"

lineage:
  repurposed_from: ""        # Source packet_id if cloned/repurposed
  related_project: "ISSUE-42"

governance:
  created_at: "2026-08-15T10:00:00Z"
  updated_at: "2026-08-15T10:00:00Z"
  author: "content-engine"
  reviewers: []

aggregate_metrics:
  total_impressions: 0
  total_engagements: 0
  last_updated: ""

channels_manifest:
  - channels/linkedin.md
  - channels/x.md
  - channels/blog.md
```

### 4.2 Filling Channel Front Matter (`channels/<platform>.md`)

Each markdown file inside `channels/` begins with YAML front matter:

```yaml
---
channel_id: "linkedin-primary"
platform: "linkedin"         # Allowed: linkedin, x, facebook, blog, newsletter
format: "post"               # Allowed: post, thread, carousel, article, newsletter
source_packet: "2026-08-15-kubernetes-upgrade-lessons"
channel_status: "draft"      # Allowed: draft, review, ready, scheduled, published, archived

dates:
  planned_date: "2026-08-18"
  published_date: ""

distribution:
  published_url: ""
  syndication_canonical_url: ""

content_spec:
  hook: "We upgraded 40 clusters to Kubernetes 1.30. Here are 3 things that broke."
  cta_type: "link"
  cta_text: "Read the full architecture post below"

performance_metrics:
  impressions: 0
  engagements: 0
  likes: 0
  comments: 0
  shares: 0
  last_measured_at: ""
---
```

---

## 5. Daily workflows

Below are step-by-step procedural guides for the five most common day-to-day operations.

### Workflow A: Create a New Packet Manually (Terminal)

1. Open your terminal inside `content-engine/`.
2. Run `./scripts/create-packet.sh` with your desired flags:
   ```bash
   ./scripts/create-packet.sh \
     --date 2026-08-15 \
     --topic k8s-upgrade-lessons \
     --title "Kubernetes 1.30 Upgrade Lessons Learned" \
     --status briefing \
     --platforms linkedin,x,blog \
     --pillars platform-engineering \
     --tags kubernetes,devops
   ```
3. Open `content/2026/08/2026-08-15-k8s-upgrade-lessons/context.md` and document your audience, core message, and technical context.
4. Open `source-material.md` and paste relevant code snippets or links.
5. Validate your newly created packet:
   ```bash
   ./scripts/validate-packet.sh --packet content/2026/08/2026-08-15-k8s-upgrade-lessons
   ```
6. Commit your changes:
   ```bash
   git add content/2026/08/2026-08-15-k8s-upgrade-lessons
   git commit -m "create: 2026-08-15-k8s-upgrade-lessons"
   ```

### Workflow B: Create a Packet via GitHub Issue Intake (UI or CLI)

1. Navigate to your repository on GitHub and click **Issues** -> **New Issue**.
2. Select **New Content Packet** (`new-content-packet.yml`).
3. Fill out the structured form (`Title`, `Date`, `Topic Slug`, `Target Platforms` checkboxes, `Content Pillars`, `Tags`).
4. Submit the issue. Add the label `new-packet` (if not auto-applied).
5. Within 30 seconds, GitHub Actions (`create-packet-from-issue.yml`) automatically:
   - Scaffolds your packet folder under `content/YYYY/MM/YYYY-MM-DD-topic-slug/`.
   - Generates `packet.yaml` and `channels/` files.
   - Re-indexes `registry/catalog.json`.
   - Commits directly to `main` and leaves a confirmation comment on your issue.
6. Pull the latest `main` branch locally to begin drafting:
   ```bash
   git pull origin main
   ```

*(Alternative Standalone CLI Execution)*: You can also generate a packet from an issue directly in your terminal:
```bash
./scripts/create-packet.sh --from-issue 42
```

### Workflow C: Draft and Review Channel Content

1. When ready to write platform copy, set `lifecycle_status: "drafting"` inside `packet.yaml`.
2. Open the target platform file, for example `content/2026/08/2026-08-15-k8s-upgrade-lessons/channels/linkedin.md`.
3. Write your native LinkedIn draft below the second `---` front-matter separator, following `docs/platforms/linkedin-guidelines.md`.
4. When your draft is complete and ready for review, update the front matter:
   ```yaml
   channel_status: "review"
   ```
5. When approved for publishing, update to:
   ```yaml
   channel_status: "ready"
   ```

### Workflow D: Update a Platform File After Publishing

After publishing a post live on LinkedIn, record its URL and telemetry:

#### Option 1: Using the Terminal (`update-metrics.sh`)

1. Run `update-metrics.sh` to record views and engagements:
   ```bash
   ./scripts/update-metrics.sh \
     --packet content/2026/08/2026-08-15-k8s-upgrade-lessons \
     --channel channels/linkedin.md \
     --impressions 1850 \
     --engagements 142 \
     --likes 110 \
     --comments 22 \
     --shares 10
   ```
2. Open `channels/linkedin.md` and set:
   ```yaml
   channel_status: "published"
   dates:
     published_date: "2026-08-18T14:30:00Z"
   distribution:
     published_url: "https://linkedin.com/posts/example-123"
   ```
3. Commit the telemetry update:
   ```bash
   git add content/2026/08/2026-08-15-k8s-upgrade-lessons/
   git commit -m "publish:linkedin:2026-08-15-k8s-upgrade-lessons"
   ```

#### Option 2: Using GitHub Actions UI (`update-platform-status.yml`)

1. Go to **Actions** -> **update-platform-status** -> **Run workflow**.
2. Enter:
   - `packet_path`: `content/2026/08/2026-08-15-k8s-upgrade-lessons`
   - `channel_file`: `channels/linkedin.md`
   - `channel_status`: `published`
   - `published_url`: `https://linkedin.com/posts/example-123`
   - `impressions`: `1850`
   - `engagements`: `142`
3. Click **Run workflow**. The action updates your front matter, rolls up `aggregate_metrics` in `packet.yaml`, validates the packet, and commits.

### Workflow E: Repurpose an Old Packet into a New One

To create a new content piece derived from a successful past packet:

1. Use `./scripts/create-packet.sh` with the `--from` cloning flag pointing to the source packet directory:
   ```bash
   ./scripts/create-packet.sh \
     --date 2026-11-10 \
     --topic k8s-upgrade-part2 \
     --title "Kubernetes 1.30 Upgrade: 3 Months Later" \
     --from content/2026/08/2026-08-15-k8s-upgrade-lessons
   ```
2. The script automatically:
   - Scaffolds `content/2026/11/2026-11-10-k8s-upgrade-part2/`.
   - Sets `lineage.repurposed_from: "2026-08-15-k8s-upgrade-lessons"` in the new `packet.yaml`.
   - Clones your strategic brief (`context.md`) and research notes (`source-material.md`) so you don't start from scratch.

---

## 6. Scripts and automations

All CLI scripts are located under `scripts/` and should be executed from your repository root (`content-engine/`).

| Command Syntax | Purpose |
| :--- | :--- |
| `./scripts/validate-packet.sh --all` | Scans the entire repository (`content/**`) against JSON schemas and formatting rules. |
| `./scripts/validate-packet.sh --packet <path>` | Validates a single packet directory. |
| `./scripts/create-packet.sh --date <YYYY-MM-DD> --topic <slug> --title "<Title>"` | Scaffolds a new packet directory tree. |
| `./scripts/create-packet.sh --from-issue <number>` | Scaffolds a packet automatically by reading a GitHub issue. |
| `./scripts/create-packet.sh --from <source-path>` | Scaffolds a new packet by cloning metadata and briefs from an existing packet. |
| `./scripts/update-metrics.sh --packet <path> --channel <rel-path> --impressions <N> --engagements <N>` | Updates channel telemetry and recalculates aggregate packet totals. |
| `./scripts/generate-catalog.sh` | Compiles active packet metadata into `registry/catalog.json`. |
| `./scripts/sync-projects.sh --all --dry-run` | Prints computed GitHub Projects board synchronization payloads without API mutation. |

---

## 7. Publishing and tracking

### Lifecycle Synchronization Rule

- When your first channel adaptation is published live, set `lifecycle_status: "distributing"` inside `packet.yaml`.
- When all scheduled channel adaptations are published live, set `lifecycle_status: "published"` inside `packet.yaml`.
- Whenever you update channel telemetry via `./scripts/update-metrics.sh`, inspect `packet.yaml` to verify that `aggregate_metrics.total_impressions` and `total_engagements` reflect the updated sum across all channels.

---

## 8. Archiving and reuse

### Workflow F: Archive a Retired Packet

When a content packet is deprecated or reaches the end of its useful lifecycle:

1. Update `packet.yaml`:
   ```yaml
   lifecycle_status: "archived"
   ```
2. Update every channel file inside `channels/`:
   ```yaml
   channel_status: "archived"
   ```
3. Relocate the packet directory into `archive/packets/YYYY/MM/`:
   ```bash
   mkdir -p archive/packets/2026/08/
   git mv content/2026/08/2026-08-15-k8s-upgrade-lessons archive/packets/2026/08/2026-08-15-k8s-upgrade-lessons
   ```
4. Regenerate the active catalog so the archived packet is un-indexed from active listings:
   ```bash
   ./scripts/generate-catalog.sh
   ```
5. Commit the archival change:
   ```bash
   git commit -m "archive: 2026-08-15-k8s-upgrade-lessons"
   ```

Important Policy Note: All folders under `archive/` are read-only. Never edit or delete files inside `archive/`.

---

## 9. Common mistakes

Avoid these common operator pitfalls:

1. **Using Em Dash Characters**: Never paste or type em dashes (`--` or `\u2014`) into markdown copy or YAML metadata. Always use standard hyphens (`-`) or double hyphens (`--`). Automated CI validation (`validate-packet.sh`) will reject any commit containing em dashes.
2. **Creating Markdown Files at Repository Root**: Do not create standalone `.md` draft files at the repository root. Every draft must live inside a packet under `content/YYYY/MM/<id>/channels/`.
3. **Mismatched Folder Slugs and `packet_id`**: The folder name under `content/YYYY/MM/` must exactly match the `packet_id` property inside `packet.yaml` (`YYYY-MM-DD-topic-slug`).
4. **Unregistered Channels**: If you create a new channel file (e.g., `channels/newsletter.md`), you must add `"channels/newsletter.md"` to the `channels_manifest` list inside `packet.yaml`.
5. **Invalid Enum Strings**: Do not invent custom status strings. Only use the 9 allowed `lifecycle_status` values in `packet.yaml` and the 6 allowed `channel_status` values in channel files.

---

## 10. Current limitations

To maintain operator transparency, the following distinction clarifies what is fully operational today versus optional or planned for future development:

- **Automated Social Media Publishing (Not Implemented / Manual)**: The repository does not connect directly to LinkedIn or X APIs to automatically post live content. Publishing to social platforms remains a manual human action (or can be connected to external scheduling tools).
- **Automated Webhook Sync for GitHub Projects (Planned / Script-Driven Today)**: While `scripts/sync-projects.sh` and workflow `.github/workflows/sync-project-to-files.yml` can synchronize metadata with GitHub Projects on demand, automatic webhook-driven bidirectional board syncing requires configuring your GitHub App token and project board IDs.
- **Automated Analytics Scraping (Manual / Script-Driven Today)**: Telemetry counts (`impressions`, `engagements`) are currently inputted via `update-metrics.sh` or the `update-platform-status.yml` workflow rather than scraped automatically from platform APIs.
