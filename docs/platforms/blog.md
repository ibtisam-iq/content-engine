# Blog Platform Guidelines

## 1. Target Audience

Software engineers, platform architects, and DevOps practitioners seeking thorough, reproducible technical deep dives and reference architectures.

## 2. Supported Formats and Template Mapping

- **Output Format**: `article`
- **Scaffolding Template**: `templates/channels/blog-article.md`
- **Channel Filename**: `channels/blog.md`

## 3. Structural Standards

- **Technical Headline**: Must clearly state the engineering subject, system scale, or architectural problem solved.
- **Outline & Structure**: Must include structured headings covering:
  1. Architectural Problem Statement
  2. Existing Alternatives and Trade-Offs
  3. System Design and Reference Architecture
  4. Code Implementation and Configuration
  5. Production Benchmarks and Lessons Learned
- **Reproducibility**: Must embed verifiable configuration blocks, command-line logs, or GitHub repository links.

## 4. Metadata and Schema Compliance

Every Blog channel file must conform strictly to `schemas/channel.schema.json`:
- `platform`: `"blog"`
- `format`: `"article"`
- `channel_status`: Valid status enum (`draft`, `review`, `ready`, `scheduled`, `published`, `archived`)
- `performance_metrics`: Tracks `impressions`, `engagements`, `likes`, `comments`, `shares`, `clicks`, `conversions`, and `last_measured_at`.

## 5. Tone and Style Constraints

- Exhaustive, technical, objective, and reproducible.
- Never use em dash characters anywhere.
- Avoid second-person language; document engineering systems directly.
