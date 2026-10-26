# SilverStack LinkedIn Series — FINAL v5

> **Updated:** 2026-07-29
> **Status:** Final. Copy-paste ready.
> **Count:** 6 posts. 1 product front door, 1 platform/credibility, 2 use case, 1 hybrid, 1 deep-dive.
> **Cadence:** 2/week (Tue + Thu), ~3 weeks.
> **Formatting:** no em dashes, no backticks, no angle-bracket notation.
> **Blog companions:** posts 4, 5 and 6 link to blog articles. Posts 5 and 6 are **gated**: publish
> the blog first. See `blog-companion-index.md` for the full map and publish order.

## ORDER (changed in v5)

```
1  Launch          what I built, launchable now              VALUE
2  Platform        where it runs, how I got here, the thanks CREDIBILITY
3  Dev Machine     the machine I work from                   VALUE
4  CI/CD Stack     the four-machine use case                 VALUE
5  Tunnel          own domain, no public IP                  HYBRID
6  Rootfs          the image engineering                     DEEP
```

**Why the platform post moved from 6 to 2.** At position 6 the platform explanation arrived after
five posts had already assumed it. At position 2 it explains the ground everything else stands on,
right when a reader starts wondering. It is also the post most likely to be reposted, and a repost at
position 2 lifts four later posts, where a repost at position 6 lifts nothing.

**Why not position 1.** Post 1 must be "here is what I built and you can run it today." That is what
makes a stranger care about a stranger. Opening the whole series on someone else's product, however
warmly, starts small.

## LIVE SERVICE URLS: link them, in Post 5 only

`jenkins.ibtisam-iq.com`, `sonar.ibtisam-iq.com`, `nexus.ibtisam-iq.com` are kept continuously live
and their admin credentials have been changed, so all three present a login wall to a stranger.

That makes them useless as a demo and excellent as **proof**. A reader does not need to log in to
verify a valid certificate on a custom domain served from a machine with no public IP and no inbound
ports. That is precisely the claim the tunnel post makes, and it is the claim hardest to take on
faith.

**Post 5 (Tunnel), first comment, only.** Not Post 1 or Post 4, where "launch your own" and "look at
mine" pull against each other. Not Post 2, which is about the platform rather than these services.

**Framing:** never "try it," since they cannot. Say the login wall is the point, then name what it
proves. Draft wording is in the Post 5 first comment below.

**Do not mention the keeper automation in any post.** Session limits exist for resource reasons.
Describing automation that keeps a playground running continuously, in a series that credits the
person who set that limit, is risk with no upside. If asked in comments, "I restart them" is complete
and true.

**Open item:** the cron trigger in `.github/workflows/iximiuz-playground-keeper.yml` is commented
out, so as committed the workflow only runs on manual dispatch. Confirm uptime is actually automated
before publishing links that depend on it.

---

## 1. VOCABULARY (applies to all phases)

| Thing | Correct word | Never |
|---|---|---|
| The published, launchable unit | **playground** | environment |
| A single VM inside one | **machine** or **server** | node (except when quoting the manifest) |
| CLI binaries on the Dev Machine | **tools** | software |
| Jenkins, SonarQube, Nexus (systemd daemons) | **services** | software |
| Covering both at once | **everything** | software |

"Playground" is the platform's own noun (`kind: playground` in the manifests, the heading on the
author profile). Using a different word in a post than on the landing page costs trust for no gain.

**One exception:** the Dev Machine post (now Post 3). Calling it a "playground" contradicts "this is
where I do my real work." Use "machine" in that body; the first comment can say playground.

---

## 2. PROJECT MODEL

### Definition (never narrow this to CI/CD)

**Full anchor**
> SilverStack is an open project of mine. I package complete, preconfigured machines as custom OCI
> images and publish them as playgrounds anyone can launch in a browser on iximiuz Labs, which boots
> each one as a Firecracker microVM.

**Short anchor**
> SilverStack is an open project of mine where complete preconfigured machines are published as
> playgrounds anyone can launch on iximiuz Labs.

**Very short fallback**
> SilverStack, my open project for packaging complete machines as launchable browser playgrounds.

**Banned:** "a set of self-hosted CI/CD environments." Wrong about the current set (the Dev Machine
is not CI/CD) and wrong about the direction. The current set is developer and CI/CD focused because
that is what was needed first. More playgrounds get added as the need arises.

### 5 playgrounds, 6 images

| Playground | Image | Notes |
|---|---|---|
| Dev Machine | `dev-machine-rootfs` | Full workstation, ~40 tools. Primary daily machine. |
| Jenkins Server | `jenkins-rootfs` | Launchable alone |
| SonarQube Server | `sonarqube-rootfs` | Launchable alone |
| Nexus Server | `nexus-rootfs` | Launchable alone |
| CI/CD Stack | 4 images | jenkins + sonarqube + nexus + `dev-cicd-rootfs` |

| Image | Role |
|---|---|
| `ubuntu-24-04-rootfs` | Shared base. Not a playground. |
| `dev-machine-rootfs` | Full workstation |
| `dev-cicd-rootfs` | **Minimal jump host.** No installs, no services. Only inside the CI/CD Stack. **Not the Dev Machine.** |
| `jenkins-rootfs` / `sonarqube-rootfs` / `nexus-rootfs` | Service machines |

**Root of the confusion:** in `cicd-stack.yml` the jump host node is *named* `dev-machine` but its
drive is `dev-cicd-rootfs`. Never call it a workstation.

---

## 3. VERIFIED PLATFORM FACTS

