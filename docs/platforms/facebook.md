# Facebook Platform Guidelines

## 1. Target Audience

Technical practitioner groups, engineering community pages, software developer forums, and open-source practitioners.

## 2. Supported Formats and Template Mapping

- **Output Format**: `post`
- **Scaffolding Template**: `templates/channels/facebook-post.md`
- **Channel Filename**: `channels/facebook.md`

## 3. Structural Standards

- **Hook**: First two lines must present a clear engineering finding, architectural decision, or practical software lesson accessible to developer community feeds.
- **Formatting**: Short paragraphs (1 to 3 sentences), clean spacing, and readable technical breakdowns without excessive corporate jargon.
- **Length**: Medium-length structured post (100 to 250 words).
- **Call to Action (CTA)**: Provide a direct link to the canonical engineering blog post, reference architecture repository, or documentation page.

## 4. Metadata and Schema Compliance

Every Facebook channel file must conform strictly to `schemas/channel.schema.json`:
- `platform`: `"facebook"`
- `format`: `"post"`
- `channel_status`: Valid status enum (`draft`, `review`, `ready`, `scheduled`, `published`, `archived`)
- `performance_metrics`: Must track `impressions`, `engagements`, `likes`, `comments`, `shares`, `clicks`, `conversions`, and `last_measured_at`.

## 5. Tone and Editorial Constraints

- Direct, informative, technical, and developer-centric.
- Never use em dash characters anywhere in copy or front matter.
- Avoid second-person language ("you", "your"); phrase technical advice objectively.
