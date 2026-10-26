# Phase 3: Pipeline Engineering — FINAL v3

> **Revised:** 2026-07-31
> **Status:** Final. Copy-paste ready. Full bodies below.
> **Count:** 4 LinkedIn posts (global positions 9 to 12) + 8 blog posts
> **Cadence:** 2/week (Tue + Thu), ~1.5 weeks
> **Formatting:** no em dashes, no backticks, no angle-bracket notation
> **Blog companions:** all eight are written. Post 9 is **gated** (publish its blog first).
> See `blog-companion-index.md` for the full map and publish order.

> **2026-07-31 revision.** A source-of-truth audit against the three repos found two false claims in
> the previous "Verified facts" block and corrected them (see that section). The blog set grew from 4
> to 8 posts after mining material that was buried in the repos. **The LinkedIn count stays at 3** —
> LinkedIn is the discovery layer, not a coverage obligation. The four new blog posts are routed
> through the existing first comments rather than earning posts of their own.

---

## THE OPERATING MODEL (applies to every phase from here)

**LinkedIn is the discovery layer. The blog and repos are the depth layer.**

- LinkedIn post earns the click. 150 to 200 words, hard ceiling 200.
- First comment routes the reader. All links live here, never in the body.
- Blog carries the full technical argument. 1,400 to 2,200 words.
- Repo holds the raw implementation.

No LinkedIn body in this phase carries a complete technical case. That is deliberate.

### LinkedIn rules

| Rule | Value |
|---|---|
| Body length | 150 to 200 words, hard ceiling 200 |
| Hook | 2 lines max, must work alone before "see more" |
| Legible by | Line 3 |
| Ideas per post | Exactly one. Supporting facts get one line each. |
| Anchor | One line establishing these are public apps |
| Paragraphs | Max 6, one to three sentences each |
| CTA | Answerable in one sentence from the reader's own experience |

**The test:** if a paragraph explains rather than states, it belongs in the blog.

### v1 mistakes, recorded so they are not repeated

All four v1 drafts were 400 to 430 words, roughly 2,400 to 2,800 characters. Three of four buried
their payoff past paragraph six. Post 4 (release identity) was a reasoning chain that cannot survive
feed reading, and became blog-only.

---

## SEQUENCE

```
 9  Three pipelines       VALUE-FIRST  free complete resource, widest door
10  Jenkins vs GHA        HYBRID       comparison, hard numbers, most reshareable
11  Green both ways       HYBRID       the senior-legible one             [ADDED 2026-08-12]
12  Alpine cascade        HYBRID       deepest story                      [BLOG GATED]
```

**Reordered 2026-08-12 on the Phase 1 evidence.** The previous order was story first, value last. The
measured data says the opposite for this audience. DebugBox Post 2 gave away a free hands-on resource
and did **2,361 impressions, the best of five**. The two posts that announced work rather than giving
something away did 748 and 638. The giveaway shape is the only one that has outperformed for this
following.

So: value first, and it doubles as the series opener because it introduces all three apps. Comparison
second, while attention is highest, because tool comparisons reliably draw opinionated replies. Silent
failure third, since it needs no Jenkins knowledge and reads to the widest slice of engineers. The
Alpine story last, because it is the most technically demanding, has the narrowest door for a learner
audience, and is the only post carrying a publish dependency on its blog.

**Trade-off accepted:** Alpine has the best pure hook in the phase and going last means fewer readers
reach it. That is the cost of matching the order to the audience that exists rather than the one the
writing deserves.

### Why 4 posts against 8 blogs

The blog set doubled in the 2026-07-31 audit. The LinkedIn count did not, on purpose.

Each additional post costs a slot in the global sequence and competes with the phase's own posts for
attention. A blog post that has no LinkedIn post loses nothing: it is reachable from the first
comment of an adjacent post, from the series footer of its siblings, and from search. A weak LinkedIn
post costs a publishing slot and dilutes the three that carry the phase.

**2026-08-12 amendment.** The rule "a blog post with no LinkedIn post loses nothing" held for three
of the four routed posts. It did not hold for `jenkins-pipeline-hardening-fixes`, which was carrying
the strongest unused hook in the phase (twelve real defects, green before each fix and green after)
buried in another post's first comment. It is now post #11. The other three routings stand: they are
genuinely supporting material, not arguments of their own.

Routing for the three added posts:

| Blog post | Routed through | Why there |
|---|---|---|
| Maven BOM overrides | #9 first comment | It is the direct sequel: what fixing those 7 CVEs took |
| Buildx / Trivy image not found | #10 first comment | GHA-side bug, same frame |
| Frontend serving journey | #11 first comment | Explains why the Node app ships two images |

---

## #9 (global) · Post 1 of 4 — `p3-04-three-pipelines` · VALUE-FIRST

**Asset:** `assets/p3-03-three-pipelines-stages.svg` **(built)**. The 11-stage shared spine drawn from
the real stage names, with each language's additions counted beneath.
**Blog companions:** https://blog.ibtisam-iq.com/pipeline-contract-three-ecosystems/ and https://blog.ibtisam-iq.com/release-identity-image-tagging/ — both non-gating

### Body

```text
Most CI tutorials give you a fragment. Build, test, push, done.

The gap between that and something you would actually run is where all the work is.

So I wrote three complete pipelines and left them public. A Spring Boot app, a Flask app, and a Node three-tier app. Each repo carries the full thing in both Jenkins and GitHub Actions, including the security scanning and quality gates a tutorial skips.

If you work in one of those stacks, you can take the whole pipeline rather than assembling one from pieces.

Writing it three times also answered a question I had. The stage order never changed: scan, version, build, test, quality gate, build image, scan image, publish, hand the tag to the deployment repo.

Everything inside those stages did. Java came out at 14 stages, Python 16, Node 21, because Node ships two images and Python has to build its own environment before it can do anything.

Portability is not uniformity. The contract stays fixed. The implementation stays native to the language.

All three are public, links below.

Post 1 of 4 on the CI pipelines behind these apps.

If you maintain pipelines across languages, what did you standardise and what did you give up on?
```

### First comment

```text
All three, each with both a Jenkinsfile and a GitHub Actions workflow:
https://github.com/ibtisam-iq/java-monolith-app
https://github.com/ibtisam-iq/python-monolith-app
https://github.com/ibtisam-iq/node-monolith-3tier-app

The full breakdown of what stayed fixed and what diverged, including the security tooling per language:
https://blog.ibtisam-iq.com/pipeline-contract-three-ecosystems/

If you copy one, the parts to change are the credential IDs and the registry names. Everything else is stack-specific and labelled in the comments.

The Node one has a detail worth stealing. It builds two images, client and server, and both carry the same tag because they came from one commit in one run, written to the deployment repo in a single commit. Split that across two pipelines and you can end up deploying a client from build 42 against a server from build 41. A new frontend talking to an old API, with nothing obviously broken and nothing pointing at the cause. The full reasoning:
https://blog.ibtisam-iq.com/release-identity-image-tagging/

Why that app ships two images at all, and the three wrong answers I tried before landing on Nginx as a reverse proxy:
https://blog.ibtisam-iq.com/frontend-serving-nginx-reverse-proxy/
```

---

## SOURCE FILES USED

**java-monolith-app**: `Jenkinsfile` (911, `FIX #1` to `#13`), `.github/workflows/ci.yml`
(664, `FIX R4#2` to `R4#11`), `Dockerfile`, `pom.xml`, `docs/trivy-troubleshooting.md`
**python-monolith-app**: `Jenkinsfile` (1092), `.github/workflows/ci.yml` (869), `VERSION`
**node-monolith-3tier-app**: `Jenkinsfile` (1257), `.github/workflows/ci.yml` (649),
`Dockerfile.client`, `Dockerfile.server`, `nginx/default.conf`, `nginx/docker.conf`,
`client/webpack.config.js`, `docs/migration/06-frontend-serving-journey.md`,
`docs/migration/07-ci-pipeline-design-decisions.md`
**runbook**: `java-monolith/phase-3a-jenkins-pipeline.md`, `phase-3b-github-actions.md`, `index.md`
**projects**: `data/projects.yaml` (`devsecops-pipeline-engineering` entry)

**Verified facts** (re-audited against the repos 2026-07-31):

- Stage counts 14 Java / 16 Python / 21 Node. Line counts Jenkins 911/1092/1257 vs GHA 664/869/649.
- Java runtime is jammy (migrated off Alpine); Node runtime is still Alpine.
- Tag format `{version}-{7-sha}-{build}` from Maven / package.json / VERSION file.
- **`:latest` IS pushed** to all three registries; the CD manifest receives the immutable tag only.
- Three registries ship, not four. ECR is scaffolded and commented out in both Jenkins and GHA.

**Trivy gating, per file.** This is the fact most likely to be stated wrongly, so it is a table.
Jenkins on the left, GitHub Actions on the right:

