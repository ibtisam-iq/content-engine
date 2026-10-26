# Phase 2 Rework: SilverStack Content Architecture

> **Created:** 2026-07-28
> **Supersedes:** Phase 2 (4 posts) in `linkedin-publishing-plan.md`
> **Verdict:** Directionally correct, needs restructuring. 4 posts → 5 core + 3 expansion.
> **Sources audited:** runbook/containers/iximiuz (6 files), runbook/self-hosted/ci-cd/iximiuz (4 files),
> silver-stack/.github/workflows (6 files), silver-stack/iximiuz/manifests (5 files, Guacamole excluded),
> silver-stack/iximiuz/rootfs (full tree: 6 Dockerfiles, all scripts/configs/units), labs.iximiuz.com/a/ibtisam-iq

---

## PART 1: SOURCE UNDERSTANDING

### What exists

**Six OCI images, one inheritance chain:**

```
ubuntu-24-04-rootfs (base, multi-arch amd64+arm64)
├── dev-machine-rootfs      → Playground: SilverStack Dev Machine
├── dev-cicd-rootfs         → (jump host node inside CI/CD Stack, no standalone playground)
├── jenkins-rootfs          → Playground: SilverStack Jenkins Server
├── sonarqube-rootfs        → Playground: SilverStack SonarQube Server
└── nexus-rootfs            → Playground: SilverStack Nexus Server
                            → Playground: SilverStack CI/CD Stack (composes 4 of the above)
```

Five playgrounds published, all with `accessControl: canStart: anyone`. Confirmed live on the
iximiuz author profile alongside one tutorial (DebugBox, which belongs to Phase 1).

### The technically distinctive material

Ranked by how rare and defensible each angle is.

**1. The OCI image deliberately built to fail as a container.**
iximiuz mounts the image as a block device and boots it as a Firecracker microVM with its own
kernel. systemd becomes PID 1 through the platform, not the image. Consequences encoded in the base
Dockerfile: `rm -f /etc/ssh/ssh_host_*` (host keys must be per-VM), `echo "" > /etc/machine-id` and
`/var/lib/dbus/machine-id` (per-VM identity), `rm -f /.dockerenv` (stop systemd detecting a
container), `systemctl mask sshd-keygen@.service` and `sshd-keygen.target`, `systemctl disable
ssh.socket` in favour of `ssh.service`, and no `CMD`/`ENTRYPOINT` on the base at all.
`docker run` producing "System has not been booted with systemd as init system" is documented as the
correct outcome. This is the most differentiated story in the repo. Very few people write about it.

**2. `USER $USER` vs `USER root` as a deliberate asymmetry.**
Dev Machine ends `USER ibtisam`. Service images end `USER root` + `CMD ["/lib/systemd/systemd"]`.
The runbook argues this precisely: `USER` is an OCI config field only `docker run` reads; the microVM
boot ignores it entirely. Ending the workstation image as the non-root user makes the `docker run`
binary-presence check run as the user who will actually use the tools, so a tool installed somewhere
only root can reach fails the check instead of silently passing. Service images need root because
`CMD` must start systemd. Genuinely subtle, genuinely correct, and well documented.

