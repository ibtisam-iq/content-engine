# Blog Companion Index

> **Created:** 2026-07-30
> **Blog repo:** `/Users/ibtisam-iq/gitHub/blog`
> **Live at:** `https://blog.ibtisam-iq.com/<slug>/` (flat slug URLs, no folder in the path)
> **Purpose:** what each blog post covers, which LinkedIn post it supports, and what order to publish in.

---

## THE MODEL

**LinkedIn is discovery. The blog is depth.**

The LinkedIn post earns the click and never carries the full argument. The first comment routes the
reader. The blog post has to be worth reading on its own, by someone who never saw the LinkedIn post.

Which means **the blog post goes live first**, always. A first comment that links to a 404 is worse
than no link.

---

## THE LIVE SET

Updated 2026-08-03 after the **Phase 4 to 6 consolidation review**. Phase 2 gained one post and
Phase 3 gained four in the 2026-07-31 audit. Phases 4 to 6 added 28 in the 2026-08-02 rebuild and
were then cut to **22**.

**Counts, verified against disk on 2026-08-03:**

| | Count |
|---|---|
| Live post files under `docs/posts/` (excluding `.TEMPLATE.md`) | **45** |
| Phases 2 and 3 | 13 |
| Phases 4 to 6 | 22 |
| Phase 1, career and standalone posts not indexed here | 10 |
| Archived under `docs/_archive/` (excluded from the build) | 6 from this review |

!!! warning "What the consolidation changed"
    The 28-post Phase 4 to 6 set was proposed by enumerating unused source material, which is not a
    way to decide how many articles to write. Four posts were archived for having no finding worth
    citing, and two were merged into stronger neighbours. Nothing was deleted.

    **Archived:** `five-persistence-models` (analysed an upstream design, not mine),
    `kubeadm-bootstrap-script` (no failure, no decision; the runbook covers it),
    `helmfile-before-argocd` (an opinion the post itself declined to endorse),
    `elasticsearch-eks-node-capacity` (finding reduced to under-provisioning; its capacity material
    moved into `eks-cluster-addons`).

    **Merged:** `eksctl-vs-terraform-same-cluster` into `terraform-error-cascades`;
    `s3-crr-dual-kms-replication` into `static-hosting-verification-and-teardown`, which was
    retitled *A Site That Loads Proves Almost Nothing*. Each archived file carries a banner naming
    where its material went.

### The three tiers

Every Phase 4 to 6 post now closes with one footer, and which footer it gets is a decision, not a
default:

| Tier | Count | Footer | Earned by |
|---|---|---|---|
| **Spine** | 7 | `Series: <name> (Part N of M)` with prev/next | Being one of the two named series |
| **Companion** | 3 | `Companion to: <series>` | Depending on a spine post for its context |
| **Standalone** | 12 | `Related` | Having a finding someone would cite on its own |

Series labels were **not** manufactured for the unlabeled posts. Most of them are correctly
independent, and a fake series label would be the same accidental structure the review was meant to
remove.

### Renumbering and recategorisation (2026-08-03)

Archiving left gaps in the per-folder numbering, so every folder was renumbered contiguously and
five posts were moved to the category they actually belong to. **Slugs and therefore URLs did not
change** — `post_url_format: "{slug}"` means filenames never appear in a URL — so nothing published
or linked externally breaks.

| Post | Was | Now | Why |
|---|---|---|---|
| MkDocs CI Build Fails | Platform Engineering | **CI/CD & Automation** | It is a GitHub Actions build failure |
| One Chart, a Ladder of Dependencies | Platform Engineering | **Containers & Orchestration** | Helm is named in that category |
| Reading a Helm Chart You Did Not Write | Platform Engineering | **Containers & Orchestration** | Helm templates |
| Four Add-ons Between a Bare EKS Cluster | Platform Engineering | **Containers & Orchestration** | Making a bare Kubernetes cluster functional |
| The Ampersand That Truncated My Database URL | Platform Engineering | **Linux & System Administration** | The finding is shell quoting |

