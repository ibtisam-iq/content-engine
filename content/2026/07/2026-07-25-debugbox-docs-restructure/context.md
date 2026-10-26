# Canonical Strategic Brief

## 1. Technical Event Context

- **Event Description**: DebugBox docs restructured for v1.1.0. 15 pages reorganized. installation.md merged into quick-start.md (47 lines removed). Variant selection tables deduplicated from 6 pages. README cut from 328 to 213 lines. manifest.yaml established as single source of truth for tool lists. Net: 531 lines removed, 175 added, -356 net.
- **Why It Matters**: Documentation drift is an engineering problem, not a writing problem. When the same information exists in multiple places, it drifts. The fix is structural, not editorial: one canonical page per concept, everything else links to it.

## 2. Target Audience Segments

- **Primary Audience**: Staff engineers and platform architects who own documentation for internal platforms or open-source projects.
- **Secondary Audience**: Engineering managers who treat docs as overhead rather than infrastructure.

## 3. Core Messaging Thesis

- **Primary Thesis**: Documentation is infrastructure. It needs the same maintenance discipline as code - specifically, a single source of truth enforced structurally, not editorially.
- **Supporting Arguments**:
  - Argument 1: The specific numbers (531 removed, 175 added, -356 net) make the change measurable and credible.
  - Argument 2: The mechanism (mkdocs build --strict catches broken links at build time, runs in CI) shows this is enforced, not aspirational.
  - Argument 3: The hardest part was not deletion but verification - every cross-reference had to be confirmed valid.

## 4. Tone and Editorial Constraints

- **Tone**: Reflective, declarative, honest about what went wrong before the fix.
- **Constraints**: No em dashes. No banned buzzwords. Numbers must be exact and traceable.
