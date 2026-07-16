# Content Packet: DebugBox: Multi-variant Kubernetes Debugging Containers

## 1. Packet Executive Summary

| Metadata Field | Value |
| :--- | :--- |
| **Packet ID** | `2026-07-16-debugbox-k8s-announcement` |
| **Title** | DebugBox: Multi-variant Kubernetes Debugging Containers |
| **Event Date** | `2026-07-16` |
| **Topic Slug** | `debugbox-k8s-announcement` |
| **Lifecycle Status** | `ready` |
| **Content Pillars** | platform-engineering, open-source |
| **Tags** | kubernetes, containers, devops, sre, debugbox |
| **Campaign** | debugbox-v1-launch |
| **Series** | debugbox-series |
| **Repurposed From** | N/A (root post) |
| **Related Project** | debugbox-v1.1.0 |

---

## 2. Strategic Context Summary

Foundational project announcement post. Introduces DebugBox as the tiered alternative to netshoot. Leads with the 93% size reduction. Covers all three variants, the one-liner usage, and publication to two registries. Sets up the 3 follow-up posts in the series.

Full strategic context: [`context.md`](context.md)

---

## 3. Channel Adaptations Manifest

| Channel File | Platform | Output Format | Status |
| :--- | :--- | :--- | :--- |
| `channels/linkedin.md` | `linkedin` | `post` | `ready` |

---

## 4. Quick Operational Commands

```bash
./scripts/validate-packet.sh --packet content/2026/07/2026-07-16-debugbox-k8s-announcement
./scripts/update-metrics.sh --packet content/2026/07/2026-07-16-debugbox-k8s-announcement --channel channels/linkedin.md --impressions 0 --engagements 0
```