Platform Engineering now holds only what the category means: the four SilverStack playground posts,
`same-artifact-four-compute-models` (an argument about per-layer operational ownership) and the
`ten-silent-failures` capstone (cross-cutting across five projects).

!!! note "Archived files are named `archived-<slug>.md`"
    They previously kept their old numeric prefixes, which meant a live `platform/010-…` and an
    archived `platform-010-…` could both claim the same number after renumbering. The non-numeric
    scheme retires that ambiguity permanently. Folder numbering is now **contiguous 001..N with no
    gaps in every folder**, verified against disk.

**Status legend:** ✅ written · 📦 archived 2026-08-03

| # | Blog post | Slug | Supports | Gating |
|---|---|---|---|---|
| B1 | Your Server Has No Public IP | `cloudflare-tunnel-no-public-ip` | #7 = P2 Post 5 of 6 (Tunnel) | **Yes** |
| B2 | Building an OCI Image That Boots as a microVM | `docker-rootfs-systemd-cicd` | #8 = P2 Post 6 of 6 (Rootfs) | **Yes** |
| B3 | Four Machines, One Playground | `self-hosted-cicd-lab-jenkins-sonarqube-nexus` | #6 = P2 Post 4 of 6 (CI/CD Stack) | No |
| B4 | The Vulnerability Gate That Blocked Every Build | `vulnerability-gate-blocked-every-build` | #9 = P3 Post 1 of 3 (Alpine) | **Yes** |
| B5 | The Same Pipeline on Two CI Engines | `same-pipeline-two-ci-engines` | #10 = P3 Post 2 of 3 (Jenkins vs GHA) | No |
| B6 | One Pipeline Contract, Three Ecosystems | `pipeline-contract-three-ecosystems` | #11 = P3 Post 3 of 3 (Three pipelines) | No |
| B7 | Release Identity | `release-identity-image-tagging` | **none** (blog-only) | n/a |
| B8 | The Machine I Actually Work From | `dev-machine-workstation-image` | **none** (blog-only, P2 series) | n/a |
| B9 | The Version Override Maven Silently Ignored | `maven-bom-cve-overrides` | #9 first comment (supporting) | No |
| B10 | Trivy Could Not Find the Image I Had Just Built | `buildx-load-trivy-image-not-found` | #10 first comment (supporting) | No |
| B11 | Twelve Fixes to a Pipeline That Was Already Passing | `jenkins-pipeline-hardening-fixes` | #10 first comment (supporting) | No |
| B12 | Four Ways to Serve a Frontend, Three of Them Wrong | `frontend-serving-nginx-reverse-proxy` | #11 first comment (supporting) | No |
| B12b | Three Places to Put Provisioning ✅ | `iximiuz-labs-playground-init-tasks-provisioning` | **none** (blog-only, P2 series) | n/a |
| B13 | Two Failures Behind One Load Balancer ✅ | `alb-health-check-https-redirect-loop` | #13 = P4 Post 2 of 4 (ALB) | **Yes** |
| B14 | An ACME Challenge That Could Not Reach Itself ✅ | `cert-manager-gateway-http01-baremetal` | #14 = P4 Post 3 of 4 (ACME) | **Yes** |
| B15 | My Builds Were Reproducible ✅ | `buildkit-epoch-broke-image-updater` | #16 = P5 Post 1 of 3 (BuildKit) | **Yes** |
| B16 | The EKS Module Accepted the Setting ✅ | `terraform-eks-module-silent-drop` | #18 = P5 Post 3 of 3 (Terraform) | **Yes** |
| B17 | Four Compute Models, One Artifact ✅ | `same-artifact-four-compute-models` | #12 = P4 Post 1 of 4 | No |
| B18 | One Chart, a Ladder of Dependencies ✅ | `helmfile-dependency-ladder` | #15 = P4 Post 4 of 4 | No |
| B19 | Push or Pull: Two Ways to Hand Off ✅ | `gitops-push-vs-pull-handoff` | #17 = P5 Post 2 of 3 | No |
| B20 | Zero Compute, and Still a Dozen Decisions ✅ | `cloudfront-oac-dual-kms-static-hosting` | #19 = P6 Post 1 of 3 | No |
| B21 | Gateway API Three Ways ✅ | `gateway-api-three-ways` | #12 and #14 first comments | No |
| ~~B22~~ | ~~Bootstrapping a Cluster with kubeadm~~ 📦 | `kubeadm-bootstrap-script` | **archived** — was never linked from #12 | n/a |
| ~~B23~~ | ~~I Used Helmfile Before ArgoCD on Purpose~~ 📦 | `helmfile-before-argocd` | **archived** — #17 now links `eks-cluster-addons` | n/a |
| B24 | Building Only What Changed ✅ | `monorepo-matrix-dispatch-permissions` | #17 first comment | No |
| B25 | The Monitoring Stack Is the One Thing ArgoCD Does Not Manage ✅ | `observability-outside-gitops` | #17 first comment | No |
| B26 | Ten Things That Failed Silently ✅ | `ten-silent-failures` | #20 = P6 Post 2 of 3 (capstone) | No |
| B27 | A Site That Loads Proves Almost Nothing ✅ | `static-hosting-verification-and-teardown` | #19 first comment (absorbed `s3-crr-dual-kms-replication`) | No |
| B28 | Seventeen Errors, and the Ones Caused by the Fix ✅ | `terraform-error-cascades` | #18 first comment (absorbed `eksctl-vs-terraform-same-cluster`) | No |

