# Raw Source Material

## 1. Reference Links

- Documentation site: https://debugbox.ibtisam-iq.com
- Repository: https://github.com/ibtisam-iq/debugbox
- CHANGELOG: https://github.com/ibtisam-iq/debugbox/blob/main/CHANGELOG.md

## 2. Key Data Points

- Total pages restructured: 15
- Lines removed: 531
- Lines added: 175
- Net change: -356
- README: 328 lines to 213 lines (-115 lines)
- installation.md: merged into quick-start.md (47 lines removed, entirely redundant)
- Variant selection tables: deduplicated from 6 pages
- Tool list copies: reduced to 1 (manifest.yaml)

## 3. Source-of-Truth Hierarchy

The principle: every concept has one canonical page. Everything else links to it.

- Variant selection: variants/overview.md
- Tool lists: docs/manifest.yaml (rendered at reference/manifest.md)
- Pull tags: reference/tags.md
- Quick start: quick-start.md (absorbed installation.md)

## 4. Enforcement Mechanism

mkdocs build --strict fails the build on any broken internal link. This check runs in CI on every push to main. Documentation drift is caught at the same stage as broken code.
