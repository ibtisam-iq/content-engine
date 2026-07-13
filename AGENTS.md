# AGENTS.md

## Agent Guidance for the content-engine Repository

This file provides explicit, step-by-step instructions for AI agents (e.g., Claude Code, GitHub Copilot, custom scripts) that interact with this repository. Follow these procedures to ensure consistent, correct, and scalable operation.

---

### 1. Core Concepts

- **Packet**: A content event stored under `content/YYYY/MM/YYYY-MM-DD-topic-slug/`.
- **packet.yaml**: The single source of truth for packet-level metadata validated against `schemas/packet.schema.json`.
- **Channel files**: Platform adaptations stored under `channels/` (`channels/linkedin.md`, `channels/x.md`, `channels/facebook.md`, `channels/blog.md`, `channels/newsletter.md`), containing YAML front matter validated against `schemas/channel.schema.json`.
- **Packet Lifecycle Statuses**: `idea`, `briefing`, `drafting`, `review`, `ready`, `distributing`, `published`, `evergreen`, `archived`.
- **Channel Statuses**: `draft`, `review`, `ready`, `scheduled`, `published`, `archived`.
- **GitHub as single source of truth**: All changes must be committed to this repository; no external notes or spreadsheets are the source.

### 2. Standard Workflow (Agent-Executable)

#### 2.1 Create a Packet

**Option A - From a GitHub Issue (preferred)**

1. Detect an issue with label `new-packet`.
2. Extract fields from the issue body (`title`, `date`, `topic`, `platforms`, `pillars`, `tags`, `campaign`, `series`, `related_project`).
3. Call the workflow `.github/workflows/create-packet-from-issue.yml` or run `./scripts/create-packet.sh --from-issue <issue-number>`.
4. The workflow/script will:
   - Create folder `content/YYYY/MM/YYYY-MM-DD-topic-slug/`.
   - Populate `packet.yaml` with supplied fields and schema defaults.
   - Create `README.md`, `context.md`, `source-material.md`, `notes.md` from templates.
   - Create `channels/*.md` platform files with `source_packet`, `channel_status: draft`, etc.
   - Create `assets/raw/` and `assets/exports/` subdirectories.
   - Re-index `registry/catalog.json`.
   - Commit and push.

**Option B - Manual / Script**

Run:
```bash
./scripts/create-packet.sh --date YYYY-MM-DD --topic topic-slug --title "Packet Title" --platforms linkedin,x,blog
```

#### 2.2 Update Packet Context & Source Material

1. Edit `context.md`:
   - Fill sections: Event Summary, Audience & Personas, Core Thesis, Tone & Constraints.
2. Edit `source-material.md`:
   - Add raw research notes, links, architecture diagrams, and code snippets.
3. Commit changes with message: `context: update brief for <packet-id>`.

#### 2.3 Adapt Platform Content

For each target channel (`channels/linkedin.md`, `channels/x.md`, etc.):

1. Open the file inside `channels/`.
2. Ensure front matter includes required schema fields:
   - `channel_id`: output variant identifier.
   - `platform`: correct platform enum (`linkedin`, `x`, `facebook`, `blog`, `newsletter`).
   - `format`: structural variant (`post`, `thread`, `carousel`, `article`, `newsletter`).
   - `source_packet`: parent packet folder name.
   - `channel_status`: start at `draft`.
   - `dates`, `distribution`, `content_spec`, `performance_metrics`.
3. Edit the Markdown body using `context.md` and `source-material.md` as inputs, applying platform-specific guidelines documented under `docs/platforms/`.
4. When ready for review, set `channel_status` to `review` then `ready`.
5. Commit with message: `adapt:<platform>:<packet-id>`.

#### 2.4 Review & Approval

- Optionally create a pull request targeting `main`.
- Automated CI (`.github/workflows/packet-validation.yml`) will execute `./scripts/validate-packet.sh --all` to verify:
  - Valid YAML in `packet.yaml` and channel front matter.
  - Compliance with JSON Schemas (`packet.schema.json`, `channel.schema.json`).
  - Referential integrity between `channels_manifest` and files in `channels/`.
  - Zero em dash characters (`--` or `-` must be used instead).