Checked against labs.iximiuz.com/pricing and /docs on 2026-07-29.

**Free tier, verified by testing (2026-07-29):** all five playgrounds run on a free account.
**Sessions up to 60 minutes.** The in-app banner mentions reduced resources and limited internet
access, but testing showed the playgrounds run.

**Open: which "one at a time" is it.** Testing showed one playground at a time, destroy before
starting another. The official docs say "Free-tier accounts can have one **custom** playground at a
time", which limits how many you can *own*, not how many can run. Those are different constraints
and Post 2's first comment states the session reading. Confirm before publishing.

**RULE: no free-tier caveats in any post except the platform post (Post 2).** Hedging language such
as "enough to look around, not enough to work" creates doubt and makes a reader unsure whether a
problem is theirs or the platform's. Tier detail belongs only where the platform is the subject.

**Premium:** 5 concurrent playgrounds, up to 24h per playground, unlimited daily playtime, Persistent
Volumes and Custom Playgrounds, 100GB persistent drives, Pro Creator and Trainer modes.

### RULE: never present the manifest as the way to customise

The manifest was used **once**, to publish the playground via `labctl`. Nobody else needs it.

The playground page gives every visitor three actions: **START PLAYGROUND**, **CLONE AND SHARE**,
and **CONFIGURE**. Someone who wants different resources clicks Configure. Someone who wants their
own copy clicks Clone and Share. No YAML involved.

Framing it as "edit the manifest" is both misleading and higher friction than the truth. Link the
manifest only as a source reference for how the layout is defined, never as an instruction.

### RESOLVED: resource model

