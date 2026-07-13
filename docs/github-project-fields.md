# GitHub Project Fields

Create a GitHub Project for this repository and add the following custom fields to track packets and platform versions.

| Field | Type | Notes |
|-------|------|-------|
| Title | Built in | Post or packet title (from `packet.yaml.title` or platform file `title`). |
| Status | Single select | Packet or platform status. Use values: Idea, Draft, Review, Ready, Scheduled, Published, Archived. |
| Planned date | Date | Target publish date (from platform file `planned_date`). |
| Published date | Date | Actual publish date (from platform file `published_date`). |
| Platform | Single select | Platform name (from platform file `platform`: LinkedIn, X, Facebook, Blog). |
| Packet | Text | Packet folder path (relative to repo root), e.g., `content/2026/07/2026-07-12-sample-packet`. Matches `packet.yaml.packet_id` with path prefix. |
| File path | Text | Primary file path for this item (e.g., `content/2026/07/2026-07-12-sample-packet/linkedin.md`). |
| Published URL | Text | Final URL after publishing (from platform file `published_url`). |
| Tags | Text | Comma‑separated tags (from `packet.yaml.tags`). |
| Pillars | Text | Comma‑separated pillars (from `packet.yaml.pillars`). |
| Campaign | Text | Campaign identifier (from `packet.yaml.campaign`). |
| Series | Text | Series identifier (from `packet.yaml.series`). |
| Notes | Text | Free‑form notes (from `packet.yaml.notes` or platform file `notes`). |

**Usage**

- Map packet‑level fields (Title, Status, Tags, Pillars, Campaign, Series, Notes) to `packet.yaml`.
- Map platform‑specific fields (Status, Planned date, Published date, Platform, Published URL) to the corresponding platform file’s front matter.
- Use Board view to visualize workflow, Table view for bulk edits, and Calendar view for scheduled publications.

**Keeping Fields in Sync**

Run `./scripts/sync-projects.sh` periodically or via a GitHub Action to bidirectionally sync GitHub Project custom fields with `packet.yaml` and platform front matter.