"Gating" means the LinkedIn post's first comment leads with that blog link, so the blog must be live
first. The non-gating ones are supporting links; publishing them late costs nothing.

**B9 to B12 and B21 to B25 have no LinkedIn post of their own, by decision.** LinkedIn is the
discovery layer, not a coverage obligation. Each is reachable from an adjacent post's first comment,
from its siblings' series footers, and from search. See "Why 3 posts against 8 blogs" in
`phase3-pipeline-engineering.md` and "What changed from the placeholder plan" in
`phase4-6-deployment-and-gitops.md`.

**Numbering note:** B13 to B16 are written and carry the four gates for Phases 4 and 5. Rows below
B16 are the v1 subset; the authoritative Phase 4 to 6 list is in the phase file.

!!! success "First comments are clean, verified 2026-08-03"
    Checked every `blog.ibtisam-iq.com/<slug>` URL in all plan files against the live slug list:
    **24 referenced, 24 live, 0 dead.** #17's first comment previously pointed at the archived
    `helmfile-before-argocd` and now points at `eks-cluster-addons`. #12 never carried a
    `kubeadm-bootstrap-script` link, so nothing there needed changing.

!!! note "Reachability, stated accurately"
    An earlier version of the phase plan claimed all 28 Phase 4 to 6 blogs were reachable from
    LinkedIn first comments. That was never true. Of the 22 live posts, **13 are reachable from a
    first comment**; the other 9 are reached from series and companion footers, from category pages,
    and from search. That is the intended design, not a gap. LinkedIn is the discovery layer, not a
    coverage obligation.

---

## WHAT EACH ONE COVERS

### B1 — Your Server Has No Public IP: Serving a Custom Domain with TLS Anyway
`docs/posts/networking/001-cloudflare-tunnel-no-public-ip.md` · 1,740 words · Networking & Storage
**URL:** https://blog.ibtisam-iq.com/cloudflare-tunnel-no-public-ip/

The EC2 setup that worked and why. The discovery (`curl ifconfig.me` returning the same address on
four machines). What NAT does in a Firecracker/bridge/namespace model. Five approaches that fail,
with the misleading Certbot error. The direction reversal. Tunnel setup with token handling. Why the
tunnel targets Nginx rather than the service port, including the WebSocket `map` block. One tunnel
per service. The security posture compared against the EC2 original.

**Merged from two earlier posts.** The old `001-nat-problem-self-hosted-lab.md` is now in
`docs/_archive/` and its URL is retired.

