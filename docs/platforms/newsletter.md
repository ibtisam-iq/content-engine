# Newsletter Platform Guidelines

## 1. Target Audience

Subscribed engineering leaders, platform architects, and software developers reading weekly or bi-weekly technical digests via email.

## 2. Supported Formats and Template Mapping

- **Output Format**: `newsletter`
- **Scaffolding Template**: `templates/channels/newsletter-issue.md`
- **Channel Filename**: `channels/newsletter.md`

## 3. Structural Standards

- **Subject Line**: High-signal engineering takeaway or architectural digest title.
- **Executive Summary**: 3-bullet executive overview highlighting core findings, trade-offs, and actionable architecture recommendations.
- **Main Technical Essay**: Structured breakdown synthesizing core briefing materials into an engaging editorial digest.
- **Call to Action**: Invite technical feedback or point readers to the underlying code repository.

## 4. Metadata and Schema Compliance

Every Newsletter channel file must conform strictly to `schemas/channel.schema.json`:
- `platform`: `"newsletter"`
- `format`: `"newsletter"`
- `channel_status`: Valid status enum (`draft`, `review`, `ready`, `scheduled`, `published`, `archived`)
- `performance_metrics`: Tracks `impressions`, `engagements`, `likes`, `comments`, `shares`, `clicks`, `conversions`, and `last_measured_at`.

## 5. Tone and Style Constraints

- Curated, structured, high-signal, and technical.
- Never use em dash characters anywhere.
- Avoid second-person phrasing; state architectural insights directly.
