# DebugBox LinkedIn Series (Phase 1) — FINAL v1

> **Created:** 2026-08-10
> **Supersedes:** Series 1 (2 posts) in `linkedin-publishing-plan.md`, which was never reworked.
> **Status:** Posts 1 to 3 published. Posts 4 and 5 drafted and revised below, ready to copy.
> **Count:** 5 posts. 2 product, 1 tutorial, 2 engineering-practice closers.
> **Formatting:** no em dashes, no backticks, no angle-bracket notation.
> **House rule:** body 150 to 200 words, every link in the first comment.

---

## PUBLISHED STATE (measured 2026-08-10)

| # | Post | Age | Words | Impressions | Reactions | Comments | Reposts | Platform engaged |
|---|---|---|---|---|---|---|---|---|
| 1 | Toolkit launch, 93% smaller | 3w | ~230 | 748 | 3 | 6 | 0 | no |
| 2 | **Tutorial announcement** | 3w | ~200 | **2,361** | **19** | 4 | 4 | **iximiuz Labs commented** |
| 3 | Toolkit relaunch (v1.2.0) | 2w | ~160 | 638 | 1 | 0 | 0 | no |

For comparison, from `silverstack-final-posts.md`:

| Post 2, SilverStack platform story | 1w | ~450 | 1,552 | 31 | 3 | 4 | **Ivan Velichko commented** |

---

## WHAT THE NUMBERS ACTUALLY SAY

### Length is not the lever

This was the working theory and the data kills it.

**Post 3 is the shortest post in the series (~160 words, dead centre of the house rule) and performed
worst of all five (638 impressions, 1 reaction).** It is a tightened rewrite of Post 1 and it did worse
than the longer original. Meanwhile the SilverStack platform post ran to ~450 words, more than double
the house rule, and pulled 31 reactions.

Keep the 150 to 200 word rule. It makes posts better to read. Do not expect it to move reach.

### Borrowed reach is the lever

The two posts that outperformed are the two where the platform engaged:

- Post 2 here: iximiuz Labs commented. 2,361 impressions, 19 reactions.
- SilverStack Post 2: Ivan Velichko commented. 1,552 impressions, 31 reactions.

The three that did not get platform engagement all landed between 638 and 748 impressions, which
looks like the ceiling of the current follower graph. The audience is mostly students and learners;
the audience that converts is reached through someone whose followers are DevOps engineers.

**Design every post so that someone with the right audience has a reason to amplify it.** Not by
tagging them. By publishing something genuinely worth their audience seeing.

### Do not republish the same post

Posts 1 and 3 are the same product announcement written twice, a week apart. The second did worse on
every measure. Followers had already seen it and the feed almost certainly treated it as repetitive.
If a post underperforms, the next post should be a different angle, not the same one tightened.

---

## AUDIENCE READ FOR THE REMAINING TWO

Posts 4 and 5 are engineering-practice posts about the DebugBox repo. Neither has a platform hook,
and on the evidence above both will land near the 700 impression ceiling if published as-is.

That is acceptable. **They are series closers, not growth posts.** Their job is to finish Phase 1 with
substance so the body of work reads complete, and to give senior visitors something to find when they
land on the profile from a post that did travel.

Judge them on craft, not reach. Do not spend a platform mention trying to rescue their numbers.

| | Post 4 (docs) | Post 5 (CI order) |
|---|---|---|
| Hook strength | Strong, and universal | Strong, but specialist |
| Reaches learners | Yes, duplication is a beginner-legible problem | Partly |
| Reaches seniors | Yes | Yes |
| Original word count | ~330 | ~380 |
| Revised | ~190 | ~190 |
| Ship | First | Second |

**Publish Post 4 first.** Documentation duplication is a problem a learner recognises, so it has the
wider door. Post 5 assumes the reader already runs a pipeline.

---

## 1. PUBLISHED — Toolkit launch

> Published 3w ago. 748 impressions, 3 reactions, 6 comments. Kept for the record.

I built a Kubernetes debugging toolkit. The smallest variant is 93% smaller than netshoot.

netshoot pulls 202 MB every time you need to check DNS on a pod. On an edge cluster or a metered connection, that bandwidth adds up fast.

DebugBox fixes this by splitting tools into three variants so you pull only what the task requires:

Lite (15 MB): curl, dig, netcat, jq, yq
Balanced (47 MB): tcpdump, openssl, strace, kubectx/kubens
Power (91 MB): tshark, nmap, iptables, conntrack

One command:
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

Every variant is multi-arch (amd64 + arm64), Trivy-scanned on every release with hard-fail on HIGH/CRITICAL, and published to both GHCR and Docker Hub.

v1.2.0 is live. MIT licensed and open for contributions.

I also published a hands-on tutorial covering all three variants end-to-end in a live Kubernetes playground, no local cluster required.

What does your team use for ephemeral container debugging, and what is the biggest friction point?

---

## 2. PUBLISHED — Tutorial announcement (BEST PERFORMER)

> Published 3w ago. **2,361 impressions, 19 reactions, 4 comments, 4 reposts.**
> iximiuz Labs commented: "Great initiative, Ibtisam! These minimal debugging toolbox images will
> definitely come in handy."
>
> **This is the template.** A tutorial announcement on someone's platform is a contribution, so the
> platform has a reason to amplify without being asked. Reuse this shape for every future tutorial.

Most people never practice ephemeral container debugging until they're already mid-incident.

I published a hands-on DebugBox tutorial built to close that gap. It deploys a real two-service app into a live Kubernetes playground. No local cluster, no setup. Just 10 exercises, variant by variant:

Lite: DNS resolution and HTTP reachability, sharing the target pod's network namespace with kubectl debug --target

Balanced: packet capture, TLS inspection, and system call tracing

Power: protocol dissection with tshark and conntrack, using debug pods with NET_ADMIN and NET_RAW when ephemeral containers aren't enough

You attach, run the command, and see the real output.

If kubectl debug and ephemeral containers are still unfamiliar territory, this is a safe place to practice before you need them in an actual incident.

---

## 3. PUBLISHED — Toolkit relaunch

> Published 2w ago. 638 impressions, 1 reaction, 0 comments. Worst performer.
> Near-duplicate of Post 1. Recorded as the evidence for the do-not-republish rule above.

netshoot is 202 MB. You pull all of it to run a single dig command.

DebugBox v1.2.0 is live: three right-sized debugging images instead of one bloated one.

Lite (15 MB): DNS, curl, JSON/YAML checks
Balanced (47 MB): tcpdump, openssl, strace, kubectx/kubens, the daily driver
Power (91 MB): tshark, nmap, iptables, conntrack, for when you actually need the deep end

Every variant is multi-arch (amd64 + arm64), Trivy-scanned on every release with a hard-fail on HIGH/CRITICAL, and published to both GHCR and Docker Hub. MIT licensed, open for contributions.

What does your team pull today just to check DNS on a pod?

---

## 4. READY TO SHIP — `db-04-docs` — Documentation duplication

> **Revised from ~330 to ~190 words. Numbers re-verified against the repo 2026-08-11.**
> Cuts: the "unmaintained index with no owner" line, the two-paragraph CI checks section (moved to
> first comment), the "code has a compiler" closing pair (moved to first comment).
> **Corrections:** hook now names DebugBox and uses 474, the real deletion count, so it reconciles
> with the closing line. "14" corrected to 16. The 46 to 47 MB detail was a later change than this
> cleanup, so it is now stated generically.
>
> **Verification (commit `8310128`, scope `docs/` + `README.md`):** 117 added, 474 removed, exactly.
> The balanced size string appeared in 10 files, exactly. A runnable pull command appeared in 16.
> `docs/getting-started/installation.md` went 0 added, 47 removed, so it genuinely stopped existing.

I deleted 474 lines of documentation from DebugBox, my open source Kubernetes debugging toolkit. The docs got better.

The problem was never too little documentation. It was the same fact written down in too many places.

One image's compressed size appeared in 10 separate files. Pull commands appeared in 16. None of it was wrong when it was written.

Then the image changed. Dropping one tool and adding another moved its size by a megabyte, and correctness suddenly depended on me finding all 10 files and remembering why each existed.

A reader who finds two different numbers does not work out which page was updated most recently. They stop trusting the whole site.

So I applied one rule: every fact gets exactly one home. Everything else links to it.