**Relationship to the LinkedIn post:** the post gives the reversal in six lines. The blog gives the
origin story, the full failure table, and the reasoning behind every configuration choice.

### B2 — Building an OCI Image That Boots as a microVM, Not a Container
`docs/posts/containers/003-docker-rootfs-systemd-cicd.md` · 2,165 words · Containers & Orchestration
**URL:** https://blog.ibtisam-iq.com/docker-rootfs-systemd-cicd/

The delivery model. Four things the build deliberately removes (host keys, machine IDs,
`/.dockerenv`, `CMD`) with the reasoning for each. The `USER` asymmetry and the two-context table.
What cannot be baked in. Why the platform's `initTasks` feature cannot replace the systemd oneshot.
SonarQube's runtime database provisioning including the `CREATE DATABASE` limitation. Build-time
healthchecks that assert host keys are *absent*. The `COPY` versus bind-mount `rm -rf /tmp/*`
constraint. The welcome-file ordering trap. The six-image inheritance chain.

**Expanded from 933 words.**

**Relationship:** the post lists four anti-container steps. The blog explains each one plus
everything the post had no room for.

### B3 — Four Machines, One Playground: Composing a CI/CD Stack That Boots Ready
`docs/posts/platform/001-silverstack-cicd-lab.md` · 1,517 words · Platform Engineering
**URL:** https://blog.ibtisam-iq.com/self-hosted-cicd-lab-jenkins-sonarqube-nexus/

Why the jump host is not the workstation (with the full minimal Dockerfile). Allocating a fixed
10 vCPU / 16 GiB / 150 GiB budget and the reasoning per machine. Sizing the JVM heaps to match, and
why the Elasticsearch min must equal max. Tabs as part of the manifest. Intra-stack hostname
networking. The one manual step (tunnel token) and why it stays manual. How the images get built.

**Rewritten from 685 words.** Corrects a factual error in the old version, which claimed every
workflow builds multi-arch. Only the base image does.

**Relationship:** the post is a use case ("somewhere to practise a real pipeline"). The blog is the
composition and capacity engineering behind it.

### B4 — The Vulnerability Gate That Blocked Every Build
`docs/posts/security/001-vulnerability-gate-blocked-every-build.md` · 1,783 words · Security & Compliance
**URL:** https://blog.ibtisam-iq.com/vulnerability-gate-blocked-every-build/

The starting configuration. Failure one: a gate with no reachable passing state, with real Trivy
output. Three wrong fixes and why each removes the mechanism while keeping the badge. The redesign
split by fix ownership, with all three Trivy passes. The jammy migration and its honest cost. Failure
two: seven real BOM CVEs the redesign exposed. Failure three: the `java:S5738` quality gate failure.
The gate divergence table, now split Jenkins versus GitHub Actions per language. The principle.

**Corrected 2026-07-31.** The old divergence table claimed the FS gate fails for Node only (true of
GHA, false of Jenkins) and that the Java library gate blocks (false on both engines). Now carries the
per-engine table plus the inherited-code reasoning for why Java GHA reports rather than blocks.

**Relationship:** the post compresses the cascade to one line per link. The blog is the whole chain
with the evidence.

### B5 — The Same Pipeline on Two CI Engines: Jenkins and GitHub Actions
`docs/posts/cicd/003-same-pipeline-two-ci-engines.md` · 1,457 words · CI/CD & Automation
**URL:** https://blog.ibtisam-iq.com/same-pipeline-two-ci-engines/

The line-count table. Plugins as invisible dependencies, with the `No such DSL method` failure and
why every Jenkinsfile opens with a plugin comment block. Secret handling and why `printf '%s'` rather
than `echo`. Artifacts as a straightforward GitHub Actions win. Concurrency, and the half-written
release. Why the Node gap is 94% rather than 40%. What ported without friction.

