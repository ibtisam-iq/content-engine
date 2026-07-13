# Raw Source Material (`source-material.md`)

## 1. Reference Links and Citations

- Repository architecture specification: `docs/architecture/packet-model.md`
- Metadata schema contract: `schemas/packet.schema.json`

## 2. CLI Commands for Verification

```bash
# Validate schema and front matter
./scripts/validate-packet.sh --packet content/2026/07/2026-07-12-sample-packet
```

## 3. Architecture Snippet

```yaml
# Packet layout
content/2026/07/2026-07-12-sample-packet/
├── packet.yaml
├── README.md
├── context.md
├── source-material.md
├── notes.md
├── assets/
│   ├── raw/
│   └── exports/
└── channels/
    ├── linkedin.md
    ├── x.md
    ├── facebook.md
    └── blog.md
```
