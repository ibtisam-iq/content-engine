# Repository Archive

## 1. Purpose and Read-Only Immutability Policy

The `archive/` directory preserves historical content packets and legacy pre-packet documentation.
All files and directories inside `archive/` are **strictly read-only**. Automated agents and human creators must never modify copy, metadata, or assets within archived records.

If an archived asset requires updating or re-release, create a new active packet under `content/` and reference the archived packet ID in `lineage.repurposed_from`.

## 2. Directory Structure

```
archive/
├── README.md                 # Archival policy specification
├── legacy-root-content/      # Pre-packet legacy documentation files
└── packets/                  # Retired content packets organized by YYYY/MM/
```

### 2.1 Legacy Root Content (`archive/legacy-root-content/`)
Contains historical documentation created before the packet-based architecture was established:
- `core-architecture.md`, `linkedin-insights.md`, `personal-branding.md`, `profile-rebuild.md`, `recruiter-search-works.md`, `connections-logic.md`, `zone-1.md` through `zone-5.md`.

### 2.2 Retired Content Packets (`archive/packets/YYYY/MM/`)
Contains complete packet folders relocated from `content/` once their lifecycle status reaches `archived`.