| Pass | Java | Python | Node |
|---|---|---|---|
| Filesystem, CRITICAL | fail / warn | fail / warn | fail / fail |
| Image, OS packages | fail / warn | warn / warn | warn / warn |
| Image, library CRITICAL | fail / warn | fail / fail | fail / fail |

Two consequences for copy:

1. **Never write "libraries block on critical everywhere."** The Java GHA workflow reports on every
   pass, deliberately, because BankApp is inherited code and hard-failing someone else's dependency
   tree takes a decision that belongs to its maintainers. The line documents its own reversal:
   `exit-code: '0'  # Just to pass the scan step. Change to '1' to fail on CRITICALs.`
2. **Never write "the FS gate fails for Node only."** That is true of GitHub Actions and false of
   Jenkins, where all three block. The Java Jenkinsfile also has no OS/library split at all and
   blocks on any CRITICAL.

Safe framing for LinkedIn: describe the **split by fix ownership** as the design, and the seven
Spring CVEs it caught as what happened. Both are true. Claiming a specific gate currently blocks is
the thing that is not.

---

## #10 (global) · Post 2 of 4 — `p3-02-jenkins-vs-gha` · HYBRID

**Asset:** `assets/p3-02-jenkins-vs-gha-lines.svg` **(built)**. Real counts, per-app deltas, and the
+49% total.
**Blog companion:** https://blog.ibtisam-iq.com/same-pipeline-two-ci-engines/ — non-gating

### Body

```text
I built the same CI pipeline twice. Once in Jenkins, once in GitHub Actions.

Same stages, same tools, same result. Jenkins needed 26 to 94% more code, depending on the app.

911 lines against 664 for the Java app. 1092 against 869 for Python. 1257 against 649 for Node.

Some of that gap is comments. I documented the Jenkins version far more heavily, because its plugin dependencies are invisible until they break and then you get "No such DSL method" and nothing else to go on.

The rest is real. Jenkins reaches for a plugin where GitHub Actions uses plain shell.

But the difference that actually mattered was not syntax. GitHub Actions forced me to decide what happens when two runs overlap: cancel on pull requests, never on main, because killing a run mid-push can leave an image tag in one registry and missing from the other two.

Jenkins let me not think about that. That is not always a feature.

All three apps are public with both implementations side by side.

Post 2 of 4 on the DevSecOps pipelines.

If you have run the same pipeline on two engines, what caught you out?
```

### First comment

```text
The full comparison, covering plugins as invisible dependencies, secret handling, artifacts, and why the Node gap is 94% where Python is only 26%:
https://blog.ibtisam-iq.com/same-pipeline-two-ci-engines/

Both versions in one repo, easy to diff:
https://github.com/ibtisam-iq/java-monolith-app/blob/main/Jenkinsfile
https://github.com/ibtisam-iq/java-monolith-app/blob/main/.github/workflows/ci.yml

Same pair in the other two:
https://github.com/ibtisam-iq/python-monolith-app
https://github.com/ibtisam-iq/node-monolith-3tier-app

Twelve fixes I made to the Jenkins version, none of which were reported by anything, because the pipeline was green before each one and green after:
https://blog.ibtisam-iq.com/jenkins-pipeline-hardening-fixes/

One more real difference: artifacts. GitHub Actions makes Trivy reports, coverage HTML and lint output downloadable from the run page in one step. Getting the same visibility out of Jenkins meant archiving plus a plugin to render it.

And one bug that only exists on the GitHub Actions side: buildx does not build into the Docker daemon, so Trivy could not find the image the previous step had just built. https://blog.ibtisam-iq.com/buildx-load-trivy-image-not-found/
```

---

## #11 (global) · Post 3 of 4 — `p3-03-green-both-ways` · HYBRID

**Asset:** `assets/p3-04-green-both-ways.svg` **(built)**. Two identical green ticks, twelve defects between them.
**Blog companion:** https://blog.ibtisam-iq.com/jenkins-pipeline-hardening-fixes/ — non-gating

> **Added 2026-08-12.** Promoted out of #10's first comment. Reasoning in "Why 4 posts against 8 blogs".
> **Both examples verified in `java-monolith-app/Jenkinsfile`:** FIX #3 (`|| echo` swallowing every
> non-zero git exit, not only "nothing to commit") and FIX #6 (`docker build` without `--pull`, so the
> build used whatever base was cached on the agent). Twelve distinct `FIX #` ids confirmed.
>
> **CTA question kept**, against the DebugBox finding that statement-enders outperform. Three reasons:
> this phase's own rules require a CTA, all three sibling posts have one and a numbered series should
> not break form mid-run, and the DebugBox evidence is confounded because its best performer also had
> platform engagement.