**Gained a fifth difference 2026-07-31:** the gates drifted between the two implementations and only
a side-by-side read caught it. Jenkins blocks on a critical FS finding in all three repos; GHA does
so only for Node. Closes on the general lesson that single-token policy values (exit codes, severity
thresholds, timeouts) are what silently diverge, not stage names or tool versions.

**Relationship:** the post is one number and one argument. The blog is all six dimensions.

### B6 — One Pipeline Contract, Three Language Ecosystems
`docs/posts/cicd/004-pipeline-contract-three-ecosystems.md` · 1,708 words · CI/CD & Automation
**URL:** https://blog.ibtisam-iq.com/pipeline-contract-three-ecosystems/

**Corrected 2026-07-31.** The security tooling table claimed Java runs a three-pass image scan; the
Java Jenkinsfile runs two with no `--vuln-type` split and blocks on any critical. The "one genuine
gate difference" paragraph claimed Node alone fails the FS scan, which is true of GHA only.

The contract stated as one sentence. What the stage counts mean. Java (the build tool absorbs the
work). Python (the pipeline builds the environment). Node (everything doubles). The security tooling
divergence table and the one genuine gate difference. Versioning from three sources. The attempt at
uniformity and why it failed. Portability versus uniformity.

**Relationship:** the post says the stages that differed had to. The blog says exactly which, and why.

### B7 — Release Identity: What a Build Is Called and What Is Allowed to Ship
`docs/posts/cicd/002-release-identity-image-tagging.md` · 1,756 words · CI/CD & Automation
**URL:** https://blog.ibtisam-iq.com/release-identity-image-tagging/

**Blog-only. No LinkedIn post.** Cut deliberately: the argument is a dependency chain (two tags,
three version sources, an atomic handoff, a race condition) and chains do not survive feed reading.

Two tags with different jobs and why publishing `latest` is fine. Three version sources including
Python's hard failure on a missing `VERSION`. The five-field handoff and the two-step
token-out-of-argv clone. The four-condition monorepo test. The mismatched client/server pair.
Multi-registry publishing. Concurrency and the half-written release.

**Linked from:** #11's first comment (P3 Post 3 of 3), as the deep reference for the mismatched-pair
detail mentioned there.

### B8 — The Machine I Actually Work From
`docs/posts/containers/006-dev-machine-workstation-image.md` · 1,248 words · Containers & Orchestration
**URL:** https://blog.ibtisam-iq.com/dev-machine-workstation-image/

**Blog-only. Part 3 of 6 in the SilverStack series.** The workstation image with 40-plus tools, and
why it is a different image from the jump host that shares its node name. The 35-phase install
script. Aliases wired to real tab completion rather than bare shortcuts. The `cloudflared` inclusion
dictated by NAT rather than by preference. The `USER $USER` reasoning quoted from the image's own
README. `docker.service` enabled at build and started at boot as one more bake-versus-boot instance.

Added 2026-07-31 to close a coverage gap: the Dev Machine had a LinkedIn post and a runbook page but
no blog post, while every sibling image had one.

### B9 — The Version Override Maven Silently Ignored
`docs/posts/security/002-maven-bom-cve-overrides.md` · 1,654 words · Security & Compliance
**URL:** https://blog.ibtisam-iq.com/maven-bom-cve-overrides/

The direct sequel to B4. `<properties>` versus `<dependencyManagement>`, and why the first works by
cooperation with the BOM and fails silently when the BOM exposes no key. The Thymeleaf case. How to
check which mechanism you need before guessing (`help:effective-pom`, `help:evaluate`, scoped
`dependency:tree`). The full 8-row CVE table. Why `spring-security-web` needed a minor-version move
because the fix was never backported to 6.4.x. Why transitive CVEs dominate the list.

**Relationship:** B4 says the gate caught 7 real CVEs. B9 is what clearing them actually took.

### B10 — Trivy Could Not Find the Image I Had Just Built
`docs/posts/cicd/005-buildx-load-trivy-image-not-found.md` · 1,538 words · CI/CD & Automation
**URL:** https://blog.ibtisam-iq.com/buildx-load-trivy-image-not-found/

