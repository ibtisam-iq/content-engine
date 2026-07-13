# Archive Policy and Historical Immutability

## 1. Archival Objectives

The archive preserves historical content packets and legacy pre-packet documentation without cluttering active production directories under `content/`.

## 2. Packet Archiving Rules

When a content packet is retired, deprecated, or no longer actively distributed, it must be archived according to strict invariants:

1. **Pre-Archival State Mutation**:
   - Before moving the packet folder, set `lifecycle_status: "archived"` in `packet.yaml`.
   - Set `channel_status: "archived"` in every markdown file under `channels/`.
   - Ensure `updated_at` reflects the archival timestamp.

2. **Directory Relocation**:
   - Move the entire packet folder from `content/YYYY/MM/YYYY-MM-DD-topic-slug/` to `archive/packets/YYYY/MM/YYYY-MM-DD-topic-slug/`.
   - Preserve internal directory structure (`channels/`, `assets/`, `context.md`, `source-material.md`, `packet.yaml`) intact.

3. **Strict Immutability Contract**:
   - Once relocated to `archive/packets/`, a packet becomes **strictly read-only**.
   - Automated scripts, coding agents, and human authors must never alter copy, metadata, or assets inside archived packets.
   - If an archived packet needs to be updated or re-released, create a new active packet under `content/` and reference the archived packet ID in `repurposed_from`.

## 3. Legacy Root Content

Older documentation created before the packet-based architecture resides under `archive/legacy-root-content/`.
- These markdown files are preserved for historical reference and context only.
- No new files may be added to `archive/legacy-root-content/`.