**3. The NAT discovery and the direction reversal.**
Full arc, already written: 2–3 days validating the stack on three EC2 instances (public IPs, Nginx,
Certbot HTTP-01, Let's Encrypt, Cloudflare DNS) → copy to iximiuz → services healthy locally, DNS and
SSL dead → `curl ifconfig.me` on all four nodes returns `148.113.47.48` → microVMs share one NAT
gateway, no per-VM inbound routing. A table of five approaches and why each fails (A record to shared
NAT IP, port forwarding, DDNS, Certbot HTTP-01, self-signed). Fix: stop waiting for inbound.
`cloudflared` holds an outbound tunnel open to Cloudflare's edge; Cloudflare terminates SSL, matches
hostname to tunnel, forwards to `localhost:80`. One tunnel per service, separate tokens, zero inbound
ports. Nginx stays in the chain deliberately (buffering, logging, a `/health` independent of the
backend, and service port changes don't touch tunnel config).

**4. `lab-init`: boot-time reconciliation as a first-class pattern.**
Every service image ships a systemd oneshot with `Before=ssh.service nginx.service <svc>.service`,
`Type=oneshot`, `RemainAfterExit=yes`. It reconciles what cannot be baked: `ssh-keygen -A` (keys were
deleted at build), `mkdir -p /run/sshd /run/nginx` (tmpfs wipes them every boot), ownership fixes on
service directories. The SonarQube variant is materially more complex: starts the cluster with
`pg_ctlcluster 18 main start` (because Debian's `postgresql.service` is a wrapper unit), polls 30s for
readiness, creates the role in an idempotent `DO $$ BEGIN IF NOT EXISTS ... END $$` block, then checks
`pg_database` at shell level before `CREATE DATABASE` (which cannot run inside a DO block), grants
privileges, and applies `vm.max_map_count=524288` / `fs.file-max=131072` via `sysctl -w` because the
microVM may not read `/etc/sysctl.conf` at boot. Clean separation of bake-time vs boot-time state.

**5. Build-time validation of an artifact that cannot run.**
`healthcheck.sh` runs as a `RUN` step and fails the build on non-zero exit. It cannot use `systemctl`
because systemd isn't running during build, so it validates enabled services by checking for symlinks
in `/etc/systemd/system/multi-user.target.wants/`, packages via `dpkg-query -W -f='${Status}'`,
config validity via `nginx -t`, ownership via `stat -c '%U'`. Jenkins and Nexus check 8 sections,
SonarQube 10. Notably it asserts SSH host keys are *absent* as a pass condition.

**6. Capacity planning against a hard budget.**
Flexbox provides a fixed pool: 10 vCPU, 16 GiB RAM, 150 GiB disk. `cicd-stack.yml` allocates
1+3+3+3 = 10 vCPU, 1+4+6+5 = 16 GiB, 30+40+40+40 = 150 GiB. Exactly at all three limits, with stated
reasoning per node (jump host runs no services so it gets the smallest slice; SonarQube gets the most
RAM because it runs embedded Elasticsearch alongside PostgreSQL in one VM). JVM heaps in
`sonar.properties` are sized to match (web `-Xmx1G`, CE `-Xmx2G`, ES `-Xms1G -Xmx1G` with equal
min/max to avoid resizing).

**7. Least-privilege daemon accounts.**
Explicit command lists instead of `NOPASSWD:ALL`. Jenkins: 6 commands. Nexus: 6. SonarQube: 8, and
the two extra (`systemctl restart/status postgresql`) are justified in the runbook because SonarQube
depends on a live database and may need to recover from a DB failure. Note the interactive user
(`ibtisam`) does get `NOPASSWD:ALL` via `add-user.sh`, so this is daemon-account hygiene, not a
whole-system least-privilege claim. Frame it accurately.

**8. A supply-chain pin with a real incident behind it.**
`install-pipeline-tools.sh` pins Trivy to `0.69.3` with a header comment: `0.69.4` was a malicious
release (March 19 2026, CVE-2026-33634) published via compromised Aqua Security credentials, which
exfiltrated secrets from CI/CD pipelines. Links to `aquasecurity/trivy/discussions/10425`.

**9. Lean-by-design: what is deliberately not baked in.**
Pipeline tools and Jenkins plugins are installed to `/usr/local/bin` as callable scripts
(`install-pipeline-tools`, `install-plugins`) and explicitly never executed during build. Tunnel
tokens are per-playground secrets supplied at runtime. Initial admin passwords generate per boot.
PostgreSQL contents provision fresh each boot. Documented as an explicit list of exclusions.

**10. Nginx as canonical entry point.**
Tunnel points to `localhost:80`, never the service port. Jenkins' nginx config is non-trivial:
`map $http_upgrade $connection_upgrade` for websockets, `upstream ... keepalive 32`, dedicated `/cli`
and `/jnlpJars/` locations, legacy `/static/[0-9a-f]{8}/` rewrite, `proxy_buffering off` for streaming
console output, static-asset caching with security headers (`X-Frame-Options`,
`X-Content-Type-Options`, `Referrer-Policy`), and a `/health` returning 200 independently of Jenkins.

**11. Build-time port parameterisation.**
`__JENKINS_PORT__` / `__SONARQUBE_PORT__` / `__NEXUS_PORT__` placeholders substituted by `sed` across
nginx config, systemd unit, service properties, and the welcome banner. One build arg changes the port
everywhere consistently.

**12. Ordering constraints that are easy to get wrong.**
`COPY welcome $HOME/.welcome` must be the last instruction because `customize-bashrc.sh` appends
logic that displays and then deletes `~/.welcome` on first interactive login. `install-tools.sh` must
use `COPY` rather than a bind mount because its PHASE 27 cleanup runs `rm -rf /tmp/*`, which against a
live bind mount is undefined behaviour. Other scripts use bind mounts because they don't delete
`/tmp/`.

### CI/CD design (the weakest area, be honest about it)

Six near-identical workflows. What's there: path-filtered triggers with negation for `README.md` and
`CONTENT.md`, `workflow_dispatch`, PR builds that don't push, `docker/metadata-action` tags (`latest`,
`sha-<short>`, `YYYY-MM-DD`, plus pinned version tags per service), rich OCI labels including
`base.name` and a `documentation` URL pointing at the runbook, GHA layer cache, and `nektos/act`
support via `env.ACT` conditionals (`load: ${{ !!env.ACT }}`, `push: ${{ !env.ACT && ... }}`).

What's not there, and matters if you post about it:
- No Trivy scan, no hadolint, no separate test job. All validation lives inside the Dockerfile via
  `healthcheck.sh`. That is a defensible choice but it is the opposite of the DebugBox pipeline in
  Phase 1, so do not claim a consistent CI philosophy across both.
- `BUILD_DATE` and `VCS_REF` are declared as ARGs and used in `LABEL` but never passed as
  `build-args`, so `org.opencontainers.image.created` and `.revision` interpolate to empty strings.
  The runbooks already flag this as a known gap in four places.
- Base builds multi-arch (QEMU, amd64+arm64); all five children are amd64-only. So the arm64 base
  has no consumers.
- Service version tags (`2.541.2-lts`, `26.2.0-community`, `3.89.1.02-community`) are hardcoded in
  workflow YAML, decoupled from the versions in the install scripts. They drift silently.

**Conclusion: the CI is competent plumbing, not a story. Blog only, and only as one section.**

### Pre-publish blockers found

1. **`COPY examiner* /usr/local/bin` in the base Dockerfile has no matching files in the repo and they
   are not gitignored.** A clean rebuild of `ubuntu-24-04-rootfs` would fail. Children still build
   because the base is already on GHCR. Fix before publishing anything that says "reproducible".
2. **"Production-grade" appears in all five public manifest descriptions, the rootfs README, and the
   runbook titles.** That is publicly visible on iximiuz and contradicts the no-production-claims rule
   for LinkedIn copy. Either soften the manifests or accept the inconsistency knowingly. LinkedIn copy
   below avoids the phrase entirely.
3. **`BUILD_DATE`/`VCS_REF` gap** is a ~10 minute fix and would strengthen any reproducibility claim.

---

## PART 2: REASSESSMENT OF THE OLD PHASE 2 PLAN

### Verdict: **Directionally correct but needs restructuring.**

Not outdated (the subject matter is right, the sequencing instinct was right, the NAT post is
genuinely strong). Not valid as-is (two of four posts are mis-angled and one is filler). And
incomplete in a specific, important way: it ignored the playgrounds as launchable products.

### Post by post

| Old post | Verdict | Why |
|---|---|---|
| 2.1 "I built a self-hosted CI/CD platform on microVMs. Here is the full stack." | **Cut as an opener; rebuild as the closer** | This is a stack tour. No tension, no surprise, no reason for a stranger to stop scrolling. "Here is the full stack" is the single most reliable underperformer on LinkedIn. The material is real but it works as a payoff after the reader understands the layers, not as an introduction. |
| 2.2 "My CI/CD servers had no public IP. Here is how I solved it." | **Keep, sharpen the hook** | The strongest post in the old plan. Real mystery, concrete evidence, a table of failed approaches, a clean reversal. Only change: open on the evidence (four identical IPs) rather than the conclusion. |
| 2.3 "Building immutable server images with systemd as PID 1" | **Keep the topic, change the angle** | "systemd as PID 1" is a configuration detail and reads as a tutorial title. The actual story in the source is far better: the image is deliberately engineered so that running it as a container fails. That has tension and teaches something most engineers have never considered. |
| 2.4 "Security decisions in a self-hosted CI/CD stack" | **Cut as planned; salvage one third** | Grab bag of six unrelated one-liners (sudoers, ephemeral keys, checksums, headers, no inbound ports, "security habits"). No single tension, so nothing to hook on. Worse, two claims are shaky: the interactive user has `NOPASSWD:ALL`, and the "SHA256 verification on all downloads" claim isn't uniformly true across the install scripts. Salvage the sudoers detail plus the Trivy pin into one expansion post with an actual hook. |

### What the old plan missed entirely

**The playgrounds are the most engagement-friendly asset in the whole project and got zero posts.**

Five playgrounds, all publicly launchable by anyone with no signup friction beyond an iximiuz account.
That is a click-and-run artifact. On LinkedIn a link someone can actually use outperforms an
architecture description reliably. The old plan mentioned playground URLs only as "assets to link."

**It also collapsed two different audiences into one voice.** There are two distinct readers here:
people who want to *use* something today (Dev Machine, CI/CD Stack) and people who want to know *how
it was built* (rootfs engineering, boot model, NAT). Those need different hooks and different posts.
The old four-post plan spoke only to the second group.

### On the "should each of 5 playgrounds get a post?" question

**No. Two announcement posts, not five.** Jenkins, SonarQube, and Nexus are structurally the same
story: Ubuntu base, systemd, nginx on :80, cloudflared, lab-init, limited sudoers. Three separate
announcements would be exactly the redundancy to avoid. They appear instead as a link block in the
CI/CD Stack post's first comment and as one carousel asset.

The single exception: SonarQube has one thing the others don't (runtime database provisioning in an
ephemeral VM). That earns an expansion post framed on the *problem*, not on the playground.

---

## PART 3: NEW CONTENT ARCHITECTURE

### Core LinkedIn posts (5) — publish all

| # | Title / angle | Purpose | Audience value | Channel | Why not redundant |
|---|---|---|---|---|---|
| **C1** | **"I stopped losing 20 minutes to tool installs on every fresh lab VM"** (Dev Machine playground) | Entry point. Lowest-friction, most shareable, gives the audience something usable before asking them to read architecture. | A loaded workstation they can launch now. ~40 tools, aliases, completions, zero install. | LinkedIn + short blog companion | Only post that is a product announcement. Contains no build internals. |
| **C2** | **"Four servers. `curl ifconfig.me` returned the same IP on all four."** (NAT → tunnel) | The narrative anchor. Explains *why* everything downstream is shaped the way it is. | A networking constraint most people meet eventually, and a general principle (reverse the direction). | LinkedIn + blog (consolidated canonical post) | Pure networking. No image internals. |
| **C3** | **"I made sure my container image fails if you run it as a container"** (microVM rootfs model) | The differentiator. The rarest knowledge in the project. | Inverts Docker habits: host keys, machine-id, /.dockerenv, no CMD, the USER asymmetry. | LinkedIn + blog (flagship deep post) | Build-time only. Says nothing about boot or networking. |
| **C4** | **"An immutable image gets you a reproducible filesystem. Not a working machine."** (lab-init) | The reusable pattern. Completes C3. | A transferable model: bake what's static, reconcile what's per-boot, in a systemd oneshot. | LinkedIn + blog (same deep post as C3, different section) | Boot-time only. C3 is build-time. Explicit complement. |
| **C5** | **"Standing this up by hand took a few hundred commands. It now takes one."** (CI/CD Stack) | The payoff and the close. Now the reader knows every layer. | 4-node composition, capacity budget at exact limits, one manifest, launchable. | LinkedIn + blog | Composition and capacity planning. Single-node internals already covered in C3/C4. |

### Optional LinkedIn expansion posts (3) — publish if momentum is good

| # | Title / angle | Purpose | Channel | Why not redundant |
|---|---|---|---|---|
| **E1** | **"How do you test an image that cannot start?"** (build-time healthcheck) | Testing philosophy under an unusual constraint. | LinkedIn + blog section | C3 says the image can't run. E1 asks what verification is then still possible. Different question. |
| **E2** | **"You cannot run `initdb` at `docker build` time"** (SonarQube runtime DB provisioning) | The one genuinely distinct single-service story. | LinkedIn + optional deep blog | C4 covers the oneshot pattern generally. E2 is the hardest concrete instance: cluster start, readiness poll, idempotent role vs database creation. |
| **E3** | **"Six sudo commands and one pinned version number"** (daemon least-privilege + Trivy) | Salvages the useful third of old post 2.4, with a real hook (the Trivy supply-chain incident). | LinkedIn only | Narrow and specific. Must state honestly that the interactive user still has full sudo. |

### Core blog posts (3)

| Blog post | Status | Action |
|---|---|---|
| **B1. "Building an OCI image that boots as a microVM, not a container"** | Seed exists: `containers/003-docker-rootfs-systemd-cicd.md` (933 words) | **Expand hard to 2,000+.** Absorbs C3 + C4 + E1. This is the flagship and currently the biggest gap between what was built and what is written. Cover: the block-device boot model, every anti-container step with rationale, the USER asymmetry table, base-to-child inheritance rules, layer ordering constraints (welcome-file placement, COPY vs bind mount), lab-init, and the build-time healthcheck. |
| **B2. "The NAT problem and the tunnel that solved it"** | Two posts exist and overlap: `networking/001` (648w) + `networking/002` (765w) | **Merge into one canonical post.** They are one story split in half; neither stands alone well. Combined and expanded they become the single link target for C2. |
| **B3. "Four nodes, one manifest: composing a CI/CD stack on microVMs"** | Partial: `platform/001-silverstack-cicd-lab.md` (685w) | **Rewrite and expand.** Absorbs `platform/003`. Cover manifest structure, node roles, the exact-budget capacity math, JVM heap sizing to match allocation, tab wiring, intra-stack hostname networking, and the one remaining manual step (tunnel token). |

### Optional deeper blog posts (2)

- **B4. "Runtime database provisioning for ephemeral VMs"** — the full E2 story. Only if E2 performs.
- **B5. "Building rootfs images in GitHub Actions"** — the CI design, written honestly including the
  known gaps. Low priority. It is the least remarkable part of the project and should never be a
  LinkedIn post.

### Blog cleanup required (do this before publishing C2)

`platform/001` (why I built my own CI/CD stack, 794w), `platform/002` (Jenkins/Sonar/Nexus on EC2 with
Certbot, 811w), and `platform/003` (SilverStack CI/CD lab, 685w) are three overlapping short posts
about the same stack, all written in the EC2 era before the rootfs work existed. `platform/002`
teaches Certbot HTTP-01, which the NAT discovery later invalidated for this environment.

Action: keep `platform/001` as the "why" essay. Retitle or add a framing note to `platform/002`
marking it explicitly as the EC2 predecessor so it reads as history rather than current guidance.
Fold `platform/003` into B3.

### Not standalone posts (deliberate exclusions)

- Nginx-as-entry-point rationale → first comment on C2, plus a section in B3
- CI workflow design → B5 only
- Base image inheritance model → section within B1
- Build-time port parameterisation (`sed` placeholders) → section within B1
- Capacity budget alone → folded into C5, not its own post
- Jenkins / SonarQube / Nexus individual playground announcements → link block in C5's first comment

---

## PART 4: FINAL RECOMMENDED SEQUENCE

**Phase 2 becomes 5 core posts, not 4.** With 3 optional expansions held in reserve, so the realistic
range is 5 to 8.

### Order and narrative flow

```
C1  Dev Machine          "Here is something you can use right now."
      ↓  earns attention with zero cost to the reader
C2  NAT → Tunnel         "Here is the constraint that shaped all of it."
      ↓  supplies the why for every design decision that follows
C3  Anti-container image "Here is how the image is built."          [build time]
      ↓  natural pair, explicitly sequenced
C4  lab-init             "Here is how it comes up."                  [boot time]
      ↓  reader now understands one node completely
C5  CI/CD Stack          "Here is what four of them compose into."   [payoff]
```

**Why C1 first.** It is the only post that costs the reader nothing. Click, launch, use. It builds an
audience for the deeper posts and establishes that this person ships usable things rather than
describing them. Given that previous posts underperformed, opening with an architecture tour repeats
the likely cause. Open with utility instead.

**Why C2 second and not first.** The NAT post is the best story but it is a *middle* of a narrative:
it only lands fully once the reader knows there is a real stack behind it. Placed second it converts
C1's attention into interest in how the thing was built.

**Why C3 → C4 in that order.** Build time precedes boot time. C3 ends on "this image cannot run as a
container," which sets up C4's "so how does it come up?" Cross-reference them explicitly in both
directions.

**Why C5 last.** It is the old 2.1 post, but placed where it works. As an opener it is a stack tour.
As a closer, after the reader understands the image model, the boot model, and the networking
constraint, the four-node composition reads as synthesis and the capacity math reads as craft.

### Expansion insertion points

If engagement is strong, insert expansions rather than appending them:
- **E1** after C3 (same build-time frame, keeps momentum on the image topic)
- **E2** after C4 (hardest instance of the pattern C4 just introduced)
- **E3** anywhere after C5 (standalone, no dependencies)

### Cadence

3 posts/week from the wider plan holds. Phase 2 runs ~2 weeks at 5 posts, ~2.5 weeks at 8.

### Pre-publish checklist for this phase

- [ ] Fix `COPY examiner*` so the base image rebuilds from a clean checkout
- [ ] Pass `BUILD_DATE` / `VCS_REF` as build-args (6 workflows, ~10 min) before claiming reproducibility
- [ ] Merge `networking/001` + `002` into B2 and publish, before C2 goes out
- [ ] Expand `containers/003` into B1 and publish, before C3 goes out
- [ ] Decide on the "production-grade" wording in the five public manifest descriptions
- [ ] Confirm all five playgrounds start cleanly from a logged-out browser session
- [ ] Engage with the iximiuz founder's post (comment + repost) at least a week before C2

---

## PART 5: PRODUCTION LINKEDIN POSTS

See main response for full drafts of C1–C5 with first comments.

### Asset requirements

| Post | Asset | Notes |
|---|---|---|
| C1 | Screenshot of the Dev Machine welcome banner | Already exists in runbook assets. Terminal, dark. |
| C2 | Two-panel diagram: NAT (inbound blocked) vs tunnel (outbound held open) | Highest-value asset in the phase. Worth doing properly. |
| C3 | Code card: the anti-container build steps, 5 lines, annotated | `rm -f /etc/ssh/ssh_host_*`, `echo "" > /etc/machine-id`, `rm -f /.dockerenv`, mask sshd-keygen, no CMD |
| C4 | Boot-sequence diagram: systemd → lab-init (oneshot) → nginx → service | Reuse the ASCII trees from the runbooks, rendered. |
| C5 | The 4-node resource table showing totals hitting 10 / 16 / 150 exactly | The exact-fit numbers are the visual. |

### Link discipline

Zero links in post bodies. LinkedIn suppresses reach on posts with outbound links in the body. Every
link goes in the first comment, posted by the author immediately after publishing. First comments are
drafted alongside each post in the main response.