BuildKit's store is not the Docker daemon. The four backends Trivy tried and why each failed
differently. Why a scan that cannot resolve its target is worse than one that finds CVEs, and how the
outcome depends entirely on `exit-code`. The three options once a second architecture enters, none of
them clean. The `if: always()` guard that deliberately does not appear on the gating pass.

**Relationship:** supporting depth for #10. Stands alone as a debugging story.

### B11 — Twelve Fixes to a Pipeline That Was Already Passing
`docs/posts/cicd/006-jenkins-pipeline-hardening-fixes.md` · 1,667 words · CI/CD & Automation
**URL:** https://blog.ibtisam-iq.com/jenkins-pipeline-hardening-fixes/

The numbered `FIX` comments, grouped into four kinds of lie: Groovy parse-time versus shell runtime
interpolation rendering `null` as a deployable tag; `|| echo` swallowing merge conflicts; reports
measuring infrastructure failures as coverage regressions; and four time bombs that are correct when
written and wrong later. Closes on why the reasoning lives in the file rather than a commit message.

**Relationship:** supporting depth for #10, from the Jenkins side.

### B12 — Four Ways to Serve a Frontend, Three of Them Wrong
`docs/posts/networking/002-frontend-serving-nginx-reverse-proxy.md` · 1,466 words · Networking & Storage
**URL:** https://blog.ibtisam-iq.com/frontend-serving-nginx-reverse-proxy/

What removing one `express.static()` line actually cost. Express-serves-static rejected on
architecture, webpack-dev-server on being a dev tool, `python3 -m http.server` on having no proxy.
Nginx with `proxy_pass` and the SPA `try_files` fallback. Two failures underneath a correct config:
`sites-enabled/default` silently shadowing `conf.d/`, and `www-data` needing `o+x` on the path plus
`o+r` on the files. Two configs rather than one templated file, and why `localhost` inside the Nginx
container is the Nginx container. The client image's missing `USER` and why that is correct.

**Relationship:** explains why the Node app in #11 ships two images at all.

---

## PHASES 4 TO 6 (added 2026-08-02)

### B13 — Two Failures Behind One Load Balancer, and Why Both Components Were Right ✅
`docs/posts/networking/003-alb-health-check-https-redirect-loop.md` · 1,540 words · Networking & Storage
**URL:** https://blog.ibtisam-iq.com/alb-health-check-https-redirect-loop/

A health check returning 302 because Spring Security caught it, and the ASG replacement loop that
follows from a correct response to bad input. Then the second failure the first one was hiding: TLS
terminating at the load balancer, an `http://` post-login redirect, a cookie without `Secure`, and a
cookie without `SameSite`, all producing the identical symptom. Why fixing one of the three looks like
no progress. Sticky sessions named honestly as a workaround for having no shared session store.

**Relationship:** the post gives two symptoms and two causes. The blog gives the diagnosis order,
which is the transferable part.

### B14 — My Builds Were Reproducible, So My Deployments Stopped ✅
`docs/posts/cicd/007-buildkit-epoch-broke-image-updater.md` · 1,441 words · CI/CD & Automation
**URL:** https://blog.ibtisam-iq.com/buildkit-epoch-broke-image-updater/

`images_considered=10 images_updated=0` with zero errors. The `allowTags` value that is ignored rather
than rejected without a `regexp:` prefix. BuildKit zeroing the image `created` timestamp on purpose,
and why that is correct rather than a bug. The two failures inside the digest-strategy fix. Why the
manifest says `latest` while the pod runs a digest, and why that still satisfies the rule from B7.

**Relationship:** the post is one surprising claim. The blog is the full three-strategy chain.

### B15 — The EKS Module Accepted the Setting and Never Sent It ✅
`docs/posts/iac/001-terraform-eks-module-silent-drop.md` · 1,440 words · Infrastructure & IaC
**URL:** https://blog.ibtisam-iq.com/terraform-eks-module-silent-drop/