The tool inventory now lives in a single manifest.yaml and renders into one reference page. Adding a tool is a one line change. An entire installation page turned out to be a longer restatement of the quick start, so it stopped existing.

117 lines added. 474 removed.

Where has duplicated documentation burned you the worst?

**First comment** (links first, because LinkedIn collapses a comment after the first two lines):

Docs: https://debugbox.ibtisam-iq.com
Single source of truth: https://github.com/ibtisam-iq/debugbox/blob/main/docs/manifest.yaml
Repo: https://github.com/ibtisam-iq/debugbox

The deletion was the easy part. Proving every surviving cross-reference still pointed somewhere real is not a job for human review.

Two checks run on every push. A strict docs build fails on a broken internal reference. A link checker crawls every rendered page and fails on dead external URLs, because a link to someone else's docs can rot without me touching a thing.

Code has a compiler that refuses to lie to you. Documentation only has the checks you choose to add.

---

## 5. READY TO SHIP — `db-05-cicd` — Test before push

> **Revised from ~380 to ~195 words.** Cuts: the six-item smoke test inventory, the QEMU detail,
> the 22-tags detail, the `make check` paragraph (all in first comment).
> **Correction:** line 3 now says what DebugBox is, so the post stands alone for a cold reader.
> **Verified:** `ci.yml` matrix is `[amd64, arm64]` x `[lite, balanced, power]` = 6 jobs;
> `trivy-action@v0.36.0` runs `severity: HIGH,CRITICAL` with `exit-code: '1'`.

Most container pipelines push the image, then test it. That order is backwards.

If the test fails after the push, a broken image is already sitting in your registry under a real tag. Someone can pull it. Something might already have.

DebugBox is a Kubernetes debugging toolkit I publish as three images. Nothing reaches a registry until it has passed everything.

Every commit builds 6 images: 3 variants across 2 architectures. Each is loaded into the local Docker daemon. None are pushed.

Then each one has to earn it.

Compressed size is measured on every build and printed in the job log, because size is the entire point of this project. A regression is visible before release rather than in a user's slow pull.

A smoke test runs inside the container, not against it, verifying it works as a runtime.

Trivy scans with HIGH and CRITICAL set to exit code 1. Any unsuppressed finding fails the job, and the only exceptions are tracked, with reasons, in a committed .trivyignore.

Publishing is a separate workflow, triggered only by a version tag, that scans again before it builds and pushes the multi-arch images.

A registry should be a record of things that already passed. Not the place you find out.

What does your pipeline verify before the push, rather than after?

**First comment** (links first, because LinkedIn collapses a comment after the first two lines):

Full write-up: https://blog.ibtisam-iq.com/multi-arch-container-ci-pipeline/
The workflow: https://github.com/ibtisam-iq/debugbox/blob/main/.github/workflows/ci.yml

The smoke test makes no network calls and downloads nothing. A CI check that depends on the internet fails for reasons that have nothing to do with your commit. The deeper suite that does hit the network runs locally, where a flake costs a rerun instead of a red main branch.

It checks the container as a runtime: identity resolves, /tmp is writable, procfs is mounted, the network stack answers, DNS config is present, core binaries resolve on PATH.

The same gates run locally. One command is lint, build, test, scan, in that order, so the feedback loop is a terminal and not a CI queue.

---

## SEQUENCING

```
4  Documentation duplication   ship first, wider door
5  Test before push            ship second, closes Phase 1
```

Leave the usual gap between them. Do not publish either in the same week as a SilverStack post, so
the two series do not compete for the same feed slot.

After Post 5, Phase 1 is complete: 5 LinkedIn posts, 1 tutorial, and the blog companions already live.

## WHAT TO CARRY INTO LATER PHASES

1. **A tutorial announcement is the highest-yield post shape available.** It has now worked once
   (Post 2, 2,361 impressions). The rootfs tutorial post in `silverstack-final-posts.md` section 5b
   is the same shape and should be expected to perform similarly.
2. **Length discipline is for the reader, not the algorithm.** Post 3 proves it.
3. **Never publish the same angle twice.** Post 3 proves that too.
4. **Craft posts are for the profile, not the feed.** Publish them, expect ~700 impressions, and
   judge them by what a senior visitor finds when they arrive from a post that travelled.