The three sources were never in conflict. They describe two different caps, and both exist.
From the official [manifest reference](https://labs.iximiuz.com/docs/custom-playgrounds/manifest-reference):

| | Per VM | Per playground |
|---|---|---|
| Free tier | 2 vCPU / 4 GiB | 5 vCPU / 8 GiB |
| Paid | 4 vCPU / 10 GiB | 10 vCPU / 16 GiB |

The pricing page quotes the per-VM figure, the runbook quotes the per-playground pool, and
`cicd-stack.yml` spends exactly the paid per-playground budget. Everything lines up.

The detail worth more than the numbers: requests over budget are **scaled down proportionally, not
rejected**. The playground starts, quietly smaller than asked for. On a free account the four-machine
stack halves, SonarQube drops to roughly 3 GiB, and Elasticsearch never finishes starting. Nothing
errors. That is a far better hook than a table of limits.

**Posts still say only "up to five machines in one playground and you decide how to split
resources."** Not because the numbers are unknown now, but because quoting them dates the post the
day pricing changes.

### Platform capabilities, and which are unused

| Capability | Used? |
|---|---|
| Custom rootfs images from a Dockerfile | Yes, heavily |
| Multi-machine playgrounds | Yes (CI/CD Stack) |
| UI tabs (terminal, IDE, inline app ports, embedded pages) | Yes, all four |
| Sharing and access control | Yes (`canStart: anyone`) |
| Multi-network (subnets, static IPs, air-gapped, multi-homed gateways) | No |
| Multi-drive VMs (extra drives, alt filesystems, raw block devices) | No |
| Init tasks | No, deliberately (see below) |
| Authoring: tutorials, courses, challenges, skill paths | Two tutorials (DebugBox; custom rootfs) |

**Init tasks vs lab-init.sh, resolved.** Platform init tasks "run once per playground instance during
its initialization; they are not re-run after in-session machine reboots." The `lab-init.service`
oneshot sits in `multi-user.target.wants` and runs on **every** boot. That matters: `/run/sshd` and
`/run/nginx` are tmpfs and get wiped on every reboot, so init tasks would leave sshd and nginx dead
after any in-session reboot. Second advantage: the logic lives in the image, not the manifest, so a
fork gets working boot behaviour for free. **The hand-rolled oneshot is correct. Post 6 stands.**

### DO NOT TOUCH: `COPY examiner*` and `examiner.service`

Verified 2026-07-31 against the running platform, after an earlier note in this plan claimed the
opposite. Recording it here so nobody re-derives the wrong conclusion:

- The repo ships no `examiner` binary, so the glob matches nothing. This **does not** fail the build.
  CI has been green throughout.
- Upstream does the same. `iximiuz/labs` `playgrounds/Makefile` copies it with `|| true`, and the
  binary is not in their public repo either.
- The binary is **supplied by the platform at VM boot**. On a running machine,
  `systemctl status examiner.service` shows `active (running)` on `/usr/local/bin/examiner`, and
  `systemctl is-system-running` returns `running`, not `degraded`.
- `set-up-systemd-examiner-service.sh` is therefore a contract, not dead code. It pre-declares and
  pre-enables the unit so systemd can start the agent once the binary lands.
- The agent is what runs init tasks and reports their status, which backs `labctl playground tasks`
  and tutorial or challenge task verification.

Removing either line, or adding `ConditionPathExists` to that unit, risks breaking init tasks on
every image built from the base.

**Biggest unexploited opportunity:** the authoring surface. Challenges and tutorials built on his own
playgrounds are a larger content play than posts alone. Out of scope for this phase; revisit after.

### Timeline

Registered 7 Aug 2025 during CKA prep. Passed CKA and CKAD Nov 2025. Lifetime premium after that.
~12 months on the platform, ~8 months building. 441 playgrounds, 116,900 minutes (just under 2,000
hours in about a year). **Never say "two years."**

---

## 4. MENTION STRATEGY

| # | Post | iximiuz Labs | Ivan Velichko | Why |
|---|---|---|---|---|
| 1 | Launch | Body | No | Explains how ninety seconds is possible. Naming him on post one reads as an opening bid. |
| 2 | Platform | Body, throughout | **Body, closing** | The post is genuinely about the platform. A closing credit after 400 words of substance is normal, not an ask. Highest repost potential, and at position 2 a repost lifts four later posts. |
| 3 | Dev Machine | Body, one clause | No | Needed to say where it launches. |
| 4 | CI/CD Stack | Body, one clause | No | Reader's problem stays the subject. |
| 5 | Tunnel | Body | **First comment** | Network model is the story's setup. His mention is a fact: he saw it and suggested writing it up. Second and final named mention, three posts after the first. |
| 6 | Rootfs | Body, prominent | No | Strongest custom-rootfs showcase. A third named mention would look like a campaign. |

**Framing rule, tunnel post:** the shared NAT gateway is how microVM isolation is designed, not a flaw.

**Mention spacing:** two named mentions across six posts, at positions 2 and 5. Far enough apart to
read as natural rather than as a sequence of asks.

---

## 5. THE POSTS

### #3 (global) · Post 1 of 6 — `ss-01-launch` · VALUE-FIRST (product front door)
**Asset:** screenshot grid of the five playground cards from the author profile.

You can launch Jenkins, SonarQube and Nexus, already wired together and talking to each other, in about ninety seconds.

No installs. No cloud account. A browser tab.

That is one of five playgrounds I have published as SilverStack, an open project of mine. I package complete preconfigured machines as custom OCI images and publish them on iximiuz Labs, which boots each one as a Firecracker microVM. Real machines with systemd, not containers.

The other four: a Dev Machine with around 40 tools preinstalled, which is the one I work from daily, plus Jenkins, SonarQube and Nexus each standing alone.

Every one boots with everything installed and running. The installing happened at image build time, so nothing is waiting for you.

All three service images ship with a Cloudflare Tunnel client, so each can go live on its own subdomain with valid TLS minutes after launch. No public IP, no inbound ports.

Each image is a Dockerfile in a public repo, MIT licensed. Read it, fork it, change the tools, publish your own.

Post 1 of 6.

If you launch one and hit something broken, tell me here and I will fix it. That is the most useful thing anyone can send me right now.

**First comment:**

All five: https://labs.iximiuz.com/a/ibtisam-iq

Source, every Dockerfile behind them: https://github.com/ibtisam-iq/silver-stack
Images: https://github.com/ibtisam-iq?tab=packages
Build documentation: https://runbook.ibtisam-iq.com/containers/iximiuz/

The CI/CD Stack is the one most people want. Four machines, everything talking to each other on boot. The standalone servers are Jenkins LTS behind Nginx under systemd, SonarQube CE with PostgreSQL already provisioned, and Nexus 3 for Maven, npm and Docker artifacts.

Under those five playgrounds sit six images, including a shared Ubuntu 24.04 base that everything else builds on. I add a new one whenever I need it. Building a machine once as an image and launching it whenever I want has turned out cheaper than rebuilding it each time.

If you want different machine sizes, the playground page has a Configure button, and Clone and Share gives you your own copy to keep. Nothing to install locally either way.

---

### #4 (global) · Post 2 of 6 — `ss-06-platform` · CREDIBILITY (platform origin + thanks)
**Asset:** usage statistics panel (441 playgrounds, 116.9K minutes) beside the author page showing five published playgrounds. Consumer and contributor in one frame.

Last August I clicked a link in the Kubernetes documentation.

Since then I have started 441 playgrounds there and logged 116,900 minutes. Just under 2,000 hours, in about a year.

The site is iximiuz Labs. It appears in the "Before you begin" section of the official Kubernetes docs.

I was preparing for CKA. Passed that, then CKAD, and expected it to end there.

It did not, because what kept me was never the exam scenarios. Every playground is a real Firecracker microVM: systemd as PID 1, Docker running properly, networking you can break and repair.

Then I found the feature that changed things. You can supply your own root filesystem as an OCI image, and the platform boots it as a VM.

That turned it from somewhere I practise into somewhere I publish. Every project in my portfolio since has been built there. Not demoed there, built there.

Post 2 of 6 on SilverStack.

If you already use it, tell me what you have built. I do not think many people realise they can publish playgrounds of their own.

Ivan Velichko, thank you for building it. The best way I know to say that is to keep publishing things people can actually run.

**First comment:**

My playgrounds: https://labs.iximiuz.com/a/ibtisam-iq
The platform: https://labs.iximiuz.com

All six images and every manifest behind them: https://github.com/ibtisam-iq/silver-stack
Build documentation for each: https://runbook.ibtisam-iq.com/containers/iximiuz/

Going from user to author was not something I planned. The platform made the step small enough that it happened on its own.

The workstation I work from daily is one of my own images, and so is the four-machine CI/CD stack I test pipelines on. The authoring tools are open to anyone on premium.

There are now five playgrounds published under my name as part of SilverStack: the workstation, standalone Jenkins, SonarQube and Nexus servers, and the full stack. Every one is a public Dockerfile anyone can read or fork. You can put up to five machines in one playground and decide how to split resources between them.

I bootstrap a kubeadm cluster from scratch with my own bash script and run it there, which is not something a browser terminal usually lets you do. I have paid for a lot of tools this year and forgotten most of them. This one changed where I do my work, and then handed me a way to give that work to other people.

The pattern repeats for anything. Pick a tool, write the Dockerfile, publish the image, and it becomes a playground anyone can launch.

The custom rootfs feature is what I would point anyone at first. Most browser lab platforms give you a fixed image and a terminal. Here you bring your own machine, and once you have built one image the same pattern works for every tool after it.

If you are starting out: a free account runs all of these. You get one playground at a time and sessions up to an hour, which is plenty to look around. Premium is what you want once you are building rather than browsing.

---

### #5 (global) · Post 3 of 6 — `ss-02-devmachine` · VALUE-FIRST
**Asset:** welcome banner screenshot showing the full tool list and aliases. Body deliberately does not repeat the whole inventory.

Most of my work does not happen on my Mac anymore.

It happens on a Linux machine I built and published, which boots in a browser with everything already installed.

It is the Dev Machine in SilverStack, an open project of mine: complete preconfigured machines, published as playgrounds on iximiuz Labs.

Around 40 tools are already on PATH: Kubernetes, containers, infrastructure, security scanners, the usual runtimes. Full list is in the screenshot. Aliases and completions are wired, so k, d and tf behave exactly like the commands they stand for.

It boots as a real VM, not a container. Docker inside it is a genuine daemon, systemctl works, and I bootstrap a full kubeadm cluster here with my own script.

This is not a throwaway sandbox. Sessions run up to 24 hours and the disk persists, so the machine I come back to on Wednesday is the one I left on Tuesday. That is what makes it a daily driver rather than a demo.

The Dockerfile is public, so you can fork it and build a version with your own toolset.

Post 3 of 6 on SilverStack.

If there is a tool you would expect on a machine like this and it is not there, tell me. I add the things people actually ask for.

**First comment:**

Launch it: https://labs.iximiuz.com/playgrounds/SilverStack-dev-machine-e672bcf7

Blog: https://blog.ibtisam-iq.com/dev-machine-workstation-image

The full inventory: Kubernetes (kubectl, helm, kustomize, k9s, stern, kubectx), containers (Docker, buildx, skopeo, dive, hadolint), infrastructure (Terraform, Ansible, AWS CLI v2), security scanners (Trivy, gitleaks, cosign, syft).

It is where I do my Kubernetes work, test infrastructure changes, and run the things I used to run locally. I keep adding tools as my work changes, and every addition ships to everyone who launches it.

Dockerfile and install scripts, if you want to build your own version:
https://github.com/ibtisam-iq/silver-stack/tree/main/iximiuz/rootfs/dev/machine

Image: ghcr.io/ibtisam-iq/dev-machine-rootfs:latest
Full writeup: https://runbook.ibtisam-iq.com/containers/iximiuz/rootfs/setup-dev-machine-rootfs-image

It builds on a shared Ubuntu 24.04 base image that all the other SilverStack machines use too, so anything I add to the base shows up everywhere.

---

### #6 (global) · Post 4 of 6 — `ss-03-stack` · VALUE-FIRST
**Asset:** running playground screenshot with the tab bar visible (IDE, four terminals, three service UIs).

Jenkins, SonarQube and Nexus, already wired to each other, running in your browser in about a minute.

That is the new CI/CD Stack playground in SilverStack, an open project of mine: complete preconfigured machines, published on iximiuz Labs for anyone to launch in a browser.

Four machines come up on a shared private network. Each service on its own server, plus a small jump host to SSH between them and drive the stack.

Everything is running when you arrive. No installs, no database setup. Sessions last up to 24 hours and the disk persists, so the credentials and pipelines you set up are still there next time.

Each service ships with a Cloudflare Tunnel client, so you can put it on your own subdomain, jenkins.yourdomain.com with a real certificate, in about two minutes. That is not cosmetic. The SonarQube webhook that reports a quality gate back to Jenkins needs a URL it can actually reach, and localhost is not one.

You can also launch Jenkins, SonarQube or Nexus on its own if that is all you need.

Post 4 of 6 on SilverStack.

If you are setting up self-hosted CI right now, tell me which of the three gave you the most trouble. I have hit most of the failure modes and the fixes are written up.

**First comment:**

Full stack: https://labs.iximiuz.com/playgrounds/SilverStack-CICD-Stack-1766a8a1

Individually:
Jenkins https://labs.iximiuz.com/playgrounds/SilverStack-jenkins-server-63fe430c
SonarQube https://labs.iximiuz.com/playgrounds/SilverStack-sonarqube-server-7761f36f
Nexus https://labs.iximiuz.com/playgrounds/SilverStack-nexus-server-9a3f87e9

The full write-up on how the four machines are composed, how a fixed 10 vCPU / 16 GiB / 150 GiB budget was allocated, and why the JVM heaps are sized the way they are:
https://blog.ibtisam-iq.com/self-hosted-cicd-lab-jenkins-sonarqube-nexus/

Setup guide covering credentials, the SonarQube webhook and the Nexus Docker registry:
https://runbook.ibtisam-iq.com/self-hosted/ci-cd/iximiuz/cicd-stack-operations/

Two commands finish the setup when you want them, both already on PATH when you land. install-pipeline-tools puts the build toolchain on the Jenkins machine: Maven, Node, Python, Docker, Trivy, kubectl, Helm, Terraform, Ansible and the AWS CLI. install-plugins adds the Jenkins plugin set. Neither is baked into the image, which keeps it lean and lets you skip what you do not need. The Jenkins image documents what each one installs:
https://runbook.ibtisam-iq.com/containers/iximiuz/rootfs/setup-jenkins-rootfs-image

Once those are on, you can run a pipeline that builds real code, fails a build on a SonarQube quality gate, publishes a JAR to Nexus and pushes an image to a registry. Then break it deliberately and watch what happens. That last part is the hard one to get anywhere else: you cannot practise breaking a shared company Jenkins.

The jump host is deliberately minimal. It is not the full Dev Machine, it exists to drive the other three.

Want the machines sized differently? The playground page has a Configure button, and Clone and Share gives you your own copy to keep.

One note if you resize it: SonarQube runs an embedded Elasticsearch alongside PostgreSQL in a single VM, so it needs the most RAM of the four. Give it too little and it gets OOM-killed about two minutes into startup.

---

### #7 (global) · Post 5 of 6 — `ss-04-tunnel` · HYBRID
**Asset:** two-panel diagram. Left: inbound request stopping at the NAT gateway, machines greyed out behind it. Right: outbound connection held open to Cloudflare, request flowing back down it. The live URLs in the first comment carry the proof, so this asset should carry the explanation instead. Worth building properly.

I ran curl ifconfig.me on four different servers.

The same address came back four times.

They run on iximiuz Labs as SilverStack playgrounds, and a playground is a group of microVMs behind one NAT gateway. There is no inbound route to any individual machine. I still needed jenkins.ibtisam-iq.com reachable, with a valid TLS certificate.

This is not specific to that platform. Behind CGNAT, on a home connection, or on most managed hosting, you do not get a routable address either.

That rules out the standard options:

Every name resolves to the same address
Port forwarding needs a gateway you do not control
Certbot's HTTP-01 challenge needs Let's Encrypt to reach your port 80
Self-signed certificates work, then warn every visitor

The assumption underneath all four is that traffic has to arrive at your server. It does not.

Cloudflare Tunnel reverses the direction. A daemon opens an outbound connection to Cloudflare's edge and holds it open, and outbound passes through NAT by default because that is what NAT is for. Requests to your domain reach the edge, match that connection, and come back down it. TLS terminates at the edge, so Certbot never enters the picture.

Your own subdomain, a real certificate, zero inbound ports. Every SilverStack image ships with the daemon preinstalled.

Post 5 of 6 on SilverStack.

Have you hit this wall, or have you always had a routable IP to point at?

**First comment:**

The full write-up: the EC2 setup this replaced, all five approaches that failed, why the tunnel points at Nginx rather than the service port, and what the security posture actually becomes:
https://blog.ibtisam-iq.com/cloudflare-tunnel-no-public-ip/

If you would rather see the result than take my word for it, all three are live right now:

https://jenkins.ibtisam-iq.com
https://sonar.ibtisam-iq.com
https://nexus.ibtisam-iq.com

You will hit a login page on each, which is the point. Valid certificate, my domain, and the machine behind it has no public IP and no inbound ports open at all.

Ivan Velichko, who builds iximiuz Labs, saw this running on the platform and suggested I write it up properly. This is that writeup.

The same technique works for a home lab, a Raspberry Pi, or anything behind a network you do not control. You paste one token and pick a hostname. Dynamic DNS is the other option people reach for, and it still needs a routable IP per machine, so it fails here for the same reason. I went with Cloudflare Tunnel for the free custom domains and managed TLS, but I am curious what has held up for other people over time.

Two implementation notes worth having:

Point the tunnel at localhost:80 (Nginx), not the service port directly. You keep request buffering, access logs, and a health endpoint that answers even when the app is down. Changing a service port then never touches tunnel config.

Run one tunnel per service rather than one shared tunnel. A token leak or a restart then affects exactly one service.

Launch any of them: https://labs.iximiuz.com/a/ibtisam-iq
Source: https://github.com/ibtisam-iq/silver-stack

---

### #8 (global) · Post 6 of 6 — `ss-05-rootfs` · DEEP-DIVE
**Asset:** annotated code card, the build steps with a one-line reason beside each.

docker run on any of these images fails immediately.

That is the correct behaviour.

Every server in SilverStack is built from a Dockerfile, but none of them is a container image. iximiuz Labs boots each one as a Firecracker microVM and takes the root filesystem as an OCI image, so a Dockerfile goes in and a bootable server comes out.

That sounds like a packaging detail. It is not. A container image and a VM disk have opposite assumptions, and several Docker defaults are actively wrong here.

Baked-in SSH host keys mean every VM from that image shares one identity. The build deletes them; they regenerate per machine at first boot.

/etc/machine-id is emptied, so each VM generates its own systemd identity instead of thousands claiming to be the same host.

Then the opposite problem: /run is tmpfs and gets wiped on reboot, so sshd and Nginx come back with no runtime directories.

The model that made it click:

Bake what is static. Packages, configs, unit files, binaries.
Reconcile what is per-machine or per-boot. Identity, runtime directories, ownership, data.

A single systemd oneshot does the second half, ordered before everything else. That split holds for anything ephemeral, not just this platform.

Post 6 of 6 on SilverStack.

Had you seen a Dockerfile used this way before, or is this new to you?

**First comment:**

The full write-up, covering every anti-container build step, the USER decision, why I did not use the platform's built-in init tasks, and how you test an image that cannot start:
https://blog.ibtisam-iq.com/docker-rootfs-systemd-cicd/

If you would rather build one than read about one, the same material is a hands-on tutorial that runs in a browser playground. You build a deliberately broken rootfs, watch it fail each requirement, fix it, then write a script that proves an image would boot without booting it:
https://labs.iximiuz.com/tutorials/build-custom-rootfs-image-for-microvm-playgrounds-d1d0eba9

/.dockerenv is removed too, or systemd detects a container and quietly changes its behaviour. There is no CMD or ENTRYPOINT on the base image either: the platform boots the filesystem with its own kernel, so anything set there just fights it.

Six images, all public, all MIT, rebuilt by GitHub Actions on every push. A shared Ubuntu 24.04 base, then one image per machine on top of it.

Ownership on the mounted filesystem also resets, so Jenkins cannot write to a home directory it no longer owns. The oneshot regenerates the host keys, creates the runtime directories, fixes ownership, then exits. The real services start after it.

There is very little written about this category and most of what I learned came from failing at it.

The base image Dockerfile, with everything above:
https://github.com/ibtisam-iq/silver-stack/blob/main/iximiuz/rootfs/ubuntu/Dockerfile

Full writeup: https://runbook.ibtisam-iq.com/containers/iximiuz/rootfs/setup-ubuntu-24-04-rootfs-base-image

The platform does have a built-in init tasks feature and I did look at it. It runs once per playground instance and is not re-run after an in-session reboot, which does not work here: /run is tmpfs, so sshd and Nginx would come back dead after any reboot. A systemd oneshot runs on every boot, and living in the image rather than the manifest means a fork gets the same behaviour for free.

One decision that took me a while: the workstation image ends as the non-root user, the service images end as root. That looks inconsistent but is not. USER is an OCI config field that only docker run reads, and the microVM boot ignores it entirely. Ending the workstation image as the non-root user means a local binary check runs as the user who will actually use those tools, so anything installed where only root can reach it fails loudly instead of passing silently.

Five playgrounds built on these six images: https://labs.iximiuz.com/a/ibtisam-iq

---

## 5b. TUTORIAL LAUNCH (outside the six)

The rootfs tutorial on iximiuz Labs is **not numbered into this series**. It is teaching content, not a
playground you launch, and "Post 7 of 6" reads as padding. Post 6's first comment already links it,
which is the right amount of connection.

Live: https://labs.iximiuz.com/tutorials/build-custom-rootfs-image-for-microvm-playgrounds-d1d0eba9

### What Post 2 taught us about reach

Post 2 (`ss-06-platform`) shipped and did roughly an order of magnitude better than baseline:

| | Post 2 | Typical post |
|---|---|---|
| Reactions | 31 | 3 to 4 |
| Comments | 3 | 0 |
| Reposts | 4 | 0 |
| Impressions | 1,552 | not tracked |

Ivan Velichko commented: "It was an incredibly heartwarming read for me."

**The mechanism was not the mention.** It was handing someone with the right audience a reason to
amplify. The current following is mostly students and learners; Ivan's is DevOps engineers. Borrowed
reach is doing the work. Design for that, not for the existing follower count.

**Corollary, and it is a hard rule: do not tag Ivan again on the tutorial post.** He engaged a week
ago. Section 4 already caps this at two named mentions across the whole series because a third reads
as a campaign. A tutorial published on his platform is a contribution rather than praise, so it is
more resharable than the thank-you was and needs no tag at all.

### Audience read: why D ships and C waits

Two drafts exist. They are aimed at different audiences and only one of those audiences is currently
following the account.

| | Version D | Version C |
|---|---|---|
| Hook | You can publish on these platforms | My validation script had three bugs |
| Speaks to | Learners, the audience that exists today | Senior engineers, the audience wanted |
| Closing question | Answerable by anyone | Answerable only by people who write test code |
| Gives Ivan a reason | Yes, raises the underused authoring surface | Indirectly |
| Ship | Now | Two to three months out |

C is not weaker writing. It is mistimed. Once Ivan's audience has pulled senior engineers into the
following, C is the post that converts them, because it proves debugging rather than assembly.

---

### Version D (SHIP THIS) - `tut-01-authoring` - ACCESSIBLE

**Asset:** none needed. The tutorial page's own cover carries it if a preview unfurls.

**Status 2026-08-11: cleared to ship.** Catalogued after review. Profile verified live: 2 tutorials,
5 playgrounds at https://labs.iximiuz.com/a/ibtisam-iq

**Revision 2026-08-11, round 3. Two corrections to my own drafts, both mine to own.**

> **The post is a launch, not an explainer.** Round 2 turned the author's background story into
> content: public URL versus catalog, submit for review, three rounds. That is how the platform
> works, and it belongs in nobody's feed. The context of this post is one thing only: **a second
> tutorial is live.** The review experience is why it means something, so it gets one beat of
> feeling, not three paragraphs of process.
>
> **Ivan is named, in prose, once.** Round 2 refused this on the grounds that section 4 caps named
> mentions. That conflated **tagging** with **naming**. An @-mention notifies and reads as summoning;
> a name in a sentence is credit, and credit is the whole point of the paragraph. Withholding it
> made the gratitude anonymous, which is worse than absent.
>
> **Still holds: do not @-tag him.** He has surfaced and engaged on the last two posts unprompted.
> A prose name gives him the credit; a tag turns the credit into a request.
>
> **Still holds: do not quote the Discord message.** Private correspondence. Describe, do not quote.
>
> **No closing question, deliberately.** DebugBox Post 2 is the only tutorial announcement with real
> data (2,361 impressions, the best of five) and it ends on a statement. The two posts that ended on
> questions did 748 and 638. Not conclusive, but the proven shape ends flat.
>
> **Round 4 corrections, author-supplied, all accepted:**
> 1. **Two rounds, not three.** Tutorial 1: Ivan said solid but improve it; author improved it; Ivan
>    asked for prerequisites and images; author added them; Ivan then published it. Two rounds.
> 2. **"before it went out" was wrong.** The gate is the **catalog**, not publication. A tutorial is
>    publicly reachable at its own URL the moment you write it. Review is what gets it listed under
>    your name. That is the technically correct framing and it is also the more surprising one.
> 3. **"Cut this claim" removed.** Unverified. Prerequisites and diagrams are confirmed; that was
>    my invention.
> 4. **Tutorial 2 reverses the sequence, and that is the better story.** He read it end to end,
>    published it to the catalog, and *then* sent two further suggestions. Review did not stop at the
>    gate. The paragraph now carries both halves.
>
> **Round 10, author-caught: "Ivan Velichko" was unidentified.** A cold reader had no idea who he
> was, which collapsed the paragraph: unattributed, it reads as a random reviewer sending notes.
> Identified, it is the point, because the person who built the platform reads community submissions
> himself. **Term verified on the site, which says "created by Ivan Velichko" and "the creator of
> iximiuz Labs", so "created the platform" rather than the assumed "founder".** The about page also
> says the project sustains "a single creator", i.e. he runs it solo, which is a stronger detail
> still, but it was left out: characterising someone else's business finances in a public post is not
> the author's to do, and "created the platform" already carries the weight.
>
> **Round 9, author-caught: the announcement was orphaned.** Cutting the connective in round 8 was
> right on the word, wrong on the structure: it left "My second tutorial is live" as a lone paragraph
> sitting between the opening claim and "You build both", which reaches back to that claim. The
> announcement was interrupting a sentence pair. Fixed with no new words by merging it into the
> paragraph it introduces, where it works as the topic sentence.
>
> **Round 8, author-caught: "and that is what it teaches" CUT.** The author was reluctant to use
> "teach" and was right twice over. It claims the instructor role two lines above a paragraph
> admitting he did not think he had earned it yet, and it describes what the material does to a
> passive reader when the tutorial is something you build. Rather than swap the verb, the clause went
> entirely: the next paragraph opens "You build both", which reaches back to the two artifacts on its
> own. Third connective in a row that turned out to be doing no work. Pattern worth remembering.
>
> **Round 7, author-caught: "One runs. Only one is a machine." REPLACED with "Docker runs both.
> Only one will boot."** The old line was not merely weak, it was false: both images run, and the
> tutorial itself does `docker run` against `bootable-rootfs:v1`. It also had an ambiguous antecedent
> on the second "one", and "is a machine" is metaphor for something an image only becomes once a
> kernel boots it. In a post whose subject is rigorous review, a loose claim in sentence three is the
> costliest possible place to be loose. The replacement is drawn from the tutorial's own opening and
> is sharper: conceding that both run makes booting the real surprise.
>
> **Round 6, author-caught: "It teaches something that cost me real time to understand:" CUT, and
> the opening reordered.** The phrase was throat-clearing in front of the strongest line in the post.
> Removing it exposed a second problem: LinkedIn truncates after the first line or two, so the fold
> was showing an announcement plus a preamble. DebugBox Post 2, the only tutorial announcement with
> real numbers (2,361 impressions), opened on a claim and announced second. The post now does the
> same. The announcement still lands in line 3, so it remains a launch post, not an essay.
>
> **Certifications confirmed by the author: CKA and CKAD.**
>
> **Round 5, author-caught: "That changed how I write. When you know someone will check, you stop
> guessing and start verifying." CUT.** It only parses if the absence of a reviewer means guessing,
> which retroactively indicts the blog, the runbooks, and every public repo. It is also a platitude,
> and it explains a feeling the thesis line already delivers. Removing it makes the thesis line the
> last word on the review, which is where the beat wanted to end anyway.
>
> **No universal claim about the platform.** The site says community content is reviewed "on a best
> effort basis", so the post states the author's own experience, not a guarantee about everyone's.

A container image and a bootable root filesystem are not the same artifact. Both are OCI images. Docker runs both. Only one will boot.

My second tutorial on iximiuz Labs is live. You build both from the same Dockerfile, in a browser, and watch exactly where they split. Five checkpoints verify your work as you go. Those playgrounds are Firecracker microVMs, so the same requirements hold if you are preparing a rootfs for your own.

What I actually want to say is less about the tutorial.

I have published in a lot of places. This is the only one where someone read what I wrote.

A tutorial there is publicly reachable the moment you write it. Getting it into the catalog, listed under your name, meant getting read first. My first one took two rounds of notes. Add a prerequisites section. Add diagrams. Ivan Velichko, who created the platform, read this second one end to end, published it, then sent two more suggestions anyway.

The last time my work was read that closely, I was writing a thesis.

I did not publish here on day one, and I could have. I waited until I had passed CKA and CKAD and built five playgrounds, because I did not think I had earned it yet. That was probably too cautious. If you have been learning in public, this is just the next step.

Free to run in a browser, nothing installed locally. Link in the first comment.

**First comment** (links first, because LinkedIn collapses a comment after the first two lines):

The tutorial: https://labs.iximiuz.com/tutorials/build-custom-rootfs-image-for-microvm-playgrounds-d1d0eba9

My first one, on Kubernetes debugging: https://labs.iximiuz.com/tutorials/kubernetes-debugging-with-debugbox-74e481c8

Everything I have published there: https://labs.iximiuz.com/a/ibtisam-iq

Want to publish your own? https://labs.iximiuz.com/docs/content-authoring

The rootfs one needs no account beyond the platform itself: no registry, no labctl, no cloud.

---

### Version C (HOLD) - `tut-02-wrongcheck` - TECHNICAL

**Asset:** the "what each probe can see" diagram from the tutorial, or the three-failure validate.sh output.

**Still HOLD.** Ship two to three months out, once Version D and the platform posts have pulled senior
engineers into the following. The reasoning in the audience table above is unchanged.

**Upgraded 2026-08-11 by back-porting the ten rounds of corrections applied to Version D.** C had four
of the same faults and had never been revisited:

> 1. **Unidentified platform.** "the platform's own reference image" in paragraph 2, with iximiuz Labs
>    not named until paragraph 8. Same fault as the unidentified "Ivan Velichko" in D and the unnamed
>    "my open source project" in DebugBox Post 4. The platform is now named where it is first used.
> 2. **Closing question cut.** "Have you had a test pass for the wrong reason?" sat immediately after
>    "When your check fails the reference implementation, the check is what is broken", which is the
>    best line in the post. The question stepped on the closer. DebugBox Post 2, the only tutorial
>    announcement with real data, ended on a statement; the two that ended on questions did 748 and
>    638. Ends flat now.
> 3. **First comment reordered to links-first.** All four links were not at the top; two sat under a
>    prose block, below the point where LinkedIn collapses a comment.
> 4. **Connective trimmed.** "That whole sequence is now" became "That is now". Fourth dead connective
>    found across the two posts.
>
> **Added:** the profile link, which now proves the claim at 2 tutorials and 5 playgrounds.
> **Kept deliberately:** the `silver-stack` repo link, dropped from D as off-topic but correct here,
> since C's audience is the one that opens source. And "my script was wrong" stays. It is
> self-critical about one named script, which is the subject of the post, not a blanket claim about
> the author's work like the line cut from D in round 5.
>
> **Overlap check.** C and D both point at the same tutorial. The two to three month gap is what keeps
> that from becoming the DebugBox Post 1 / Post 3 near-duplicate failure. Do not shorten it. The posts
> are genuinely different arguments, assembly versus debugging, but only distance makes that legible.

I wrote a script to validate my container images before publishing them. It passed everything I built.

Then I pointed it at the reference image published by iximiuz Labs.

Two checks failed.

The image was fine. My script was wrong, in two different ways, and a third turned up when I pointed it at one more image.

One check demanded that sshd be enabled as a service. The reference image uses socket activation instead. Both are correct.

One demanded an exactly empty machine-id. The reference image writes a single newline. systemd treats those identically.

One hardcoded a username, which no assertion can ever get right, because the answer legitimately differs per image.

Every one of them stayed invisible while the script only ever saw images written by the person who wrote the script.

That is now a hands-on tutorial there. You build the image, write the script, then break it against two real published images and repair it.

When your check fails the reference implementation, the check is what is broken.

**First comment** (links first, because LinkedIn collapses a comment after the first two lines):

The tutorial, five verified checkpoints, runs in a browser: https://labs.iximiuz.com/tutorials/build-custom-rootfs-image-for-microvm-playgrounds-d1d0eba9

Everything I have published there: https://labs.iximiuz.com/a/ibtisam-iq

Long-form write-up: https://blog.ibtisam-iq.com/docker-rootfs-systemd-cicd/

Source, all six images: https://github.com/ibtisam-iq/silver-stack

The three repairs are worth separating, because they are not the same shape. Socket activation versus service unit: two valid mechanisms, so the check widened to accept both. The machine-id: two valid encodings of one state, so the check tests the state instead. The username: no universal answer at all, so it became a parameter.

Reaching for a parameter first is the common mistake. It works, and it quietly pushes the thinking onto whoever runs the script.

---

## 6. SEQUENCE AND RATIONALE

```
1  Launch          VALUE        what it is, that you can use it
2  Platform        CREDIBILITY  a year of context, the thanks, where it all runs
3  Dev Machine     VALUE        easiest use case, broadest reach
4  CI/CD Stack     VALUE        highest-utility use case
5  Tunnel          HYBRID       value hook, real engineering underneath
6  Rootfs          DEEP         the depth proof, now earned
```

Post 1 shows the work. Post 2 explains the ground it stands on and carries the highest repost
potential, which at position 2 lifts the four posts after it. Posts 3 and 4 are the use cases that
build reach. Posts 5 and 6 carry the engineering depth that converts for peers and hiring managers.

Cadence: 2 per week, Tuesday and Thursday, about three weeks. Do not publish Post 2 standalone before
Post 1 exists, since its SilverStack mention points at nothing a reader can follow.

---

## 7. PRE-PUBLISH BLOCKERS

1. "Production-grade" in all five public manifest descriptions. Post 1 sends people straight there.
2. Confirm the free-tier limit wording (owned custom playgrounds vs concurrent sessions). See
   Section 3. Post 2's first comment currently states it as a session limit.

### Cleared since v5

**`COPY examiner*` does not fail a clean rebuild.** This was wrong, and acting on it would have
caused an outage. Builds have been green throughout, the binary is supplied by the platform at VM
boot, and the unit that starts it is what makes init tasks work. Full detail in Section 3. Do not
"fix" that line or the service it enables.

**Resource model is settled.** Both caps exist; see the table in Section 3. Posts still quote no
numbers, for a different reason (they date the post).

**Blog `networking/001` + `002` merge does not apply.** `002` is the frontend serving and Nginx
reverse proxy post, a different subject. Nothing to merge.

**Blog `containers/003` is expanded**, and it is linked from Post 6, not Post 5.

---

## 8. AFTER THIS PHASE

The authoring surface remains the largest under-exploited opportunity: courses, challenges and
skill paths built on his own playgrounds. Two tutorials now exist (DebugBox, and the custom rootfs
build which is the hands-on companion to Post 6). A challenge series running
on the CI/CD Stack would be a bigger content play than posts alone. Revisit once this phase ships.