`terraform-aws-modules/eks/aws` v21 dropping `bootstrap_cluster_creator_admin_permissions` when
`create_iam_role = false`, confirmed against `describe-cluster` rather than against the plan. The six
confirmed organisation policy denials with their workarounds. The IAM policy simulator output that
turns "it did not work" into "it is not permitted". CoreDNS hanging on a node that does not exist yet.
Destroy as part of the configuration rather than an afterthought.

**Relationship:** the post names one defect. The blog documents seventeen failures around it.

### B16 to B25 — all written; paths and categories verified against disk 2026-08-03

| # | Title | Path | Category | Core content |
|---|---|---|---|---|
| B16 | Four Compute Models, One Artifact | `platform/005-same-artifact-four-compute-models.md` | Platform Engineering | What each layer forces you to own. The Kustomize base/overlay split. Why `storageClassName` is absent from the base. **Must say Deployment, not StatefulSet** |
| B17 | One Chart, a Ladder of Dependencies | `containers/007-helmfile-dependency-ladder.md` | Containers & Orchestration | The `orders` 01 to 06 ladder, ~25 overlays, the `needs:` DAG, the UI endpoints overlay, IRSA and the SQS to Lambda to SNS top rung |
| B18 | Push or Pull: Two Ways to Hand Off a Deployment | `cicd/008-gitops-push-vs-pull-handoff.md` | CI/CD & Automation | The three iterations from `ci.md`, the chart-version exception, why two writers to one field is a race |
| B19 | Zero Compute, and Still a Dozen Decisions | `cloud/001-cloudfront-oac-dual-kms-static-hosting.md` | Cloud Platforms | OAC with SigV4 over legacy OAI, dual-region KMS, Bucket Keys and the bill, the 403-to-index.html SPA mapping |
| B21 | Ingress and Gateway API, End to End | `networking/007-gateway-api-three-ways.md` | Networking & Storage | Nginx Gateway Fabric on bare metal, AWS LBC on EKS, ALB Ingress Group on retail. The HTTPRoute OutOfSync drift from injected defaults |
| ~~B22~~ | ~~Bootstrapping a Cluster with kubeadm~~ | 📦 `_archive/archived-kubeadm-bootstrap-script.md` | n/a | **Archived 2026-08-03.** No failure and no decision to argue about; the runbook covers the script properly |
| ~~B23~~ | ~~Why Helmfile Before ArgoCD~~ | 📦 `_archive/archived-helmfile-before-argocd.md` | n/a | **Archived 2026-08-03.** An opinion the post itself declined to endorse |
| B24 | Matrix Dispatch and the Permissions Ceiling | `cicd/009-monorepo-matrix-dispatch.md` | CI/CD & Automation | `github.event.before` edge cases, `fail-fast: false` blast radius, reusable workflows narrowing but never escalating permissions, the cartservice context override |
| B25 | Observability Deployed Outside GitOps | `observability/001-observability-outside-gitops.md` | Observability & Reliability | Monitoring installed by Helm not ArgoCD, so Prometheus survives to debug ArgoCD. The node capacity bug that surfaced it |

---

## PUBLISH ORDER

Blog posts first, in this order. Then LinkedIn on its own cadence.

### Before Phase 2 starts

Nothing. Posts 3, 4 and 5 (Launch, Platform, Dev Machine) have no blog dependency.

### Before #6 (P2 Post 4 of 6)

- **B3** Four Machines, One Playground — non-gating, but it is the natural companion, so publish it if ready.

### Before #7 (P2 Post 5 of 6) — REQUIRED

- **B1** Your Server Has No Public IP

### Before #8 (P2 Post 6 of 6) — REQUIRED

- **B2** Building an OCI Image That Boots as a microVM

### Before #9 (P3 Post 1 of 3) — REQUIRED

- **B4** The Vulnerability Gate That Blocked Every Build

### Before #10 and #11 (P3 Posts 2 and 3 of 3)

- **B5** The Same Pipeline on Two CI Engines
- **B6** One Pipeline Contract, Three Ecosystems
- **B7** Release Identity