### Body

```text
My Jenkins pipeline was green. I found twelve real defects in it anyway.

Not one was reported by anything. The build passed before each fix and passed after.

This is from one of three apps I keep public with their full DevSecOps pipelines.

One example. A git commit guarded with "|| echo Nothing to commit". That swallows every non-zero exit, not just the one you meant. Detached HEAD, merge conflict, broken git config: all of them printed "Nothing to commit" and the run stayed green.

Another. The docker build ran without --pull, so it used whatever base image happened to be cached on the agent. The image I shipped was not built from the base I thought I was building from.

Neither is exotic. Both are the kind of line you write once and never look at again, because nothing ever draws your attention back to it.

A CI run tells you whether it finished. It does not tell you whether it was right.

Post 3 of 4 on the DevSecOps pipelines.

Which of your pipeline steps would still report success if it silently did nothing?
```

### First comment

```text
All twelve, each with what was wrong and why nothing caught it:
https://blog.ibtisam-iq.com/jenkins-pipeline-hardening-fixes/

The Jenkinsfile itself, with every fix numbered in the comments at the line it applies to:
https://github.com/ibtisam-iq/java-monolith-app/blob/main/Jenkinsfile

The same pipeline in all three apps:
https://github.com/ibtisam-iq/java-monolith-app
https://github.com/ibtisam-iq/python-monolith-app
https://github.com/ibtisam-iq/node-monolith-3tier-app

The twelve share one shape: a step that reports success whether or not it did its job. Guards that swallow more than they were meant to. Paths that resolve to something valid but wrong. Wrappers that quietly do more than you asked. None of them fail, which is exactly why they survive.

The subtlest was a coverage path. It expanded to WORKSPACE/./target/... which is valid POSIX, so nothing errored. But the SonarQube scanner resolves that string through Java's file handling, which does not normalise the "./", so it looked for a literal path that did not exist and silently dropped the coverage data.
```

---

## #12 (global) · Post 4 of 4 — `p3-01-alpine` · HYBRID

**Asset:** `assets/p3-01-alpine-scan-split.svg` **(built)**. Alpine, 5 to 15 criticals all marked no
fix available, against ubuntu 22.04 at zero, with the ownership split underneath. Built as a scan
summary rather than simulated terminal output, so no CVE identifiers are invented.
**Blog companion:** https://blog.ibtisam-iq.com/vulnerability-gate-blocked-every-build/ — **publish first**

### Body

```text
I moved my Java app to an Alpine base image to make it smaller.

It made the pipeline unbuildable.

This is from one of three apps I keep public with their full DevSecOps pipelines. The Jenkins pipeline fails the build on critical vulnerabilities, and Alpine kept reporting 5 to 15 critical CVEs in the OS layer, every one marked no fix available, because musl patches lag upstream by weeks.

So the gate was permanently red on things I could not fix.

The easy way out is lowering the threshold. That is turning the gate off and keeping the badge.

Instead I split the scan by who owns the fix. OS packages are the base image vendor's problem, so they report. Application libraries are mine, because I can bump a version in pom.xml, so that is where enforcement belongs.

Then the split caught 7 real critical CVEs in my Spring dependencies. Fixing those broke the SonarQube quality gate. Fixing that needed an actual code change.

Three failures in a chain, each one hidden behind the last.

A gate that fails on things you cannot fix is not a gate. It is a blocked pipeline that someone will eventually switch off.

Post 4 of 4 on the DevSecOps pipelines.

Where do you draw the line between what blocks a build and what only warns?
```

### First comment

```text
The full write-up, with the CVE tables, the three wrong fixes I rejected, and how the gates differ across the Java, Python and Node pipelines:
https://blog.ibtisam-iq.com/vulnerability-gate-blocked-every-build/

What fixing those 7 CVEs actually took, including the version override Maven silently ignored:
https://blog.ibtisam-iq.com/maven-bom-cve-overrides/

The pipeline itself, in both Jenkins and GitHub Actions form:
https://github.com/ibtisam-iq/java-monolith-app

The fix that is easy to miss: moving the runtime from Alpine to Ubuntu 22.04 took critical OS CVEs to zero on its own, because Canonical patches glibc in hours rather than weeks. Splitting the scan was the second half of the fix, not a replacement for it.
```

