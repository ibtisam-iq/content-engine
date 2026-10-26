# LinkedIn Content Publishing Plan
## Muhammad Ibtisam Iqbal — DevOps & Cloud Engineer

> **Created:** 2026-07-05 · **Last revised:** 2026-08-02
> **Status:** All phases reworked in detail. Every series entry below is superseded.
> **Scope:** 21 LinkedIn posts + 3 iximiuz platform articles + 40 companion blog posts
> **Companion:** `linkedin-publishing-plan-overview.html` (visual overview, open in browser)
>
> **Detailed phase files supersede the series entries below:**
> - Phase 2 → `silverstack-final-posts.md` (6 posts, final copy)
> - Phase 3 → `phase3-pipeline-engineering.md` (3 posts, final copy)
> - Phases 4 to 6 → `phase4-6-deployment-and-gitops.md` (10 posts, final copy, v2)
>
> **2026-08-02 rebuild.** Phases 4 to 6 were reworked against the source repos in one pass so
> redundancy could be judged across all remaining material at once. The LinkedIn count for those
> phases dropped from 13 to 8: two Polyglot posts collided with Phase 3, the EKS overview was pure
> inventory, four topics were demoted to blog-only, and the K8s DNS post was cut because no source
> material for it exists. Eleven blog posts were added. Series 4 to 8 and the Standalone block below
> are kept for history only and contain claims the audit found false; see the Conflict Audit in
> `phase4-6-deployment-and-gitops.md`.

---

## I. CONTENT ARCHITECTURE

### Total Content Units

| Category | Source | Post Count |
|----------|--------|------------|
| DebugBox (open source) | 1 project | 2 posts |
| SilverStack CI/CD Platform | 1 project + 5 runbooks + 4 blog drafts | **6 posts** |
| CI Pipeline Engineering (3 apps, 2 CI engines) | 3 repos + 3 runbooks | **3 posts** |
| Polyglot Monolith Deployment | 1 project | 2 posts |
| BankApp: Three Compute Models | 1 project | 1 post |
| Retail Store Multi-Environment | 1 project | 2 posts |
| Microservices GitOps on EKS | 1 project (crown jewel) | 4 posts |
| AWS Secure Static Hosting | 1 project | 1 post |
| Standalone: kubeadm bootstrap | runbook | 1 post |
| Standalone: K8s DNS debugging | blog draft | 1 post |
| Methodology: "How I Work" | projects site | 1 post |
| **TOTAL** | | **24 posts** |

### iximiuz Platform Cross-Publishing (separate track)

| Article | Source |
|---------|--------|
| Exposing NAT-behind labs via Cloudflare Tunnel | runbook + blog draft |
| Building custom OCI rootfs images for iximiuz playgrounds | runbook (5 rootfs guides) |
| Running Jenkins + SonarQube + Nexus on iximiuz microVMs | runbook (CI/CD stack operations) |

---

## II. SERIES MAP

### Series 1: DebugBox — Open Source Kubernetes Diagnostics (2 posts)

**Why start here:** Open source is the most shareable content type on LinkedIn. Anyone can pull the image and try it. It's a clean, self-contained project that doesn't require backstory.

**Post 1.1 — "I built a Kubernetes debugging toolkit. 93% smaller than netshoot."**

Content:
- What DebugBox is and why it exists (netshoot is 202MB for a DNS check)
- The 3 variant strategy: Lite (15MB), Balanced (47MB), Power (91MB)
- One-liner usage: `kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox`
- Published to GHCR and Docker Hub, multi-arch (amd64 + arm64)
- MIT licensed, open for contributions

Assets to link: GitHub repo, docs site, GHCR package page
Image: Side-by-side size comparison graphic (DebugBox variants vs netshoot)

**Post 1.2 — "How I built a multi-arch container CI pipeline with hard-fail security gates"**

Content:
- CI pipeline design: GitHub Actions with Docker Buildx + QEMU
- 8 matrix jobs (2 architectures x 4 variants)
- Smoke tests run inside the built containers during CI (not after push)
- Trivy scanning with HIGH/CRITICAL hard-fail gates
- Hadolint linting on all Dockerfiles
- OCI metadata labels injected at build time
- Local quality loop via Makefile: lint -> build -> test -> scan
- Key decision: separating Dockerfiles (declarative) from installation scripts (procedural)

Assets to link: CI workflow file on GitHub, Makefile, docs site
Image: CI pipeline diagram or GitHub Actions run screenshot

---

### Series 2: SilverStack — Self-Hosted CI/CD on MicroVMs (6 posts)

