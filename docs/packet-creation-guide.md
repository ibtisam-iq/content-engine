# Packet Creation Guide

This guide covers both manual and automated methods for creating content packets in the content-engine repository.

## 1. Quick Start via CLI

### Prerequisites

- Git and GitHub CLI installed
- **Email verification**: Ensure your GitHub account is configured with verified email(s).
- **Fork the repository** if you plan to edit content and submit pull requests.

### Command‑Line Script

```bash
# Clone the repository (replace <owner>/<repo> with your own fork)
git clone https://github.com/<owner>/<repo>.git
cmp <repo>

# Run the interactive packet creation script
./scripts/create-packet.sh
```

The script guides you step‑by‑step:

1. **Title** – Give the packet a concise, human‑readable title.
2. **Date** – Choose the publication date in `YYYY-MM-DD` format.
3. **Topic slug** – A short, lowercase, hyphen‑separated identifier (e.g., `linkedin-leadership-tips`). Numbers are allowed but discouraged.
4. **Optional fields** – Fill in project key, primary platform, tags, pillars, campaign, and series if applicable.
5. **Platforms** – Select which platforms you want to create (LinkedIn, X, Facebook, Blog). Each platform file will be generated with a standard markdown structure.

After you complete the prompts, the script creates:

- Packet folder under `content/` (e.g., `content/2026/07/2026-07-13-linkedin-leadership-tips/`)
- `packet.yaml` (metadata manifest)
- `README.md` (summary)
- `context.md`, `source-material.md`, `notes.md` (templates)
- Platform‑specific markdown files with YAML front matter

### Automatic Commit

The script finishes by staging the new folder and creating a commit:

```
git add content/2026/07/2026-07-13-linkedin-leadership-tips/
git commit -m "create: 2026-07-13-linkedin-leadership-tips"
```

Do **not** push unless you intend to contribute back to the main repository.

## 2. Manual Creation (for Full Control)

If you need custom structure or want to edit files after creation, follow these steps:

### 2.1 Create the packet folder

```bash
mkdir -p content/2026/07/2026-07-13-linkedin-leadership-tips

cd content/2026/07/2026-07-13-linkedin-leadership-tips
```

### 2.2 Create `packet.yaml`

Copy from `templates/packet.yaml` and fill required fields:

```yaml
packet_id: "2026-07-13-linkedin-leadership-tips"
title: "LinkedIn Leadership Tips"
date: "2026-07-13"
topic: "linkedin-leadership-tips"
status: "idea"  # Use idea, draft, review, ready, scheduled, published, archived
date: "2026-07-13"
created_at: "2026-07-13T12:00:00Z"
updated_at: "2026-07-13T12:00:00Z"
platforms: ["linkedin.md", "x.md", "facebook.md", "blog.md"]
# Optional fields: related_project, primary_platform, tags, pillars, campaign, series, canonical_source, repurposed_from, archived_reason
```

### 2.3 Create README.md (human‑readable summary)

Copy from `templates/packet-readme-template.md` and populate:

```markdown
---
title: "LinkedIn Leadership Tips"
date: "2026-07-13"
topic: "linkedin-leadership-tips"
related_project: ""
primary_platform: "linkedin"
status: "idea"
---

# LinkedIn Leadership Tips

## Summary

*Insert executive summary here.*

## Platforms

- LinkedIn: draft
- X: draft
- Facebook: draft
- Blog: draft
```

### 2.4 Populate core packet files

| File | Purpose |
|------|---------|
| **context.md** | Strategic brief – event, audience, message, tone, constraints (fill using template) |
| **source-material.md** | Research and raw inputs – links, data, quotes, notes |
| **notes.md** | Editorial notes, performance observations, adaptation decisions |

Each of these starts as a template and should be edited directly in the folder.

### 2.5 Create or customize platform files

#### 2.5.1 Platform file structure

Each platform file lives alongside `packet.yaml` and has YAML front matter followed by the content body. Example (`linkedin.md`):