---

## BLOCKER: THE THREE APP REPOS HAVE NO LICENCE

**Found 2026-08-12. Must be resolved before #12 ships.**

```
java-monolith-app         NO LICENSE
python-monolith-app       NO LICENSE
node-monolith-3tier-app   NO LICENSE
debugbox                  MIT
silver-stack              MIT
```

Verified with `gh api repos/ibtisam-iq/<repo> --jq '.license.spdx_id'` and confirmed by the absence of
any `LICENSE` file in all three working trees. **Note:** `gh repo view --json licenseInfo` returns
`none` even for DebugBox, so it is not a reliable check. Use the `gh api` form.

Post #12 said "All three are MIT, links below" and its first comment says "If you copy one, the parts
to change are the credential IDs and the registry names." With no licence, default copyright applies
and nobody may legally copy any of it. The post's entire value proposition is an invitation readers
cannot lawfully accept.

**Interim fix applied:** the body now reads "All three are public, links below", which is true today.

**Preferred fix:** add an MIT `LICENSE` to all three repos, matching DebugBox and silver-stack, then
restore "All three are MIT". This is almost certainly the intent, since every other public repo in the
portfolio is MIT. Until that lands, do not restore the claim.

---

## ERRORS CORRECTED FROM THE ORIGINAL PLAN

### From the original plan

| Original claim | Reality |
|---|---|
| "14-stage pipeline" | 14 Java, 16 Python, 21 Node. True for one repo of three. |
| "implemented identically" | Wrong on both axes: diverges by language and by CI engine. |
| "why latest is a deployment antipattern" | All three repos push `:latest`. The accurate claim is that latest is published but never deployed. |

### From the v3 plan, found in the 2026-07-31 source audit

| v3 claim | Reality |
|---|---|
| "Trivy FS gate fails on CRITICAL for Node only" | True of GitHub Actions. False of Jenkins, where all three block. |
| "image gate ... fails on library CRITICAL everywhere" | False. Java GHA reports on every pass, deliberately. Java Jenkins has no OS/library split and blocks on any CRITICAL. |
| "4 blog posts" | 8. Four more were written after mining `docs/trivy-troubleshooting.md`, `docs/migration/06`, and the numbered `FIX` comments. |

### From the 2026-08-12 audit

| v3 claim | Reality |
|---|---|
| Post 12: "All three are MIT" | **False.** No licence on any of the three. See the BLOCKER section above. |
| Post 9: "That pipeline fails the build on critical vulnerabilities" | **True of Jenkins, false of GitHub Actions.** Java's GHA workflow sets `exit-code: '0'` on every Trivy pass, including the line that documents its own reversal. Post 10 tells readers both implementations sit side by side in the same repo, so a reader who follows the link finds a workflow that never fails. Corrected to "The Jenkins pipeline fails...". |
| Post 10: "Jenkins needed 40% more code" | **Wrong, and self-contradicting.** The very next line gives 911/664, 1092/869, 1257/649, which are +37%, +26% and +94%. Across all three it is 3260 vs 2182, or +49%. Nothing in the repos yields 40%. Corrected to "26 to 94% more code, depending on the app", which is accurate and sets up the three pairs that follow. |

**Re-verified 2026-08-12, unchanged:** all six line counts exact; Jenkins stage counts 14 / 16 / 21
exact; `FIX #` ids in the Java Jenkinsfile number exactly 12 distinct entries (1 to 10, 12, 13 -
there is no #11), so "twelve fixes" is right.

The same two gating errors had already propagated into the published blog posts and the runbook, and
were corrected in the same pass. **The lesson: a "verified facts" block is only verified on the day
it is written.** Both errors entered by describing one engine and generalising to both.

---

## REDUNDANCY AUDIT

**Phase 3 only:** the Alpine cascade, the Jenkins/GHA line counts and concurrency divergence, the
three-language stage divergence, the tag handoff contract.

**Not repeated from Phase 1:** DebugBox post 2 owns Trivy hard-fail gates and multi-arch matrix
builds. The phrase "hard-fail gates" appears nowhere in Phase 3.

**Not repeated from Phase 2:** SilverStack owns Jenkins, SonarQube and Nexus as *infrastructure*.
Phase 3 uses them as *tools* and never explains what they are.

**Saved for later:** Kustomize overlays and the four deployment targets stay in Phase 4. ArgoCD Image
Updater, matrix dispatch and chart-release stay in Phase 5.
