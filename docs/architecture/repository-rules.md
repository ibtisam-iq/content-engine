# Repository Rules and Invariants

## 1. Single Source of Truth

- GitHub is the sole source of truth for all content packets, metadata, media assets, and channel adaptations.
- External notes applications, spreadsheets, and word processors must not be used as primary storage for active content.
- Every state change must be committed to git with standard commit message prefixes.

## 2. Directory and Layout Invariants

- Active content packets must reside exclusively under `content/YYYY/MM/YYYY-MM-DD-topic-slug/`.
- No active content markdown files are permitted at the repository root.
- All channel adaptations must reside inside the `channels/` subdirectory of their parent packet folder.
- Historical pre-packet documents reside under `archive/legacy-root-content/`.
- Retired packets reside under `archive/packets/YYYY/MM/`. Once moved to the archive, packets are read-only historical records.

## 3. Schema and Metadata Invariants

- Every active packet must contain a valid `packet.yaml` manifest.
- Every `packet.yaml` file must conform strictly to `schemas/packet.schema.json`.
- Every channel markdown file inside `channels/` must contain YAML front matter conforming strictly to `schemas/channel.schema.json`.
- All timestamps and date strings must follow strict ISO-8601 formatting (`YYYY-MM-DD` or `YYYY-MM-DDTHH:MM:SSZ`).
- Every channel file listed in `channels_manifest` within `packet.yaml` must exist on disk.

## 4. Language and Formatting Rules

- Professional English is the only supported language for repository documentation and content packets.
- The em dash character is strictly forbidden across all markdown and YAML files. Authors and automated agents must use standard punctuation such as colons, semicolons, or standard hyphens.
- Repository documentation must avoid informal or generic motivational language and remain direct, technical, and precise.

## 5. Automated Agent Execution Rules

- Automated agents must read `AGENTS.md` before performing any edits.
- Automated agents must execute `./scripts/validate-packet.sh` to verify schema and structural compliance before proposing commits.
- Automated agents must never create duplicate packets for the same content event.