> **SUPERSEDED.** Final copy lives in `silverstack-final-posts.md`. The four entries below are the
> original draft, kept for history. The shipped order is: Launch, Platform, Dev Machine, CI/CD Stack,
> Tunnel, Rootfs.

**Why second:** This is the platform foundation. The DevSecOps CI Pipelines use SilverStack's Nexus and SonarQube. The iximiuz connection adds external validation. The NAT/Cloudflare story is a compelling debugging narrative.

**Prerequisite:** Before this series, retroactively engage with the iximiuz founder's LinkedIn post (comment + repost). This seeds the connection before the series begins.

**Post 2.1 — "I built a self-hosted CI/CD platform on microVMs. Here is the full stack."**

Content:
- What was built: Jenkins + SonarQube + Nexus on iximiuz Labs microVMs
- Why: no public cloud bill, full control, reproducible from OCI images
- 5 custom OCI rootfs images (Ubuntu 24.04 base, systemd as PID 1)
- Each image is a complete server: packages, service configs, Nginx, TLS
- All 5 published as iximiuz Labs playgrounds (anyone can launch them)
- GitHub Actions CI runs a build-time health check per service image: nginx -t parses the real config, systemd units are verified by their multi-user.target.wants symlink, before push to GHCR

Assets to link: GitHub repo (silver-stack), iximiuz author page, playground URLs
Image: Architecture diagram of the 5-server stack, or iximiuz playground screenshot

**Post 2.2 — "My CI/CD servers had no public IP. Here is how I solved it."**

Content:
- The NAT/CGNAT discovery: iximiuz microVMs sit behind carrier-grade NAT
- Why this matters: no inbound connections possible, no port forwarding
- The debugging process: how the NAT layer was identified
- The solution: outbound-only Cloudflare Tunnels on custom domains
- Each server gets its own subdomain: jenkins.example.com, sonar.example.com, nexus.example.com
- Nginx reverse proxy on port 80 with security headers behind the tunnel
- The iximiuz founder saw this, asked how it was done, and suggested writing about it publicly

Assets to link: Runbook (NAT section), blog draft (NAT problem), blog draft (Cloudflare Tunnel)
Image: Before/after network diagram showing the NAT problem and tunnel solution

**Post 2.3 — "Building immutable server images with systemd as PID 1"**

Content:
- Why custom rootfs images instead of manual VM setup (immutability, reproducibility)
- Architecture: Ubuntu 24.04 base image with systemd, then 4 service-specific child images
- Each image: packages pinned with SHA256 verification, dedicated daemon users, sudoers profiles
- Jenkins image: Java runtime, Jenkins WAR, systemd service unit, Nginx config
- SonarQube image: Java + PostgreSQL + SonarQube, tuned kernel parameters (vm.max_map_count)
- Build pipeline: GitHub Actions validates configs before pushing to GHCR
- Key insight: ephemeral microVM filesystems force you to think about what needs to persist vs what gets rebuilt

Assets to link: Runbook (rootfs guides), GitHub (silver-stack/iximiuz/rootfs)
Image: Dockerfile structure showing base -> child image hierarchy

**Post 2.4 — "Security decisions in a self-hosted CI/CD stack"**

Content:
- No shared users: each service runs under its own daemon account
- sudoers profiles: only the specific commands each service needs
- Ephemeral SSH keys: generated per session, not baked into images
- All binary downloads verified with SHA256 checksums before installation
- Nginx security headers: HSTS, X-Content-Type-Options, X-Frame-Options
- Cloudflare Tunnel means zero exposed ports (no inbound firewall rules at all)
- Why this matters even for lab environments: building security habits into muscle memory

Assets to link: Runbook (CI/CD stack operations), GitHub
Image: Security architecture diagram or Nginx config snippet screenshot

---

### Series 3: Pipeline Engineering (3 posts)

> **SUPERSEDED.** Final copy lives in `phase3-pipeline-engineering.md`. The two entries below are the
> original draft and contain three factual errors against the source (stage count, "identically", and
> the claim that latest is never pushed). Kept for history only. Shipped order: Alpine cascade,
> Jenkins vs GitHub Actions, Three languages, Release identity.

**Why third:** This directly builds on SilverStack (the pipelines publish to SilverStack's Nexus and run SonarQube quality gates on SilverStack's SonarQube). The audience now understands the platform these pipelines run on.

**Post 3.1 — "I built one CI pipeline contract and implemented it twice, on Jenkins and GitHub Actions"**

