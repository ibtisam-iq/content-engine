# GitHub Project Integration and Custom Fields

## 1. Overview

This repository integrates with GitHub Projects to provide visual Kanban boards, table filters, and publication calendars. Because git commits remain the single source of truth, custom fields on GitHub Project items mirror the metadata stored in `packet.yaml` and channel front matter (`channels/*.md`).

## 2. Custom Field Specification

Create the following custom fields within the GitHub Project view:

| Field Name | Type | Target Scope | Description |
| :--- | :--- | :--- | :--- |
| **Title** | Built-in | Packet & Channel | Packet title (`packet.yaml`) or channel headline. |
| **Status** | Single-select | Packet & Channel | Mirrors `lifecycle_status` on packet cards and `channel_status` on channel cards. |
| **Planned date** | Date | Channel | Target publication date (`dates.planned_date`). |
| **Published date** | Date | Channel | Actual publication timestamp (`dates.published_date`). |
| **Platform** | Single-select | Channel | Target platform enum (`linkedin`, `x`, `facebook`, `blog`, `newsletter`). |
| **Packet** | Text | Packet & Channel | Relative packet directory path (e.g., `content/YYYY/MM/YYYY-MM-DD-topic-slug`). |
| **File path** | Text | Channel | Relative channel markdown path (e.g., `content/YYYY/MM/.../channels/linkedin.md`). |
| **Published URL** | Text | Channel | Canonical live network link (`distribution.published_url`). |
| **Tags** | Text | Packet | Comma-separated taxonomy tags (`taxonomy.tags`). |
| **Pillars** | Text | Packet | Comma-separated content pillars (`taxonomy.pillars`). |
| **Campaign** | Text | Packet | Campaign identifier (`taxonomy.campaign`). |
| **Series** | Text | Packet | Series identifier (`taxonomy.series`). |
| **Notes** | Text | Packet & Channel | Editorial notes or tracking identifiers. |

## 3. Status Enums by Scope

### 3.1 Packet Lifecycle Statuses (`packet.yaml`)
- `idea`, `briefing`, `drafting`, `review`, `ready`, `distributing`, `published`, `evergreen`, `archived`

### 3.2 Channel Lifecycle Statuses (`channels/*.md`)
- `draft`, `review`, `ready`, `scheduled`, `published`, `archived`

## 4. Automated Bidirectional Synchronization

To prevent drift between GitHub Projects and repository files, the engine provides synchronization tooling:

- **CLI Synchronization**:
  ```bash
  ./scripts/sync-projects.sh
  ```
- **Workflow Action**:
  The manual workflow `.github/workflows/sync-project-to-files.yml` can be executed via `workflow_dispatch` to reconcile project cards against repository files.