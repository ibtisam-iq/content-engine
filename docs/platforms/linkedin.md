# LinkedIn Platform Guidelines

## 1. Target Audience

Engineering leaders, platform architects, staff engineers, technical hiring managers, and senior practitioners.

## 2. Supported Formats and Template Mapping

- **Post Format (`post`)**: Multi-paragraph structured update scaffolded from `templates/channels/linkedin-post.md`.
- **Carousel Format (`carousel`)**: Slide-based visual technical breakdown scaffolded from `templates/channels/linkedin-carousel.md`.
- **Channel Filename**: `channels/linkedin.md`

## 3. Structural Standards

- **Hook**: First two lines must deliver an immediate, sharp technical insight, contrarian perspective, or concrete architectural outcome before the visual fold.
- **Formatting**: Use short paragraphs (1 to 3 sentences maximum), clean line breaks, and minimal bulleted lists.
- **Length**: Multi-paragraph structured post (150 to 300 words).
- **Call to Action (CTA)**: End with a thoughtful, open-ended technical question that encourages practitioners to share architectural experiences.

## 4. Metadata and Schema Compliance

Every LinkedIn channel file must conform strictly to `schemas/channel.schema.json`:
- `platform`: `"linkedin"`
- `format`: `"post"` or `"carousel"`
- `channel_status`: Valid status enum (`draft`, `review`, `ready`, `scheduled`, `published`, `archived`)
- `performance_metrics`: Tracks quantitative telemetry (`impressions`, `engagements`, `likes`, `comments`, `shares`, `clicks`, `conversions`, `last_measured_at`).

## 5. Tone and Style Constraints

- Direct, reflective, experience-driven, and highly technical.
- Avoid generic motivational buzzwords or shallow corporate praise.
- Never use em dash characters anywhere.
- Avoid second-person phrasing; state architectural trade-offs directly.