### No gating dependency (publish whenever)

- **B8** The Machine I Actually Work From — blog-only, P2 series
- **B9** The Version Override Maven Silently Ignored — supporting link in #9
- **B10** Trivy Could Not Find the Image I Had Just Built — supporting link in #10
- **B11** Twelve Fixes to a Pipeline That Was Already Passing — supporting link in #10
- **B12** Four Ways to Serve a Frontend, Three of Them Wrong — supporting link in #11

These appear in first comments rather than post bodies, so a late publish costs a dead link in one
comment rather than a broken post. Still worth publishing with their series, because each one sits in
a numbered chain whose prev/next links break if it is missing.

### Before #13 (P4 Post 2 of 3) — REQUIRED

- **B13** Two Failures Behind One Load Balancer ✅ written

### Before #15 (P5 Post 1 of 3) — REQUIRED

- **B14** My Builds Were Reproducible ✅ written

### Before #17 (P5 Post 3 of 3) — REQUIRED

- **B15** The EKS Module Accepted the Setting ✅ written
- ~~Scrub captured AWS identifiers from the retail runbook first.~~ **Done 2026-08-02**: replaced
  with placeholders across the retail and microservices runbooks, with an explanatory note in each.

### Before #16 (P5 Post 2 of 3)

- **B22** Why Helmfile Before ArgoCD. Non-gating, but #16's first comment links it directly,
  so publish it with B18 or drop that line from the comment.

---

## SERIES INTEGRITY

Four series now carry prev/next footers spanning their full length:

| Series | Parts | Complete? |
|---|---|---|
| Building a Self-Hosted CI/CD Stack from Scratch | 1 to 6 | ✅ all written |
| CI Pipeline Engineering Across Three Applications | 1 to 8 | ✅ all written |
| One Application, Four Ways | 1 to 3 | ⚠️ only Part 2 written |
| Ten Services, No Hands | 1 to 3 | ⚠️ Parts 1 and 3 written, Part 2 missing |

!!! success "Both series are now internally complete (2026-08-02)"
    All seven Phase 4 and Phase 5 blogs exist and every internal link between them resolves,
    verified by walking each `](...md)` target against the filesystem. `mkdocs build --strict`
    was **not** run: the `autorefs` plugin is not installed in the environment where these were
    written, so the build aborts on config before reaching link validation. Run it before deploying.

    This is the publish-whole-series rule doing its job rather than a mistake in the footers: the
    footers are correct for the finished state. **Do not deploy Phase 4 or Phase 5 until B16, B17 and
    B18 exist.** The alternative, trimming the footers now and restoring them later, produces posts
    that are live and wrong in between.

### Simplest approach

Publish all twenty three at once, after the remaining nine are written. They stand alone and it
removes every timing dependency from the LinkedIn schedule. The only cost is that the blog gains
twenty three posts in one day, which matters to nobody.

If that is too long to wait, the safe partial is **the two complete series only** (B1 to B12), which
covers LinkedIn posts 3 through 11 and leaves Phases 4 to 6 entirely unpublished until their blogs
are finished.

---

## HOUSEKEEPING

**Deploy check.** Run `mkdocs build --strict` before deploying. The repo already has
`validation.unrecognized_links: warn`; strict mode turns those warnings into build failures, so a
broken internal link cannot ship.

**Internal link rule (CHANGED 2026-08-02).** Link to another post by **relative `.md` path**,
not by slug. `mkdocs.yml` sets `validation.absolute_links: relative_to_docs`, which means an
absolute link like `/some-slug/` resolves to `docs/some-slug/` and does not exist. Use
`004-other-post.md` within a folder and `../networking/001-other-post.md` across folders.

The previous rule on this line said the opposite (`/<slug>/` only) and was correct under the older
config. Five posts written on 2026-08-02 followed the stale rule and were converted. If you are
writing a post, copy the link style from a neighbouring post rather than from memory.

**Retired URL.** `/nat-problem-self-hosted-lab/` no longer exists. Its content is in B1.
