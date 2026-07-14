#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"

copy_rel() {
  local rel="$1"
  local dest="$ROOT/$rel"
  mkdir -p "$(dirname "$dest")"
  cp -n "$(dirname "$0")/$rel" "$dest" 2>/dev/null || cp "$(dirname "$0")/$rel" "$dest"
}

# Directories
mkdir -p "$ROOT/.github/ISSUE_TEMPLATE" "$ROOT/.github/workflows" "$ROOT/docs" "$ROOT/templates" "$ROOT/content" "$ROOT/archive/legacy-root-content"

# Files
copy_rel README.md
copy_rel AGENTS.md
copy_rel archive/legacy-root-content/README.md

copy_rel docs/repository-purpose.md
copy_rel docs/repository-rules.md
copy_rel docs/packet-model.md
copy_rel docs/platform-guidelines.md
copy_rel docs/metadata-schema.md
copy_rel docs/github-project-fields.md
copy_rel docs/publishing-workflow.md
copy_rel docs/archive-policy.md

copy_rel templates/packet-readme-template.md
copy_rel templates/context-template.md
copy_rel templates/source-material-template.md
copy_rel templates/linkedin-template.md
copy_rel templates/x-template.md
copy_rel templates/facebook-template.md
copy_rel templates/blog-template.md
copy_rel templates/notes-template.md

copy_rel .github/ISSUE_TEMPLATE/new-content-packet.yml
copy_rel .github/workflows/update-platform-status.yml
copy_rel .github/workflows/sync-project-to-files.yml

echo "content-engine bootstrap complete."
