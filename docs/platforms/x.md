# X (Twitter) Platform Guidelines

## 1. Target Audience

Software engineers, open-source maintainers, system architects, and technical developers seeking fast, high-signal architectural takeaways.

## 2. Supported Formats and Template Mapping

- **Output Format**: `post` or `thread`
- **Scaffolding Template**: `templates/channels/x-post.md`
- **Channel Filename**: `channels/x.md`

## 3. Structural Standards

- **Hook**: First sentence must deliver a sharp, compressed engineering take or contrarian finding.
- **Formatting**: Direct sentences, clear line breaks, and punchy technical phrasing.
- **Length**: Single post under 280 characters, or a numbered multi-post thread where each post represents an atomic architectural lesson.
- **Call to Action (CTA)**: Include a direct link to canonical repository assets or long-form engineering articles.

## 4. Metadata and Schema Compliance

Every X channel file must conform strictly to `schemas/channel.schema.json`:
- `platform`: `"x"`
- `format`: `"post"` or `"thread"`
- `channel_status`: Valid status enum (`draft`, `review`, `ready`, `scheduled`, `published`, `archived`)
- `performance_metrics`: Tracks `impressions`, `engagements`, `likes`, `comments`, `shares`, `clicks`, `conversions`, and `last_measured_at`.

## 5. Tone and Style Constraints

- High-signal, sharp, technical, and concise.
- Never use em dash characters anywhere.
- Avoid second-person language; phrase takes as direct architectural observations.
