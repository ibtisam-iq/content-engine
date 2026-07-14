# content-engine

A GitHub-first content operating system for planning, drafting, adapting, publishing, tracking, and archiving multi-channel technical content.

## 1. System Overview

`content-engine` applies software engineering discipline to technical content creation. Instead of storing editorial plans in external spreadsheets or unversioned notes, all technical briefings, platform adaptations, publish timestamps, live URLs, and telemetry rollups are version-controlled in Git under standardized JSON Schema contracts.

```
[Idea / Issue Intake] -> [Content Packet Scaffolding] -> [Platform Channel Adaptations]
                                                                        |
[Archive / Legacy Root] <- [Telemetry & Catalog Sync] <- [Validation & Network Release]
```

## 2. Core Concepts

- **Content Packet**: The atomic operational unit representing a single technical event, milestone, architecture breakdown, or engineering post-mortem. Stored under `content/YYYY/MM/YYYY-MM-DD-topic-slug/`.
- **Packet Manifest (`packet.yaml`)**: Single source of truth for packet metadata, 9-state lifecycle status (`idea` through `archived`), taxonomy, governance, and aggregate telemetry. Enforced by `schemas/packet.schema.json`.
- **Platform Adaptations (`channels/*.md`)**: Platform-native variants (`linkedin.md`, `x.md`, `facebook.md`, `blog.md`, `newsletter.md`) isolated inside the packet's `channels/` subdirectory. Enforced by `schemas/channel.schema.json`.
- **Formal Schemas (`schemas/`)**: JSON Schema Draft-07 files enforcing metadata contracts across CLI scripts and continuous integration.
- **Central Registry (`registry/catalog.json`)**: Machine-readable catalog indexing all active packets across the repository.
- **Automated Workflows (`.github/workflows/`)**: GitHub Actions that scaffold packets from issue forms, validate schemas on push/pull request, record post-publish telemetry, and sync GitHub Projects.

## 3. Directory Layout

```
content-engine/
├── .github/
│   ├── ISSUE_TEMPLATE/       # Structured intake forms (new packet, delete packet, record metrics)
│   └── workflows/            # Actions for automated scaffolding, schema validation, and telemetry
├── docs/
│   ├── architecture/         # Specifications: packet model, JSON schemas, repository rules
│   ├── operations/           # Procedures: publishing lifecycle, archive policy, repurposing
│   └── platforms/            # Platform guidelines for LinkedIn, X, Facebook, Blog, Newsletter
├── schemas/                  # Formal JSON Schema contracts (packet, channel, metrics)
├── registry/                 # Central catalog index and series definitions
├── templates/                # Scaffolding templates for packets and platform channels
├── scripts/                  # Executable CLI tools (create, validate, update-metrics, catalog)
├── content/                  # Active content packets organized chronologically by YYYY/MM/
└── archive/                  # Immutable retired packets and historical legacy documentation
```

## 4. Start Here (Documentation Index)

- **Architecture & Schemas**: Read [Packet Model](file:///Users/ibtisam-iq/gitHub/content-engine/docs/architecture/packet-model.md), [Metadata Schema](file:///Users/ibtisam-iq/gitHub/content-engine/docs/architecture/metadata-schema.md), and [Repository Rules](file:///Users/ibtisam-iq/gitHub/content-engine/docs/architecture/repository-rules.md).
- **Daily Operations & Workflows**: Read [Packet Creation Guide](file:///Users/ibtisam-iq/gitHub/content-engine/docs/packet-creation-guide.md), [Publishing Workflow](file:///Users/ibtisam-iq/gitHub/content-engine/docs/operations/publishing-workflow.md), and the [Operator Manual](file:///Users/ibtisam-iq/gitHub/content-engine/MANUAL.md).
- **Platform Formatting Standards**: Read guidelines under [docs/platforms/](file:///Users/ibtisam-iq/gitHub/content-engine/docs/platforms).
- **Automated Agents**: Read [AGENTS.md](file:///Users/ibtisam-iq/gitHub/content-engine/AGENTS.md) before executing code or filesystem mutations.

## 5. Quick Verification

To verify repository integrity across all active packets, templates, and schemas:
```bash
./scripts/validate-packet.sh --all
```

## 6. License

MIT