```yaml
---
title: "LinkedIn Leadership Tips"
platform: "linkedin"
source_packet: "2026-07-13-linkedin-leadership-tips"
content_type: "insight"
cta: "What leadership lessons would you add?"
planned_date: "2026-07-13"
published_date: ""        # populate after publishing
published_url: ""         # populate after publishing
status: "draft"           # draft, review, ready, scheduled, published, archived
groups: ["leadership", "career"]  # optional list of tags/tags
adapted_from: ""           # leave empty or reference another platform file in same packet
notes: ""                 # adaptation decisions, source credits
---

## Hook

*Grab attention in the first 2 seconds.*

## Post

*Core insights, formatted for LinkedIn's audience.*

## CTA

*Call‑to‑action inviting engagement.*

## Hashtags

*#Leadership #CareerGrowth* (no em‑dashes)
```

#### 2.5.2 Checklist for platform files

- File name matches platform name exactly (`linkedin.md`, `x.md`, etc.)
- YAML front‑matter is valid, starts with `---` and ends with `---`
- Required fields: `title`, `platform`, `source_packet`
- `status` starts as `draft` or `idea`
- `planned_date` optional but recommended for scheduling
- No em‑dashes anywhere in markdown body

### 2.6 Verification

Run the validation script to ensure consistency:

```bash
./scripts/validate-packet.sh content/2026/07/2026-07-13-linkedin-leadership-tips
```

#### Expected output (success)

```
All packets validated successfully.
```

#### If validation fails:

Review the error messages and fix the specific issue (missing fields, mismatched `source_packet`, invalid statuses, etc.).

## 3. GitHub Issue‑Driven Creation (Automation)

For teams that prefer issue‑driven workflows, the repository includes a GitHub Action:

1. Open an issue in the repository.
2. Apply the label **`new-packet`** (ensure the label exists).
3. Fill the issue description with the standardized form (title, date, topic, platforms, etc.).
4. The workflow `create-packet-from-issue.yml` parses the issue and creates the packet folder (similar to the CLI script).

> **Note:** The issue template is at `.github/ISSUE_TEMPLATE/new-content-packet.yml`. Configure it to match your intake form.

## 4. Common Errors and How to Fix Them

| Symptom | Cause | Fix |
|---------|-------|-----|
| `title` missing | Forgot to fill YAML | Add `title: "..."` |
| `packet_id` mismatch | Folder name doesn’t match `date + topic` | Rename folder or adjust `packet_id` |
| `source_packet` mismatch | Platform file references wrong ID | Update `source_packet` field to match `packet.yaml.packet_id` |
| `status` invalid | Typo or not in allowed list | Use: idea, draft, review, ready, scheduled, published, archived |
| No README.md | Manual creation forgot it | Copy template `templates/packet-readme-template.md` |

## 5. Tips for Successful Packets

- **Update timestamps**: Always edit `packet.yaml.updated_at` after any modification (except creation, where it mirrors `created_at`).
- **Use tags and pillars**: Helps with discovery and reporting.
- **Document decisions**: Keep `notes.md` updated for future reference.
- **Reuse rather than duplicate**: When creating similar content, consider using a packet as a template or adapting from an existing platform file using `adapted_from`.
- **Validate regularly**: Run `./scripts/validate-packet.sh` before pushing to catch inconsistencies.

## 6. References

- [Metadata Schema (`docs/metadata-schema.md`)](docs/metadata-schema.md)
- [Platform Guidelines (`docs/platform-guidelines.md`)](docs/platform-guidelines.md)
- [Publishing Workflow (`docs/publishing-workflow.md`)](docs/publishing-workflow.md)
- [GitHub Project Fields (`docs/github-project-fields.md`)](docs/github-project-fields.md)

---

*This guide is continuously evolving. If you encounter missing steps or unclear instructions, please open an issue or submit a pull request.*

---