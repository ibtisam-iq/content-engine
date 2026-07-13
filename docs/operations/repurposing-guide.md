# Content Repurposing Guide

## 1. Purpose

Multi-platform content operations scale by systematically adapting and extending proven foundational content over time. This guide defines how to derive new packets and channel adaptations from existing evergreen assets while maintaining strict lineage in Git.

## 2. Evergreen Asset Identification

Packets marked with `lifecycle_status: "evergreen"` represent foundational architecture deep dives, enduring technical lessons, or high-performing strategic frameworks.

## 3. Repurposing Patterns

### Pattern A: Cross-Channel Extension (Same Packet)
When adding a new channel output (e.g., creating a newsletter issue or carousel from an existing published blog post within the same content event):
1. Create a new file under the packet's `channels/` subdirectory (e.g., `channels/newsletter.md`).
2. Populate YAML front matter with `channel_status: "draft"` and link `source_packet`.
3. Add the new file path to `channels_manifest` in `packet.yaml`.
4. If the packet was previously `published`, transition `lifecycle_status` to `distributing` until the new channel adaptation is published.

### Pattern B: Derivative Packet Creation (New Event / Campaign)
When creating a follow-up packet, retrospective, or specialized spin-off derived from an older packet:
1. Scaffold a new packet under `content/YYYY/MM/YYYY-MM-DD-new-topic-slug/`.
2. In the new packet's `packet.yaml`, add the parent packet ID to `lineage.repurposed_from`.
3. In the parent packet's `packet.yaml`, add the new child packet ID to `lineage.derivatives`.
4. Commit both manifest updates together so parent-child relationships remain bi-directionally linked.

## 4. Lineage Integrity Invariants

- Never copy-paste copy across packets without logging the parent packet ID in `repurposed_from`.
- Always preserve the canonical thesis while adapting angle, format, and depth for the derivative audience.
