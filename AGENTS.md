# AGENTS.md

## Automated Agent Guidance for the content-engine Repository

This document establishes operational rules and guardrails for AI coding agents and automated scripts interacting with this repository.

---

## 1. Primary Documentation Index

Before executing filesystem modifications, agents must review the canonical architecture and operational specifications under `docs/`:
- **Repository Rules**: [`docs/architecture/repository-rules.md`](docs/architecture/repository-rules.md)
- **Packet Directory Layout**: [`docs/architecture/packet-model.md`](docs/architecture/packet-model.md)
- **Metadata Schemas**: [`docs/architecture/metadata-schema.md`](docs/architecture/metadata-schema.md)
- **Operational Creation Guide**: [`docs/packet-creation-guide.md`](docs/packet-creation-guide.md)
- **Platform Guidelines**: [`docs/platforms/`](docs/platforms/)

---

## 2. Core Architectural Invariants

1. **Single Source of Truth**: Active packets reside exclusively under `content/YYYY/MM/YYYY-MM-DD-topic-slug/`.
2. **Schema Contracts**:
   - `packet.yaml` must conform to `schemas/packet.schema.json`.
   - `channels/*.md` YAML front matter must conform to `schemas/channel.schema.json`.
3. **Supported Platform Enums**: `linkedin`, `x`, `facebook`, `blog`, `newsletter`.
4. **Lifecycle Status Enums**:
   - Packet (`packet.yaml`): `idea`, `briefing`, `drafting`, `review`, `ready`, `distributing`, `published`, `evergreen`, `archived`.
   - Channel (`channels/*.md`): `draft`, `review`, `ready`, `scheduled`, `published`, `archived`.
5. **Zero Em Dash Rule**: Em dash characters (`—` or `--`) are strictly prohibited across all markdown and YAML files. Use standard hyphens, colons, or parentheses.

---

## 3. Allowed vs. Human-Gated Operations

### 3.1 Allowed Standard Tasks
- Creating new packet folders via `./scripts/create-packet.sh --date YYYY-MM-DD --topic slug --title "Title" --platforms linkedin,x,facebook,blog,newsletter`.
- Updating canonical briefing copy (`context.md`, `source-material.md`, `notes.md`).
- Drafting channel adaptations inside `channels/*.md` following `docs/platforms/` rules.
- Executing `./scripts/validate-packet.sh --all` and `./scripts/generate-catalog.sh`.
- Recording telemetry via `./scripts/update-metrics.sh`.

### 3.2 Human-Gated or Restricted Tasks
- **Schema Modification**: Do not modify files under `schemas/` without explicit human confirmation.
- **Contract Changes**: Do not alter required keys, status enum values, or regex patterns in scripts or workflows without explicit approval.
- **Archival Deletion**: Do not delete files under `archive/packets/` or `archive/legacy-root-content/`. Archived files are read-only.

---

## 4. Operational Scripts & Workflows

| Script / Action | Trigger / Context | Description |
| :--- | :--- | :--- |
| `scripts/create-packet.sh` | Manual CLI / Action | Scaffolds or synchronizes packet folder, front matter, and catalog. |
| `scripts/validate-packet.sh` | Manual CLI / Action | Validates YAML, JSON Schema compliance, manifest paths, and zero em dashes. |
| `scripts/update-metrics.sh` | Manual CLI / Action | Mutates channel `performance_metrics` and rolls up `packet.yaml` aggregates. |
| `scripts/delete-packet.sh` | Manual CLI / Action | Permanently removes packet folder and regenerates catalog index. |
| `scripts/generate-catalog.sh` | Manual CLI / Action | Indexes active packets into `registry/catalog.json`. |
| `scripts/report-packets.sh` | Manual CLI | Renders ASCII table report of packets by status, tag, or pillar. |
| `scripts/suggest-reuse.sh` | Manual CLI | Scores active/archived packets for repurposing recommendations. |
| `scripts/sync-projects.sh` | Manual CLI / Action | Reconciles packet metadata with GitHub Projects custom fields. |
| `.github/workflows/create-packet-from-issue.yml` | Issue `new-packet` | Scaffolds packet from issue body inputs. |
| `.github/workflows/delete-packet-from-issue.yml` | Issue `delete-packet` | Deletes packet and regenerates catalog. |
| `.github/workflows/record-metrics-from-issue.yml` | Issue `record-metrics` | Records telemetry metrics from issue inputs. |
| `.github/workflows/packet-validation.yml` | Push / Pull Request | Runs `./scripts/validate-packet.sh --all`. |
| `.github/workflows/sync-project-to-files.yml` | `workflow_dispatch` | Runs bidirectional GitHub Project sync. |
| `.github/workflows/update-platform-status.yml` | `workflow_dispatch` | Updates channel status and telemetry. |

---

## 5. Mandatory Verification Checklist

Before proposing or committing changes, agents must execute:
```bash
./scripts/validate-packet.sh --all && ./scripts/generate-catalog.sh
```
All packets must pass validation (`VALIDATION PASSED`) before changes are merged.