Content:
- The design goal: prove the pipeline design is tool-agnostic
- One contract, three codebases (Java Spring Boot, Python Flask, Node.js Express), landing at 14, 16, and 21 stages because the ecosystems differ
- Each codebase validated locally first (Maven, Webpack, pytest with real databases) before automating
- Language-specific SAST: Bandit + pip-audit for Python, npm audit + ESLint for Node.js, Trivy filesystem for Java
- SonarQube quality gates with JaCoCo and Cobertura coverage reports
- Every image tagged with semantic version + 7-char Git SHA + CI build number (no floating "latest")
- Strict GitOps handoff: image SHA committed to CD repo. No pipeline has kubectl access.

Assets to link: All 3 app repos (Java, Python, Node.js), runbook
Image: Pipeline stage diagram showing the three stage counts side by side, or side-by-side Jenkins vs GitHub Actions screenshot

**Post 3.2 — "A 3-pass Trivy scanning strategy and why 'latest' is a deployment antipattern"**

Content:
- The 3-pass Trivy approach:
  1. Filesystem scan on source code
  2. Container scan with `--vuln-type library`: hard-fail on CRITICAL
  3. Container scan with `--vuln-type os`: advisory-only (OS CVEs are upstream's responsibility)
- Why this split: blocking a release over an unpatched Alpine CVE that has no fix yet is waste
- Triple-registry publishing: GHCR + Docker Hub + self-hosted Nexus (on SilverStack)
- Why triple: GHCR for GitHub ecosystem, Docker Hub for discoverability, Nexus for airgapped/internal pulls
- Tagging strategy: semver + SHA + build number. Never "latest". Every deployed image is traceable to its exact commit.

Assets to link: CI workflow files, runbook (pipeline operations)
Image: Trivy scan output screenshot, or tag strategy diagram

---

### Series 4: Polyglot Monolith Deployment (2 posts)

**Post 4.1 — "Same 3 applications, 4 different environments. Same Kustomize base."**

Content:
- The challenge: deploy Java, Python, and Node.js monoliths identically on EC2, ECS, bare-metal K8s, and EKS
- Containerization decisions: multi-stage Dockerfiles for each stack
- Node.js refactored from 2-tier to 3-tier (Nginx serves React, proxies API to Express)
- Database connectivity: localhost for bare-metal, Docker Compose DNS for local, RDS endpoints for cloud. No source code changes.
- Kustomize overlay structure: 80% shared base manifests, environment-specific overlays inject StatefulSets, StorageClasses, RDS endpoints
- Python Flask kept as single-container with Gunicorn (pattern matched the application, not the trend)

Assets to link: All 3 app repos, CD repo (platform-engineering-systems), runbook
Image: Matrix diagram (3 apps x 4 environments) or Kustomize overlay structure

**Post 4.2 — "Debugging environment-specific edge cases across 4 deployment targets"**

Content:
- python-dotenv URL truncation: how a local .env library silently broke database URLs in containers
- PostgreSQL 15+ schema grants: default permissions changed between versions, causing silent access failures
- JDBC URL quoting in shell: shell metacharacters in database passwords broke connectivity when passed as environment variables
- Node.js health endpoint: container readiness probes failing because the health route was on the Express backend but the Nginx frontend served the probe path
- The lesson: local development hides problems that surface only in containers or cloud environments. Always validate the full path.

Assets to link: Runbook (specific debugging sections)
Image: Terminal output showing the error and fix, or before/after comparison

---

### Series 5: BankApp — Three Compute Models (1 post)

**Post 5.1 — "I deployed the same Java artifact on EC2, ECS Fargate, and EKS. Here is what I learned about each."**

Content:
- Same Spring Boot 3.4/Java 21 banking app, same immutable artifact, 3 compute layers
- All share one VPC, same security groups, same RDS instance. Only the compute model changes.
- EC2 Auto Scaling: manual AMI + user-data, most control, most operational overhead
- ECS Fargate: serverless containers, no node management, but limited customization
- EKS: full Kubernetes, Gateway API with ALB, most flexible but most complex
- Multi-stage Docker build reduced image by 60% (Maven build stage -> Java 21 slim runtime)
- JVM memory alignment: `-Xmx`/`-Xms` set relative to Kubernetes resource limits to prevent OOM kills
- Key takeaway: the right compute model depends on operational maturity and team size, not feature count

Assets to link: App repo, CD repo, runbook
Image: Architecture comparison diagram (3 compute models side by side)

---

### Series 6: Retail Store — Multi-Environment Deployment (2 posts)

**Post 6.1 — "Deploying 5 microservices on bare-metal Kubernetes and Amazon EKS from the same Helm charts"**

Content:
- AWS retail store demo: 5 microservices with cloud dependencies (DynamoDB, SQS, ElastiCache)
- Challenge: make it run identically on bare-metal kubeadm cluster (no AWS services)
- Solution: custom `values-*.yaml` overrides swapping DynamoDB -> in-cluster state, SQS -> RabbitMQ, ElastiCache -> Redis
- All 5 upstream Helm charts stayed unmodified (overrides only, no chart forks)
- Helmfile with `needs:` directive for dependency sequencing (database before app, app before frontend)
- 3 target-specific Helmfile configurations: bare-metal, EKS-minimal, EKS-full

Assets to link: GitHub repo, runbook, terminal sessions
Image: Side-by-side of bare-metal vs EKS architecture, or Helmfile dependency graph

**Post 6.2 — "IRSA, serverless event pipelines, and why I used CloudFormation worker nodes instead of eksctl"**

Content:
- EKS setup: eksctl for control plane, CloudFormation for self-managed worker nodes (SCPs blocked managed node groups)
- IRSA (IAM Roles for Service Accounts): Cart service -> DynamoDB, Orders service -> SQS
- Serverless event pipeline: SQS -> Lambda -> SNS for order notifications
- ALB Ingress Controller with Ingress Group sharing a single ALB across UI, Prometheus, and Grafana
- Fluent Bit streaming to CloudWatch Container Insights
- Key decision: when platform constraints (SCPs) force workarounds, document the constraint and the workaround, not just the solution

Assets to link: Runbook, terminal sessions, screenshots
Image: Serverless event pipeline diagram, or CloudFormation stack screenshot

---

### Series 7: Microservices GitOps on Amazon EKS — Crown Jewel (4 posts)

**Why last among project series:** This is the most complex project, touching every layer: IaC, CI, GitOps, networking, observability. By this point, the audience has seen the building blocks (SilverStack, pipelines, Helm, Kustomize, EKS). This project ties them all together.

**Post 7.1 — "10 microservices on EKS with fully automated GitOps. Here is the full stack."**

Content:
- Google's Online Boutique: 10 microservices, deployed from scratch on Amazon EKS
- Full stack overview: Terraform -> GitHub Actions CI -> GHCR -> ArgoCD -> EKS
- Modular Terraform: VPCs, bastion, EKS cluster with self-managed ASGs
- 3 GitHub Actions CI pipelines with dynamic matrix dispatch (build only changed services)
- ArgoCD Image Updater detects SHA-256 digests, triggers automated rollouts
- Gateway API with shared ALB across 5 HTTPRoutes
- ExternalDNS auto-creates Route 53 records
- Prometheus + AlertManager -> Slack, Elastic Stack for logging
- This post is the overview. Following posts cover specific layers in depth.

Assets to link: App repo, CD repo, runbook, terminal sessions, screenshots
Image: Full architecture diagram showing all layers

**Post 7.2 — "Terraform on a restricted AWS account: working around SCPs with self-managed ASGs"**

Content:
- The constraint: AWS Organization SCPs blocked `CreateNodegroup` (managed node groups)
- The debugging: Terraform apply succeeded for the cluster but failed silently for node groups
- The solution: self-managed Auto Scaling Groups with custom launch templates
- Modular Terraform structure: separate modules for VPC, bastion, EKS, node groups
- Bastion host pattern: SSH tunnel through bastion to reach private EKS API endpoint
- State management and Terraform workspace organization
- Key learning: enterprise AWS accounts have constraints that sandbox accounts don't. Always check SCPs before choosing your EKS node strategy.

Assets to link: Terraform modules in repo, runbook (AWS infrastructure section)
Image: Terraform resource graph or VPC architecture diagram

**Post 7.3 — "Dynamic CI matrix dispatch: building only the microservices that changed"**

Content:
- Problem: 10 microservices, but most commits touch only 1-2 services. Don't rebuild all 10.
- Solution: GitHub Actions workflow that detects which service directories changed, dynamically generates a build matrix
- Each matrix job: compile, run tests, Trivy filesystem scan, Trivy container scan, push to GHCR
- Helm charts packaged as OCI artifacts and pushed to GHCR alongside container images
- GitOps handoff: CI writes the new image SHA to the CD repo. No CI job ever touches kubectl.
- ArgoCD Image Updater polls GHCR, detects new SHA-256 digests, and updates the running deployment
- End-to-end: developer pushes code -> only affected service is built -> image lands in GHCR -> ArgoCD updates EKS -> zero manual steps

Assets to link: CI workflow files, CD repo with ArgoCD configs
Image: CI pipeline flow diagram, or GitHub Actions matrix job screenshot

**Post 7.4 — "Gateway API, ExternalDNS, and observability on EKS"**

Content:
- Gateway API (not Ingress): shared ALB across 5 HTTPRoutes for different services
- AWS Load Balancer Controller provisions ALBs from Gateway resources
- ExternalDNS auto-creates Route 53 A records when HTTPRoutes are created
- ACM wildcard certificate for TLS termination at the ALB
- HPA for CPU-based pod autoscaling
- kube-prometheus-stack: Prometheus scraping, Grafana dashboards, AlertManager -> Slack webhooks
- Elastic Stack: Elasticsearch on gp3 PVCs (EBS CSI driver), Filebeat DaemonSet, Kibana for log search
- Key decision: Gateway API over Ingress because it separates infrastructure concerns (Gateway) from application routing (HTTPRoute)

Assets to link: Runbook (cluster addons, observability sections), screenshots
Image: Grafana dashboard screenshot, or Gateway API routing diagram

---

### Series 8: AWS Secure Static Hosting (1 post)

**Post 8.1 — "Zero-compute static hosting on AWS. CloudFront OAC, dual-KMS encryption, $1.45 total."**

Content:
- Architecture: CloudFront with OAC + SigV4 signing -> fully private S3 bucket
- Not legacy OAI, not public bucket. OAC with SigV4 (the current AWS recommended approach).
- ACM wildcard certificate on custom domain
- SPA routing: CloudFront Custom Error Responses return index.html for 403s on missing paths
- Cross-Region Replication (us-east-1 -> us-west-2) with separate KMS Customer Managed Keys per region
- S3 Bucket Keys to reduce KMS GenerateDataKey API costs
- CloudTrail logs management + data events. S3 Server Access Logs for per-request HTTP telemetry.
- Lifecycle Policy: non-current versions -> Glacier after 30 days
- Total cost for 7 days on personal AWS account: $1.45 (covered by Free Tier)
- Key insight: "zero-compute" doesn't mean "zero decisions." The security, encryption, and observability layers still need deliberate design.

Assets to link: GitHub (platform-engineering-systems/static-website), runbook, terminal session, screenshot
Image: CloudFront distribution screenshot, or architecture diagram showing the encryption/replication layers

---

### Standalone Posts (3 posts)

**Post S.1 — "A bash script that provisions a Kubernetes cluster from scratch via kubeadm"**

Content:
- What the script does: full kubeadm cluster bootstrap (container runtime, kubelet, kubeadm init, CNI, kubeconfig)
- Safety features built into the script
- Why kubeadm matters: understanding what managed services abstract away
- Use case: lab environments, learning, bare-metal clusters

Assets to link: Runbook (cluster-kubeadm), script in repo
Image: Terminal output of a successful cluster bootstrap

**Post S.2 — "How I debugged a Kubernetes DNS failure"**

Content:
- The symptom, the investigation, the root cause, the fix
- Pulled from the blog draft on K8s DNS debugging
- Structured as a troubleshooting narrative (expected -> actual -> investigation -> resolution -> lesson)

Assets to link: Blog post (once published), runbook
Image: Terminal output showing the DNS failure and resolution

**Post S.3 — "How I work: two inputs, one synthesis, four outputs"**

Content:
- The methodology: Trigger (don't understand it / run it for real) -> Synthesis (Nectar, 365 pages) -> Output (SilverStack, Blog, Projects, Runbook)
- Why this matters: it explains the system behind all the previous posts
- Not a process document. An operating philosophy: nothing counts as understood until it survives contact with what was actually built.
- Link back to the projects site "How I Work" section
- This post ties the entire publishing series together. Publish near the end.

Assets to link: projects.ibtisam-iq.com/how-i-work, all ecosystem surface URLs
Image: The methodology pipeline diagram (Trigger -> Synthesis -> Output)

---

## III. PUBLISHING SEQUENCE

### Phase 1: Open Source & Tooling (Posts 1-2)
Start with shareable, accessible content.

| # | Post | Series |
|---|------|--------|
| 1 | "I built a Kubernetes debugging toolkit. 93% smaller than netshoot." | DebugBox 1/2 |
| 2 | "How I built a multi-arch container CI pipeline with hard-fail security gates" | DebugBox 2/2 |

### Phase 2: Platform Foundation (Posts 3-6)
Establish credibility as someone who builds infrastructure from scratch.

**Prerequisite:** Before Post 3, engage with (comment + repost) the iximiuz founder's LinkedIn post about the silver-stack images.

| # | Post | Series |
|---|------|--------|
| 3 | "I built a self-hosted CI/CD platform on microVMs. Here is the full stack." | SilverStack 1/4 |
| 4 | "My CI/CD servers had no public IP. Here is how I solved it." | SilverStack 2/4 |
| 5 | "Building immutable server images with systemd as PID 1" | SilverStack 3/4 |
| 6 | "Security decisions in a self-hosted CI/CD stack" | SilverStack 4/4 |

### Phase 3: Pipeline Engineering (Posts 7-8)
Show systematic CI/CD thinking. Builds directly on SilverStack.

| # | Post | Series |
|---|------|--------|
| 7 | "I built one CI pipeline contract and implemented it twice, on Jenkins and GitHub Actions" | DevSecOps 1/2 |
| 8 | "A 3-pass Trivy scanning strategy and why 'latest' is a deployment antipattern" | DevSecOps 2/2 |

### Phase 4: Deployment Breadth (Posts 9-14)
Show range across compute models, environments, and application stacks.

| # | Post | Series |
|---|------|--------|
| 9 | "Same 3 applications, 4 different environments. Same Kustomize base." | Polyglot 1/2 |
| 10 | "Debugging environment-specific edge cases across 4 deployment targets" | Polyglot 2/2 |
| 11 | "I deployed the same Java artifact on EC2, ECS Fargate, and EKS. Here is what I learned." | BankApp 1/1 |
| 12 | "Deploying 5 microservices on bare-metal K8s and Amazon EKS from the same Helm charts" | Retail Store 1/2 |
| 13 | "IRSA, serverless event pipelines, and why I used CloudFormation worker nodes instead of eksctl" | Retail Store 2/2 |
| 14 | "A bash script that provisions a Kubernetes cluster from scratch via kubeadm" | Standalone |

### Phase 5: Crown Jewel (Posts 15-18)
The most complex project. By now the audience understands all the building blocks.

| # | Post | Series |
|---|------|--------|
| 15 | "10 microservices on EKS with fully automated GitOps. Here is the full stack." | EKS GitOps 1/4 |
| 16 | "Terraform on a restricted AWS account: working around SCPs with self-managed ASGs" | EKS GitOps 2/4 |
| 17 | "Dynamic CI matrix dispatch: building only the microservices that changed" | EKS GitOps 3/4 |
| 18 | "Gateway API, ExternalDNS, and observability on EKS" | EKS GitOps 4/4 |

### Phase 6: Closing (Posts 19-21)
Cloud architecture, debugging story, and the methodology that ties it all together.

| # | Post | Series |
|---|------|--------|
| 19 | "Zero-compute static hosting on AWS. CloudFront OAC, dual-KMS encryption, $1.45 total." | AWS Hosting 1/1 |
| 20 | "How I debugged a Kubernetes DNS failure" | Standalone |
| 21 | "How I work: two inputs, one synthesis, four outputs" | Standalone (closing) |

---

## IV. POST TEMPLATE

### A. Standard Post Structure

```
[HOOK — first 2 lines, visible before "see more"]
One strong, factual statement about what was built or solved.
A specific metric or contrast that makes the reader want to expand.

[CONTEXT — 2-3 sentences]
What the project is. What problem it solves. What constraints existed.

[SUBSTANCE — the core of the post, 3-6 short paragraphs]
What was done, with what tools, and what the outcome was.
Weave in one key technical decision or debugging moment.
Each paragraph: 1-3 sentences max. No walls of text.

[TAKEAWAY — 1-2 sentences]
One clear principle or lesson extracted from the work.
Not a platitude. A specific, actionable insight.

---

[LINK BLOCK — at the very end, after a separator]
Project: [URL]
Source: [GitHub URL]
Runbook: [URL]
Terminal session: [URL]

[SERIES TAG — if part of a series]
This is post X/Y in the [Series Name] series.
Previously: [link to last post or brief topic mention]

[HASHTAGS — 3-5 max]
#DevOps #Kubernetes #AWS #CICD #OpenSource
```

### B. Link Placement Rules

1. **Never put links in the first 3 lines.** LinkedIn truncates at ~210 characters. The hook must be pure text.
2. **Never put links mid-paragraph.** LinkedIn's algorithm deprioritizes posts with inline external links.
3. **All links go in a dedicated block at the bottom**, after a visual separator (`---` or a blank line).
4. **Label each link clearly**: "Project:", "Source:", "Runbook:", "Terminal session:"
5. **If the post references a blog post**, the blog post must be published and live before the LinkedIn post goes out.

### C. Series Continuity Pattern

Each post in a multi-part series includes two connection points:

**At the top** (after the hook, within the context section):
> "This is the second post in the SilverStack series. The first post covered the full stack overview. This one focuses on a specific problem: none of those servers had a public IP."

**At the bottom** (in the link block):
> "SilverStack series: [1/4] Full Stack Overview | **[2/4] NAT Problem** | [3/4] Immutable Images | [4/4] Security"

Bold the current post. Link the others once published. This creates a navigable index at the bottom of every post in the series (similar to the runbook index.md pattern).

### D. Troubleshooting Narrative Pattern

When a post includes a debugging story, follow this structure:

1. **What was expected**: "Terraform apply should provision managed EKS node groups."
2. **What happened**: "The apply succeeded with no errors, but no nodes joined the cluster."
3. **Investigation**: "Checked the EKS console. The node group creation call was rejected. CloudTrail showed an explicit deny from an SCP."
4. **Root cause**: "The AWS Organization had an SCP blocking `eks:CreateNodegroup` in non-production accounts."
5. **Resolution**: "Switched to self-managed Auto Scaling Groups with custom launch templates. Nodes joined within 3 minutes."
6. **Principle extracted**: "Enterprise AWS accounts have constraints that sandbox accounts don't. Check SCPs before choosing an EKS node strategy."

This structure reads as analytical and engineered, not as a tutorial or a copy-pasted summary.

### E. Tone Rules (from persona constraints)

- **Honest verbs**: built, configured, deployed, automated, wrote, set up
- **No em dashes**: use parentheses or start a new sentence
- **Banned words**: delve, leverage, seamless, robust, ever-evolving, elevate, unleash, unlock, dive into, navigate
- **No hype**: no "mastery", "expert", "flawless", "game-changing", "revolutionary"
- **No student tone**: no "learning journey", "exploring", "getting started with"
- **No production claims**: these are lab/sandbox projects. Say "built" and "deployed", not "production-grade" or "enterprise-ready"
- **Factual, not marketing**: state what was done and what the outcome was. Let the work speak.
- **Short paragraphs**: 1-3 sentences max. LinkedIn is a mobile-first platform.

---

## V. IMAGE STRATEGY

Every post includes one image. Types:

| Image Type | When to Use | How to Create |
|------------|-------------|---------------|
| Architecture diagram | Project overview posts | Draw in Excalidraw or similar. Dark background matching the site theme. |
| Terminal output screenshot | Debugging/troubleshooting posts | Screenshot of the actual terminal session .txt content, formatted in a code block or terminal emulator theme. |
| Pipeline/flow diagram | CI/CD and GitOps posts | Stages laid out horizontally or vertically with tool logos. |
| Comparison graphic | Size/performance comparisons (DebugBox vs netshoot) | Side-by-side bar chart or table with numbers. |
| GitHub Actions screenshot | CI pipeline posts | Screenshot of a successful (green) workflow run. |
| Cloud console screenshot | AWS/EKS posts | CloudFront distribution, EKS cluster, Grafana dashboard. |
| Code snippet screenshot | Specific technical decisions | A focused Dockerfile, Kustomize overlay, or Helmfile snippet. Clean, syntax-highlighted. |

**Visual consistency**: Use the same color scheme across all diagrams (dark background `#0d1117` or `#0B0F19`, purple/teal accents). This creates a recognizable visual brand across posts.

---

## VI. iximiuz PLATFORM CROSS-PUBLISHING

These are separate from the LinkedIn plan. They are articles written for the iximiuz platform itself.

### Article 1: "Exposing NAT-Behind iximiuz Labs to the Public Internet via Cloudflare Tunnel"

Source: runbook (`self-hosted/ci-cd/iximiuz/self-hosted-cicd-stack-journey-from-ec2-to-iximiuz-labs.md`) + blog drafts on NAT problem and Cloudflare Tunnel

Content:
- iximiuz playgrounds run behind NAT with no public IP
- No existing documentation on the platform explains how to publicly expose them
- Step-by-step: install cloudflared, configure tunnel, set up DNS records, connect to custom domain
- Result: jenkins.example.com, sonar.example.com, nexus.example.com all publicly accessible
- The iximiuz founder personally noticed this solution and suggested writing about it

**Timing**: Publish this before or alongside SilverStack Post 2.2 (the NAT post on LinkedIn). The LinkedIn post can then link to the iximiuz article as the detailed guide.

### Article 2: "Building Custom OCI Rootfs Images for iximiuz Playgrounds"

Source: runbook (`containers/iximiuz/rootfs/`) — all 5 rootfs setup guides

Content:
- How to build custom rootfs images that work as iximiuz Lab playgrounds
- Using systemd as PID 1 (required for multi-service environments)
- Example: a complete Jenkins server image from Ubuntu 24.04 base
- Publishing to GHCR and connecting to iximiuz Labs

### Article 3: "Running Jenkins + SonarQube + Nexus on iximiuz MicroVMs"

Source: runbook (`self-hosted/ci-cd/iximiuz/cicd-stack-operations.md`)

Content:
- Full CI/CD stack deployment on iximiuz Labs
- Multi-node playground configuration (5 servers)
- Service orchestration with systemd
- Persistent storage on the 100GB volume
- Live playground URL for anyone to try

---

## VII. PREREQUISITES CHECKLIST

Before starting to publish:

- [ ] **Engage with iximiuz founder's post**: Comment on and repost the founder's LinkedIn post about the silver-stack images. Do this at least 1 week before the SilverStack series begins.
- [ ] **Publish blog posts**: Each LinkedIn post that links to a blog post requires the blog post to be live first. Prioritize publishing blog drafts in the order they map to the LinkedIn sequence.
- [ ] **Prepare images**: Create architecture diagrams, comparison graphics, and screenshot visuals for at least the first 4-6 posts before publishing begins. Batch creation is more efficient than creating one at a time.
- [ ] **Prepare the iximiuz Cloudflare Tunnel article**: This should be published on the iximiuz platform before SilverStack Post 2.2 goes live on LinkedIn.
- [ ] **Update LinkedIn headline**: Should reflect current positioning (DevOps & Cloud Engineer | CKA | CKAD).
- [ ] **Update LinkedIn About and Experience**: These should be polished before original posts begin driving traffic to the profile.
- [ ] **Review LinkedIn Featured section**: Pin the projects site and portfolio site with working OG preview cards.

---

## VIII. CADENCE OPTIONS

The plan contains 21 posts. Possible cadences:

| Cadence | Duration | Notes |
|---------|----------|-------|
| 5 posts/week (daily weekdays) | ~4.5 weeks | Aggressive. High output. Risk of audience fatigue. |
| 4 posts/week | ~5.5 weeks | Strong pace. Allows 1 rest day between series. |
| 3 posts/week (Mon/Wed/Fri) | ~7 weeks | Sustainable. Gives time for engagement on each post. **Recommended.** |
| 2 posts/week (Tue/Thu) | ~10.5 weeks | Conservative. Lower risk of fatigue, but slower momentum. |

**Recommendation**: Start at 3 posts/week. If engagement is strong and writing momentum is good, increase to 4. If it feels forced, drop to 2. The sequence is designed so natural pause points exist between series (e.g., after DebugBox, after SilverStack, after the deployment projects).

**Best posting times for Pakistan (PKT, UTC+5)**:
- Weekday mornings: 8:00-9:00 AM PKT (catches early LinkedIn scrollers + overlap with Gulf/Middle East morning)
- Weekday evenings: 5:00-6:00 PM PKT (catches end-of-day scrollers + European afternoon)
- Avoid weekends for professional content in the Pakistan market

---

## IX. CONTEXT SNAPSHOT (as of 2026-07-28)

Captured so a future session can pick this up without re-deriving:

**Targeting**: AWS Cloud Engineer and DevOps Engineer roles, Junior to Mid-level, on-site in Pakistan (Islamabad/Rawalpindi first).

**Tone**: Not explicitly job-seeking. "Engineer sharing work" style.

**LinkedIn state**: 5,000+ connections. Audience is not cold (1.5 years of strategic commenting), but there are almost no original posts.

**Content readiness**: All 8 project runbooks completed. Blog posts still in draft. Terminal recordings exist as plain `.txt` files (no video/GIF).

**Certifications**: CKA and CKAD earned. CKS in progress.

**iximiuz**: 5 playgrounds published. The founder noticed the Cloudflare Tunnel solution and suggested writing about it. Feature this connection prominently.

**Decisions already made**:
- No single "launch" post. Individual project posts with multi-part series instead.
- Cadence deliberately not fixed upfront. Plan the content first, then choose the pace.
- Post copy (actual written text) deferred. This document is structure only.
