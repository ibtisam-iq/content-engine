# Metadata Schema Specification

## 1. Overview

This document specifies the metadata model for the repository. All schema definitions are machine-enforced via JSON Schema Draft-07 files located in the `schemas/` directory:
- `schemas/packet.schema.json`: Enforces `packet.yaml` manifests.
- `schemas/channel.schema.json`: Enforces YAML front matter in channel markdown files (`channels/*.md`).
- `schemas/metrics.schema.json`: Enforces post-publish performance metrics snapshots.

## 2. Packet Manifest Specification (`packet.yaml`)

Every packet directory must contain a `packet.yaml` file at its root.

### 2.1 Complete Example

```yaml
packet_id: "2026-07-12-sample-packet"
title: "Sample Content Event Title"
date: "2026-07-12"
topic: "sample-packet"
lifecycle_status: "briefing"

taxonomy:
  pillars:
    - "platform-engineering"
    - "architecture"
  tags:
    - "kubernetes"
    - "ci-cd"
  campaign: "q3-platform-launch"
  series: "architecture-deep-dives"

lineage:
  canonical_source: ""
  repurposed_from: []
  derivatives: []

governance:
  created_at: "2026-07-12T12:00:00Z"
  updated_at: "2026-07-12T14:30:00Z"
  owner: "creator-handle"
  related_project: "ISSUE-1042"

channels_manifest:
  - "channels/linkedin.md"
  - "channels/x.md"
  - "channels/blog.md"

aggregate_metrics:
  total_impressions: 0
  total_engagements: 0
  last_updated: ""
```

### 2.2 Field Definitions

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `packet_id` | String | Yes | Unique folder slug matching `YYYY-MM-DD-topic-slug`. |
| `title` | String | Yes | Human-readable title of the content event. |
| `date` | String | Yes | Primary event date in `YYYY-MM-DD` format. |
| `topic` | String | Yes | Short topic slug matching the folder suffix. |
| `lifecycle_status` | Enum | Yes | Packet state: `idea`, `briefing`, `drafting`, `review`, `ready`, `distributing`, `published`, `evergreen`, `archived`. |
| `taxonomy` | Object | Yes | Discovery groupings (`pillars`, `tags`, `campaign`, `series`). |
| `lineage` | Object | Yes | Traceability fields (`canonical_source`, `repurposed_from`, `derivatives`). |
| `governance` | Object | Yes | Audit fields (`created_at`, `updated_at`, `owner`, `related_project`). |
| `channels_manifest` | Array | Yes | Relative paths to active channel files inside `channels/`. |
| `aggregate_metrics` | Object | No | Rollup performance metrics across all published channels. |

## 3. Channel Front Matter Specification (`channels/*.md`)

Every markdown file inside `channels/` must start with a YAML front matter block.

### 3.1 Complete Example

```yaml
---
channel_id: "linkedin-primary"
platform: "linkedin"
format: "post"
source_packet: "2026-07-12-sample-packet"
channel_status: "draft"

dates:
  planned_date: "2026-07-14T09:00:00Z"
  published_date: ""

distribution:
  published_url: ""
  syndication_canonical_url: ""

content_spec:
  hook: "Most content systems fail because architecture is treated as an afterthought."
  cta_type: "question"
  cta_text: "How do you structure your technical portfolio across platforms?"

performance_metrics:
  impressions: 0
  engagements: 0
  likes: 0
  comments: 0
  shares: 0
  last_measured_at: ""
---
```

### 3.2 Field Definitions

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `channel_id` | String | Yes | Unique variant identifier within the packet. |
| `platform` | Enum | Yes | Target platform: `linkedin`, `x`, `facebook`, `blog`, `newsletter`. |
| `format` | Enum | Yes | Structural format: `post`, `thread`, `carousel`, `article`, `newsletter`. |
| `source_packet` | String | Yes | Parent packet ID matching folder name. |
| `channel_status` | Enum | Yes | Channel state: `draft`, `review`, `ready`, `scheduled`, `published`, `archived`. |
| `dates` | Object | Yes | Scheduling and publication timestamps (`planned_date`, `published_date`). |
| `distribution` | Object | Yes | Published live URL and canonical syndication URL. |
| `content_spec` | Object | Yes | Primary hook headline, CTA type (`question`, `link`, `newsletter-signup`, `none`), and CTA text. |
| `performance_metrics` | Object | Yes | Telemetry snapshot (`impressions`, `engagements`, `likes`, `comments`, `shares`, `last_measured_at`). |
