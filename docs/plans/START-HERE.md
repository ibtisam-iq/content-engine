# START HERE

> **Updated:** 2026-07-30
> One page telling you which file to open for what. Nothing else lives here.

---

## WHERE THINGS ARE

| I want... | Open this |
|---|---|
| The whole 24-post plan at a glance | `linkedin-publishing-plan-overview.html` (in a browser) |
| **Phase 1 post drafts (DebugBox, 5 posts)** | **`debugbox-final-posts.md`** |
| **Phase 2 post drafts (SilverStack, 6 posts)** | **`silverstack-final-posts.md`** |
| **Phase 3 post drafts (Pipelines, 3 posts)** | **`phase3-pipeline-engineering.md`** |
| What the blog posts are and when to publish them | `blog-companion-index.md` |
| Phases 4 to 6 | `linkedin-publishing-plan.md`. **Still original draft depth.** |
| Why Phase 2 was restructured | `phase2-silverstack-content-architecture.md` (analysis, superseded by the final file) |

**The files you copy from are `debugbox-final-posts.md`, `silverstack-final-posts.md` and
`phase3-pipeline-engineering.md`.**
Both contain every post body and first comment as copy-ready blocks.

---

## THE MODEL

**LinkedIn is discovery. The blog and repos are depth.**

- LinkedIn body: 150 to 200 words. Earns the click. Never carries the full argument.
- First comment: every link. Posted by you within 60 seconds of publishing.
- Blog: 1,400 to 2,200 words. Must stand alone for someone who never saw the post.
- Repo: the raw implementation.

**Blog posts publish before their LinkedIn post.** A first comment linking to a 404 is worse than no
link at all.

---

## CURRENT STATE

| Phase | Posts | Status |
|---|---|---|
| 1 Open Source (DebugBox) | 1 to 5 | **3 published, 2 ready.** Reworked. Measured engagement recorded. |
| 2 Platform Foundation (SilverStack) | 3 to 8 | **Final.** 6 posts, copy-ready. |
| 3 Pipeline Engineering | 9 to 11 | **Final.** 3 posts, copy-ready. |
| 4 Deployment Breadth | 12 to 17 | Original draft. |
| 5 Crown Jewel (EKS GitOps) | 18 to 21 | Original draft. |
| 6 Closing | 22 to 24 | Original draft. |

**Blog:** 7 posts written, in `/Users/ibtisam-iq/gitHub/blog`. All validated against the repo schema.

---

## TO PUBLISH, IN ORDER

1. **Deploy the blog.** All seven posts at once is simplest and removes every timing dependency.
   Run `mkdocs build --strict` first.
2. **Engage with the iximiuz founder's post** (comment plus repost), at least a week before Phase 2
   Post 4 goes out.
3. **Phase 2, posts 3 to 8.** Two per week, Tuesday and Thursday. Copy from
   `silverstack-final-posts.md`.
4. **Phase 3, posts 9 to 11.** Same cadence. Copy from `phase3-pipeline-engineering.md`.
5. **Rework Phase 4** before publishing it. It is still at the original draft depth and contains the
   same class of problems Phases 2 and 3 had.

---

## OPEN ITEMS

**Blocking nothing, but worth doing:**

- `COPY examiner*` in the silver-stack base Dockerfile has no matching files in the repo, so a clean
  rebuild of `ubuntu-24-04-rootfs` fails. Children still build because the base is already on GHCR.
- "Production-grade" appears in all five public iximiuz manifest descriptions. Phase 2 Post 3 sends
  people straight to that profile.
- The cron in `iximiuz-playground-keeper.yml` is commented out, so as committed it only runs on
  manual dispatch. Phase 2 Post 7 links three live service URLs that depend on uptime.
- The resource model is unresolved between the pricing page, the runbook and `cicd-stack.yml`. No
  post quotes a number, so nothing is blocked.

---

## CONVENTIONS THAT APPLY TO EVERY PHASE

**Vocabulary:** playground (not environment), machine or server (not node), tools (CLI binaries),
services (systemd daemons), everything (covering both). Never "software".

**Formatting:** no em dashes, no backticks, no angle brackets. LinkedIn renders none of them well.

**Every post needs an anchor.** One line establishing what the project is and that it is public. A
situational opener is not an anchor; an unbound reference like "this project" is a failure.

**Links only in first comments.** LinkedIn suppresses reach on bodies with outbound links.

**Blog internal links are `/<slug>/`.** Never include the folder.
