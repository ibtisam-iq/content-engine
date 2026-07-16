# Content Packet: A Sample Content Packet

## 1. Packet Executive Summary

| Metadata Field | Value |
| :--- | :--- |
| **Packet ID** | `2026-07-16-sample-packet` |
| **Title** | A Sample Content Packet |
| **Event Date** | `2026-07-16` |
| **Topic Slug** | `sample-packet` |
| **Lifecycle Status** | `idea` |
| **Content Pillars** | sample-packet-content-pillar |
| **Tags** | sample-packet-tags |
| **Campaign** | N/A |
| **Series** | N/A |
| **Repurposed From** | N/A |
| **Related Project** | ISSUE-9 |

---

## 2. Strategic Context Summary

This is a sample packet.

---

## 3. Channel Adaptations Manifest

| Channel File | Platform | Output Format | Initial Status |
| :--- | :--- | :--- | :--- |
| [`channels/linkedin.md`](channels/linkedin.md) | `linkedin` | `post` | `draft` |
| [`channels/x.md`](channels/x.md) | `x` | `post` | `draft` |
| [`channels/facebook.md`](channels/facebook.md) | `facebook` | `post` | `draft` |
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
./scripts/validate-packet.sh --packet content/2026/07/2026-07-16-sample-packet
```

Record post-publish telemetry metrics:
```bash
./scripts/update-metrics.sh --packet content/2026/07/2026-07-16-sample-packet --channel channels/linkedin.md --impressions <N> --engagements <N>
```
