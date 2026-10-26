# Content Packet: DebugBox v1.1.0: Removing Tools to Improve the Image

## 1. Packet Executive Summary

| Metadata Field | Value |
| :--- | :--- |
| **Packet ID** | `2026-07-18-debugbox-tool-curation` |
| **Title** | DebugBox v1.1.0: Removing Tools to Improve the Image |
| **Event Date** | `2026-07-18` |
| **Topic Slug** | `debugbox-tool-curation` |
| **Lifecycle Status** | `ready` |
| **Content Pillars** | platform-engineering, open-source |
| **Tags** | kubernetes, containers, devops, architecture, debugbox |
| **Campaign** | debugbox-v1-launch |
| **Series** | debugbox-series |
| **Repurposed From** | `2026-07-14-debugbox-k8s-announcement` |
| **Related Project** | debugbox-v1.1.0 |

---

## 2. Strategic Context Summary

Post 2 in the debugbox-series. Covers the v1.1.0 tool curation story: the decision framework, what moved between variants, what was removed entirely, and the size results. Companion to blog post 002-removing-tools-from-container-image.md.

Full strategic context: [`context.md`](context.md)

---

## 3. Channel Adaptations Manifest

| Channel File | Platform | Output Format | Status |
| :--- | :--- | :--- | :--- |
| `channels/linkedin.md` | `linkedin` | `post` | `ready` |

---

## 4. Quick Operational Commands

```bash
./scripts/validate-packet.sh --packet content/2026/07/2026-07-18-debugbox-tool-curation
./scripts/update-metrics.sh --packet content/2026/07/2026-07-18-debugbox-tool-curation --channel channels/linkedin.md --impressions 0 --engagements 0
```
