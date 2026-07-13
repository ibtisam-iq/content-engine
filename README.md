# content-engine

GitHub-first content operating system for planning, drafting, adapting, publishing, and tracking multi-platform technical content.

## 1. Purpose

This repository is the single source of truth for structured **content packets**. A content packet represents one technical event, milestone, architecture deep dive, or engineering reflection that is systematically adapted into platform-native variants across channels such as LinkedIn, X, technical blogs, and newsletters.

All active content packets live under `content/` and are version-controlled in Git.

## 2. Architecture and Directory Tree

```
content-engine/
├── .github/                  # Issue templates and automated CI workflows
├── .vscode/                  # Editor configuration binding JSON Schemas
├── docs/
│   ├── architecture/         # Core specifications: packet model, schemas, rules
│   ├── operations/           # Lifecycle workflow, archive policy, repurposing
│   └── platforms/            # Platform-specific formatting and hook guidelines
├── schemas/                  # Formal JSON Schema Draft-07 contracts
│   ├── packet.schema.json
│   ├── channel.schema.json
│   └── metrics.schema.json
├── registry/                 # Central catalog and series definitions
├── templates/                # Standardized templates for packets and channels
├── scripts/                  # CLI tooling for scaffolding, linting, and syncing
├── content/                  # Active content packets organized chronologically
└── archive/                  # Historical packets and read-only legacy material
```

## 3. The Packet Model

Each content packet resides in its own directory:
```
content/YYYY/MM/YYYY-MM-DD-topic-slug/
├── packet.yaml               # Packet manifest (single source of truth)
├── README.md                 # Packet executive summary table
├── context.md                # Strategic brief: audience, core thesis, constraints
├── source-material.md        # Raw notes, code snippets, reference URLs
├── notes.md                  # Editorial journal and retrospective notes
├── assets/
│   ├── raw/                  # Uncompressed source diagrams and screenshots
│   └── exports/              # Platform-ready optimized media exports
└── channels/                 # Subdirectory isolating platform adaptations
    ├── linkedin.md
    ├── x.md
    └── blog.md
```

Every `packet.yaml` is validated against `schemas/packet.schema.json`. Every markdown file inside `channels/` contains YAML front matter validated against `schemas/channel.schema.json`.

## 4. Lifecycle Status Machine

Packets and channel adaptations move through a 9-state lifecycle:
1. `idea`: Event registered; briefing pending.
2. `briefing`: Strategic brief (`context.md`) and raw research underway.
3. `drafting`: Channel adaptations actively being written inside `channels/`.
4. `review`: Drafts complete; awaiting technical peer review.
5. `ready`: Approved for distribution.
6. `distributing`: Partially published across channels.
7. `published`: All active channels live.
8. `evergreen`: High-performing published asset marked for long-term repurposing.
9. `archived`: Deprecated or retired packet relocated to `archive/packets/`.

## 5. Quick Start Commands

- **Validate Repository Schema**:
  ```bash
  ./scripts/validate-packet.sh
  ```
- **Create a New Packet**:
  ```bash
  ./scripts/create-packet.sh
  ```

## 6. Documentation Index

- Architecture specifications: `docs/architecture/packet-model.md`, `docs/architecture/metadata-schema.md`, `docs/architecture/repository-rules.md`
- Operational guides: `docs/operations/publishing-workflow.md`, `docs/operations/archive-policy.md`, `docs/operations/repurposing-guide.md`
- Platform guidelines: `docs/platforms/linkedin.md`, `docs/platforms/x.md`, `docs/platforms/blog.md`, `docs/platforms/newsletter.md`

## 7. License

MIT