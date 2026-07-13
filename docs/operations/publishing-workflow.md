# Operational Publishing Workflow

## 1. Overview

Content creation and publishing follow a deterministic 7-stage operational lifecycle governed by the packet `lifecycle_status` in `packet.yaml` and individual channel `channel_status` in `channels/*.md`.

```
[Idea Intake] -> [Strategic Briefing] -> [Channel Drafting] -> [Validation & Review]
                                                                        |
[Lifecycle & Repurposing] <- [Post-Publish Analytics] <- [Multi-Channel Distribution]
```

## 2. The 7-Stage Lifecycle

### Stage 1: Idea Intake (`idea`)
- **Trigger**: A new content event is logged via GitHub Issue or via `./scripts/create-packet.sh`.
- **Actions**:
  1. Scaffold directory `content/YYYY/MM/YYYY-MM-DD-topic-slug/`.
  2. Populate `packet.yaml` with required metadata (`packet_id`, `title`, `date`, `topic`, initial taxonomy).
  3. Set `lifecycle_status: "idea"`.

### Stage 2: Strategic Briefing (`briefing`)
- **Objective**: Establish canonical strategic context before writing platform-specific copy.
- **Actions**:
  1. Fill out `context.md` defining target audience segments, core thesis, supporting arguments, tone, and constraints.
  2. Collect raw inputs, architecture diagrams, code blocks, or links in `source-material.md` and `assets/raw/`.
  3. Update `packet.yaml` to `lifecycle_status: "briefing"`.

### Stage 3: Channel Drafting (`drafting`)
- **Objective**: Adapt canonical briefing material into platform-native variants.
- **Actions**:
  1. Scaffold required channel files inside `channels/` from `templates/channels/`.
  2. Register each channel file path in `channels_manifest` within `packet.yaml`.
  3. Draft copy tailored to platform guidelines (`docs/platforms/`) while preserving the canonical core message.
  4. Set `lifecycle_status: "drafting"` in `packet.yaml` and `channel_status: "draft"` in channel front matter.

### Stage 4: Validation & Review (`review` -> `ready`)
- **Objective**: Ensure technical accuracy, schema compliance, and editorial quality.
- **Actions**:
  1. Run local validation: `./scripts/validate-packet.sh`.
  2. Automated CI (`validate-packet.yml`) executes on pull request to enforce JSON Schema validation and zero em dash characters.
  3. Upon approval, transition `lifecycle_status` to `"ready"` and `channel_status` to `"ready"`.

### Stage 5: Multi-Channel Distribution (`ready` -> `distributing` -> `published`)
- **Objective**: Publish or schedule channel outputs on live networks.
- **Actions**:
  1. If scheduled for future release, set `planned_date` in channel front matter and set `channel_status: "scheduled"`.
  2. When published natively, update channel front matter:
     - `channel_status: "published"`
     - `published_date`: exact ISO-8601 timestamp
     - `published_url`: live URL
  3. If some channels are published while others remain scheduled, set `packet.yaml` to `lifecycle_status: "distributing"`.
  4. Once all channels in `channels_manifest` are published, set `packet.yaml` to `lifecycle_status: "published"`.

### Stage 6: Post-Publish Analytics (`published`)
- **Objective**: Close the feedback loop with quantitative telemetry.
- **Actions**:
  1. At scheduled review intervals (7 days, 30 days post-publish), record performance snapshots in channel front matter (`performance_metrics`).
  2. Roll up totals into `aggregate_metrics` within `packet.yaml`.

### Stage 7: Repurposing & Lifecycle Archiving (`evergreen` / `archived`)
- **Objective**: Maintain long-term repository hygiene and leverage proven evergreen assets.
- **Actions**:
  1. Mark high-performing foundational packets as `lifecycle_status: "evergreen"`. Future derivative packets reference their ID via `repurposed_from`.
  2. When a packet reaches end-of-life or becomes obsolete, set `lifecycle_status: "archived"` and move the entire folder to `archive/packets/YYYY/MM/`.
