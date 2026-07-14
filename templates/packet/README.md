# Content Packet: Template Packet Title

## 1. Packet Executive Summary

| Metadata Field | Value |
| :--- | :--- |
| **Packet ID** | `2026-01-01-template-topic` |
| **Title** | Template Packet Title |
| **Event Date** | `2026-01-01` |
| **Topic Slug** | `template-topic` |
| **Lifecycle Status** | `idea` |
| **Content Pillars** | platform-engineering |
| **Tags** | architecture |
| **Campaign** | N/A |
| **Series** | N/A |
| **Repurposed From** | N/A |
| **Related Project** | N/A |

---

## 2. Strategic Context Summary

Detailed strategic context and messaging thesis live in [`context.md`](context.md).

---

## 3. Channel Adaptations Manifest

| Channel File | Platform | Output Format | Initial Status |
| :--- | :--- | :--- | :--- |
| [`channels/linkedin.md`](channels/linkedin.md) | `linkedin` | `post` | `draft` |
| [`channels/x.md`](channels/x.md) | `x` | `post` | `draft` |
| [`channels/blog.md`](channels/blog.md) | `blog` | `article` | `draft` |
| [`channels/newsletter.md`](channels/newsletter.md) | `newsletter` | `newsletter` | `draft` |

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
./scripts/validate-packet.sh --packet content/YYYY/MM/YYYY-MM-DD-topic-slug
```

Record post-publish telemetry metrics:
```bash
./scripts/update-metrics.sh --packet content/YYYY/MM/YYYY-MM-DD-topic-slug --channel channels/linkedin.md --impressions 100 --engagements 10
```
