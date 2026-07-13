# Packet Model

## 1. Definition and Purpose

A content packet is the canonical atomic unit of content creation in this repository. It represents a single content event, such as:
- A technical project completion or feature release
- A post-incident review or engineering lesson learned
- A major architecture decision record or trade-off analysis
- An open-source tool launch or technical guide

A packet groups all context, raw inputs, editorial decisions, media assets, and channel adaptations for that event in one versioned folder under Git.

## 2. Packet Directory Path

All active content packets live under:
```
content/YYYY/MM/YYYY-MM-DD-topic-slug/
```

- `YYYY`: Four-digit calendar year
- `MM`: Two-digit calendar month (01-12)
- `YYYY-MM-DD-topic-slug`: Folder identifier matching the exact date of the event and a short, lowercase, hyphen-separated topic slug.

Example:
```
content/2026/07/2026-07-12-sample-packet/
```

## 3. Standard Packet Contents

Each packet directory must follow this exact layout:

```
content/YYYY/MM/YYYY-MM-DD-topic-slug/
├── packet.yaml               # Single source of truth for packet metadata
├── README.md                 # Lightweight executive summary table
├── context.md                # Strategic brief: audience, core thesis, constraints
├── source-material.md        # Raw notes, code snippets, reference URLs, CLI output
├── notes.md                  # Editorial decisions, distribution notes, retrospective
├── assets/
│   ├── raw/                  # Uncompressed source diagrams, screenshots, raw data
│   └── exports/              # Platform-ready optimized media (carousels, OpenGraph images)
└── channels/                 # Subdirectory isolating platform adaptations
    ├── linkedin.md           # Platform adaptation
    ├── x.md                  # Platform adaptation
    └── blog.md               # Platform adaptation
```

### 3.1 Core Manifest and Canonical Files
- `packet.yaml`: Machine-readable manifest validated against `schemas/packet.schema.json`. Contains packet ID, title, date, topic, lifecycle status, taxonomy, lineage, governance, and channel manifest.
- `README.md`: Human-readable markdown summary table of the packet's metadata and channel status.
- `context.md`: Canonical strategic brief defining event context, target audience segments, core messaging thesis, tone, and technical constraints.
- `source-material.md`: Raw factual inputs including code blocks, terminal logs, external references, and data points.
- `notes.md`: Internal editorial journal recording draft decisions, reviewer feedback, and post-publish retrospective notes.

### 3.2 Media Asset Architecture (`assets/`)
To prevent clutter and preserve both source files and distribution artifacts, assets are partitioned into two subdirectories:
- `assets/raw/`: Original unedited source files (e.g., Excalidraw files, Figma exports, raw screenshots, CSV data sets).
- `assets/exports/`: Final distribution-ready assets formatted to platform specifications (e.g., 1080x1350 PNG carousel slides, 1200x630 OpenGraph banners).

### 3.3 Channel Adaptation Subdirectory (`channels/`)
All platform adaptations live exclusively inside the `channels/` subdirectory.
- Each file inside `channels/` represents one specific output variant (e.g., `channels/linkedin.md`, `channels/x.md`, `channels/blog.md`).
- Every file must include structured YAML front matter validated against `schemas/channel.schema.json`.
- Multiple files for the same platform are permitted when format variants differ (e.g., `channels/linkedin-post.md` and `channels/linkedin-carousel.md`).

## 4. Lifecycle Status Model

Packets move through a deterministic 9-state lifecycle (`lifecycle_status` in `packet.yaml`):

1. `idea`: Event registered; folder scaffolded; briefing not yet started.
2. `briefing`: Strategic brief (`context.md`) and raw research (`source-material.md`) actively in progress.
3. `drafting`: Channel adaptations inside `channels/` actively being written.
4. `review`: Channel content complete; awaiting technical peer or creator approval.
5. `ready`: All channel files approved; ready for publication or scheduling.
6. `distributing`: At least one channel is published while others remain scheduled or pending.
7. `published`: All intended channel outputs listed in `channels_manifest` are live.
8. `evergreen`: Published packet designated as a durable reference asset for future repurposing.
9. `archived`: Deprecated or retired packet moved to `archive/packets/YYYY/MM/`.