- After CI approval, merge.

#### 2.5 Publish & Telemetry Recording

For each channel file ready to publish:

1. Confirm `channel_status` is `ready` or `scheduled`.
2. Publish on the target platform.
3. Update channel front matter via script or workflow:
   ```bash
   ./scripts/update-metrics.sh --packet content/YYYY/MM/<id> --channel channels/linkedin.md --impressions <N> --engagements <N>
   ```
4. Update `channel_status: "published"`, populate `dates.published_date` and `distribution.published_url`.
5. Commit with message: `publish:<platform>:<packet-id>`.

#### 2.6 Archive

When a packet reaches the end of its lifecycle:

1. Set `lifecycle_status: archived` in `packet.yaml`.
2. Set `channel_status: archived` in every channel file under `channels/`.
3. Move the packet folder:
   ```bash
   git mv content/YYYY/MM/<packet-id> archive/packets/YYYY/MM/<packet-id>
   ```
4. Re-index repository catalog via `./scripts/generate-catalog.sh`.
5. Commit with message: `archive:<packet-id>`.

### 3. Automation Hooks (Workflows & Scripts)

| Artifact | Trigger | Action |
| :--- | :--- | :--- |
| `.github/workflows/create-packet-from-issue.yml` | Issue labeled `new-packet` | Creates packet folder and files from issue data and regenerates catalog. |
| `.github/workflows/update-platform-status.yml` | `workflow_dispatch` | Updates channel front matter status/URL, records telemetry, and rolls up aggregate metrics. |
| `.github/workflows/packet-validation.yml` | Pull request or push to `main` | Runs `./scripts/validate-packet.sh --all`; fails on schema or invariant errors. |
| `scripts/create-packet.sh` | Manual or CI | Packet generation and scaffolding tool. |
| `scripts/validate-packet.sh` | Manual or CI | Validates required fields, enum statuses, date formats, manifest integrity, and zero em dashes. |
| `scripts/update-metrics.sh` | Manual or CI | Records channel performance telemetry and rolls up packet aggregates. |
| `scripts/generate-catalog.sh` | Manual or CI | Indexes active packets into `registry/catalog.json`. |
| `scripts/sync-projects.sh` | Manual or CI | Bidirectional sync between GitHub Projects and packet metadata. |

### 4. Validation Rules (Implemented in `validate-packet.sh`)

- `packet.yaml` must be valid YAML conforming to `schemas/packet.schema.json`.
- Required fields: `packet_id`, `title`, `date`, `topic`, `lifecycle_status`, `taxonomy`, `lineage`, `governance`, `channels_manifest`.
- `packet_id` must match `YYYY-MM-DD-topic-slug`.
- `lifecycle_status` must be one of: `idea`, `briefing`, `drafting`, `review`, `ready`, `distributing`, `published`, `evergreen`, `archived`.
- Each file in `channels/` must contain front matter conforming to `schemas/channel.schema.json`.
- `channel_status` must be one of: `draft`, `review`, `ready`, `scheduled`, `published`, `archived`.
- Zero em dash characters across all markdown and YAML files.

### 5. Directory & Naming Conventions

- Packet folder: `content/YYYY/MM/YYYY-MM-DD-topic-slug/`
- Channel files: `channels/<platform>.md` (`linkedin.md`, `x.md`, `facebook.md`, `blog.md`, `newsletter.md`).
- Media folders: `assets/raw/` and `assets/exports/`.
- Archive layout: `archive/packets/YYYY/MM/<packet-id>/` and `archive/legacy-root-content/`.

### 6. Commit Message Conventions

Use standard prefixes: `create:`, `context:`, `source:`, `adapt:`, `publish:`, `status:`, `archive:`, `validate:`, `sync:`.

---

**End of AGENTS.md**. Follow these instructions precisely to keep the repository coherent, scalable, and fully automated-friendly.