# Phases 4 to 6: Deployment, GitOps, and Close (FINAL v2)

> **Created:** 2026-08-02 · **Rebuilt after full source read:** 2026-08-02 (v2)
> **Consolidated:** 2026-08-03 (v3) — 28 blogs cut to 22
> **Status:** Final. Copy-paste ready. Full bodies below.
> **Count:** 10 LinkedIn posts (global positions 12 to 21) + **22 blog posts**
> **Cadence:** 2/week (Tue + Thu), ~5 weeks
> **Formatting:** no em dashes, no backticks, no angle-bracket notation
> **Blog companions: 22 LIVE, 4 ARCHIVED, 2 MERGED.** Phases 4, 5 and 6 are 10, 8 and 4.
> Every LinkedIn post has its companion. Posts 13, 14, 16 and 18 are **gated** and all four are unblocked.
> **First comments verified 2026-08-03:** all 24 blog URLs referenced across the plans resolve to live slugs; #17 now links `eks-cluster-addons`.
> See `blog-companion-index.md` for the full map and publish order.

> **Supersedes** the Phase 4, 5 and 6 entries in `linkedin-publishing-plan.md`
> (Series 4 to 8 and the Standalone block). Those are kept there for history.

## v1 TO v2: WHAT THE FULL SOURCE READ CHANGED

v1 of this plan was built on roughly a quarter of the provided material. A complete read
of all 330 KB found three things v1 could not have known.

**1. An entire content area assigned to nothing.** `systems/java-monolith/docs/cert-manager/`
and `docs/tls/` hold ~68 KB of original, dated, first-person troubleshooting on getting
Let's Encrypt to issue certificates on a NAT'd bare-metal cluster. Four-layer debugging chain
(per-Gateway NGF Service, iptables hairpin on PREROUTING and OUTPUT, CoreDNS host override,
forced ACME re-order), a second document solving the same problem with the Ingress solver and
`hostNetwork`, and a third comparing three approaches with a decision matrix. This is now
**LinkedIn post 14 plus four blogs**, and DNS-01 is a genuinely distinct third NAT story
against Phase 2's tunnel post.

**2. Two bodies collapsed to one slot each.** 52 KB of authored Ingress vs Gateway API
networking guides, and 19,410 words of retail service and Helm chart anatomy including
`_helpers.tpl` internals and full `helm install` walkthroughs. Each is now several blogs.

**3. A cross-cutting theme visible only when the material is read together.** Ten instances
across five projects of the same failure mode: **configuration accepted and not applied.**

| Project | What failed silently |
|---|---|
| Java CI | Spring Boot BOM ignores property keys it does not expose |
| Java CD | Kustomize `newTag: latest` overrides the tag CI wrote to `image.env` |
| Java runtime | Spring ignores `X-Forwarded-Proto` without `forward-headers-strategy` |
| Jenkins | Groovy parse-time interpolation renders `null` as a deployable tag |
| Microservices CI | BuildKit zeroes `created`, so `newest-build` ranks a ten-way tie |
| Microservices CD | `allowTags` without a `regexp:` prefix is ignored, not rejected |
| Terraform | EKS module v21 drops the admin bootstrap field when role creation is off |
| EKS auth | `authenticationMode: API` ignores the aws-auth ConfigMap |
| Static site | S3 skips KMS objects without `SourceSelectionCriteria.SseKmsEncryptedObjects` |
| Gateway API | The NGF controller Service is not the data-plane Service |

That is now **LinkedIn post 20**, the capstone, and it is the strongest single idea in the
whole publishing plan because no individual project could have produced it.

---

## THE OPERATING MODEL (unchanged since Phase 3)

**LinkedIn is the discovery layer. The blog and repos are the depth layer.**

- LinkedIn post earns the click. 150 to 200 words, hard ceiling 200.
- First comment routes the reader. All links live here, never in the body.
- Blog carries the full technical argument. 1,400 to 2,200 words.
- Repo holds the raw implementation.

**Every LinkedIn post in this phase set has a one-sentence justification** for why it is
not collapsed into a blog-only article. If that sentence cannot be written honestly, the
item is blog-only. Five placeholder posts failed that test and were demoted.
Two topics found in the v2 full read passed it and were added: posts 14 and 20.

---

## WHAT CHANGED FROM THE PLACEHOLDER PLAN

The old plan had 13 LinkedIn posts across Phases 4 to 6. v1 of this file had 8. v2 has 10,
after the full source read added the TLS material and the capstone. The table below is the
v1 verdict on each placeholder and still stands; the two v2 additions are new topics, not
reinstated placeholders.

| Old post | Verdict | Reason |
|---|---|---|
| 9. Polyglot 1/2, same 3 apps 4 environments | **Cut as LinkedIn, merged into P4-01** | Collides with Phase 3's "One pipeline contract, three ecosystems". Three apps times four environments is a matrix nobody holds in a feed |
| 10. Polyglot 2/2, environment edge cases | **Cut entirely** | All four examples are local and CI-layer problems already owned by Phase 3 blogs B5, B6, B12 |
| 11. BankApp, three compute models | **Kept, promoted to Phase 4 anchor** | Correct the count: four models, not three. Bare-metal Kubernetes is a distinct target |
| 12. Retail, bare-metal and EKS from same charts | **Kept, reframed hard** | "Two environments" undersells ~25 values overlays and a six-rung `orders` ladder |
| 13. Retail, IRSA + serverless + CloudFormation | **Split** | Three unrelated ideas. CloudFormation half moved to P5-03, IRSA half folded into P4-03's blog |
| 14. kubeadm bootstrap script | **Demoted to blog-only** | It is a script. No tension, no failure, no decision to argue about |
| 15. EKS GitOps 1/4, full stack overview | **Cut as standalone** | Pure inventory. Content redistributes into P5-01 and P5-02 openings |
| 16. EKS GitOps 2/4, Terraform SCPs | **Kept, massively expanded** | Was one bullet. Is actually 17 documented errors plus a named module defect |
| 17. EKS GitOps 3/4, matrix dispatch | **Demoted to blog-only** | Partly Phase 3 territory. The new parts are mechanical and read better as an article |
| 18. EKS GitOps 4/4, Gateway API + observability | **Split, cut as LinkedIn** | Three subjects. Becomes two separate blogs |
| 19. Static hosting, $1.45 | **Kept unchanged** | Self-contained, concrete hook, different audience |
| 20. K8s DNS debugging | **Cut, blocked** | No source material exists anywhere in the ecosystem |
| 21. How I work | **Kept as closer** | Unchanged rationale |

---

## SEQUENCE

```
PHASE 4: One Application, Four Ways          (5 posts)
12  Four compute models   VALUE    recruiter-facing breadth anchor
13  The ampersand         ACCESS   widest door in the phase, no stack required
14  ALB debugging chain   HYBRID   strong cold hook                [BLOG GATED]
15  ACME behind NAT       HYBRID   deepest debugging chain in set  [BLOG GATED]
16  Helmfile ladder       VALUE    clonable pattern, surfaces repo

PHASE 5: Ten Services, No Hands              (3 posts)
17  BuildKit epoch        HYBRID   most surprising claim           [BLOG GATED]
18  Push vs pull          HYBRID   highest comment potential
19  Terraform SCPs        DEEP     public contribution             [BLOG GATED]

PHASE 6: Close                               (3 posts)
20  Static hosting        VALUE    different audience, cost hook
21  Silent failures       HYBRID   capstone, only possible now
22  How I work            CLOSING  ties the whole system together
```

Phase 4 establishes deployment breadth before Phase 5 assumes it, and now carries the TLS
material because that work is bare-metal Kubernetes deployment, not GitOps. Phase 5's three
posts are ordered by hook strength descending. Phase 6 changes audience, then lands the
capstone, then closes on methodology.

**Why the capstone sits at 21 and not earlier.** It cites failures from nine posts across
four phases. Published before them it is a list of things the reader has no context for.
Published after, it is a pattern they have already seen four times and can now name.

---

## VOCABULARY (extends the Phase 2 table)

| Thing | Correct word | Never |
|---|---|---|
| EC2, ECS, bare-metal K8s, EKS | **compute models** | environments, platforms |
| A values file selecting a backing store | **overlay** or **rung** | config, profile |
| CI writing a tag to the CD repo | **push handoff** | GitOps (both models are GitOps) |
| A controller polling a registry | **pull handoff** | true GitOps, real GitOps |
| The KodeKloud account restriction | **organisation policy** | SCP (in body copy only; SCP is fine in the blog) |

**Banned in this phase set:** "production-grade" (persona rule, and it is a lab), "seamlessly",
"effortlessly", and any framing that presents a lab constraint as an enterprise achievement.

---

## VERIFIED FACTS (audited against the repos 2026-08-02)

- **Four compute models**, not three: EC2 ASG, ECS Fargate, bare-metal kubeadm, EKS.
- **MySQL in the java-monolith base is a `Deployment`**, not a StatefulSet. The runbook
  says StatefulSet and is wrong. Do not repeat the runbook's wording.
- **`image.env` is written by CI and read by nothing.** All three Kustomize files hardcode
  `newTag: latest`. Java-monolith is applied with `kubectl apply -k`, not ArgoCD.
  **No Phase 4 post may claim the immutable tag reaches that cluster.**
- **Retail on EKS still runs its databases in-cluster** on gp3 PVCs. MySQL, PostgreSQL and
  Redis are all in-cluster. Only cart's DynamoDB and orders' SQS messaging are offloaded.
  `values-redis-aws-elasticache.yaml` exists but is not wired into any helmfile.
- **Retail helmfile scenarios are** `baremetal-persistent`, `baremetal-ephemeral`, `eks`.
  Not "bare-metal, EKS-minimal, EKS-full" as the old plan said.
- **Microservices Trivy gates are all `exit-code: 0`**, documented in-file as a deliberate
  temporary relaxation with a restore condition. Phase 3 already owns this theme.
  **Do not re-tell it here.**
- **Canonical Terraform is `silver-stack/terraform/aws/eks-kodekloud/`.** Two divergent
  copies exist in the CD repo. Link silver-stack only.
- **Image Updater tracks the `latest` tag's digest.** The pod runs `latest@sha256:...`.
  That is still immutable delivery; the digest is the pin.

### Pre-publish blockers

1. ~~Captured AWS identifiers published in the retail and microservices runbooks.~~
   **RESOLVED 2026-08-02.** An access key ID, two account IDs and a hosted zone ID were replaced
   with placeholders across seven runbook files, plus one blog post that had copied them forward.
   Both `aws-infrastructure.md` files now carry an "Account identifiers in this runbook" note
   explaining the placeholder convention and the ephemeral playground context, so the redaction
   does not read as an omission. Canonical's public AMI owner ID was deliberately left intact.
2. "Production-grade" in the microservices-demo README title and body. Same persona
   violation already logged for the iximiuz manifests in Phase 2.
3. Plaintext `password: "orders123"` in `values-06-postgresql-pvc-eks-sqs.yaml`.
4. Stale workflow comments citing "Phase 7 Bug 3" and "Phase 10.3" in the microservices
   runbook, which has 6 phases.
5. Delete or stub the two duplicate Terraform copies in the CD repo.

---

## THE POSTS

### #12 (global) · Phase 4 Post 1 of 5 · `p4-01-four-compute` · VALUE-FIRST

**On LinkedIn because** the four-way comparison is a single claim a stranger can evaluate in
one line, and it is the highest-signal recruiter artifact in the remaining set.

**Asset:** `assets/p4-01-four-compute.svg` **(built, corrected 2026-08-12)**.

> **CORRECTION 2026-08-12, found by reading the two READMEs end to end rather than spot-checking.**
> The body claimed "Same VPC, same security groups, same RDS instance. The only variable was the
> compute layer, which is the only way to compare them honestly." **That is true of two deployments
> out of four**, and it was the sentence the whole post rested on.
>
> `java-monolith-app/README.md` splits the work into two groups explicitly:
> - **Group 1, provisioned via AWS CLI:** EC2 ASG and ECS Fargate, sharing a VPC with NAT gateways,
>   a bastion, and one shared RDS. The claim holds here.
> - **Group 2:** bare-metal kubeadm on an **ephemeral iximiuz Labs dev machine** with no AWS around
>   it, and EKS in a **KodeKloud AWS Lab sandbox**, a separate account provisioned by Terraform.
>
> The database moved too, but **not uniformly, and my first correction overshot**. The runbook's own
> architecture summary (`runbook/projects/deployments/java-monolith/index.md`) is definitive:
> EC2 and ECS both go `ALB -> sg-app -> sg-rds`, bare metal is "In-cluster MySQL", and EKS is
> "ConfigMap patching decoupling state to Amazon RDS (MySQL 8.4)". So **three of four use RDS; only
> bare metal keeps MySQL in the cluster.** An intermediate draft of this post claimed both Kubernetes
> targets ran in-cluster MySQL. That was wrong and is fixed.
>
> The same runbook line calls the bare-metal store a "MySQL StatefulSet". It is a `Deployment`, as
> the VERIFIED FACTS block above already records. The runbook is still wrong there.
>
> **Also found: the EKS overlay is internally inconsistent.** It patches the datasource to
> `jdbc:mysql://<rds-endpoint>:3306/...`, an unfilled placeholder, while still inheriting the
> in-cluster MySQL from `base` and patching that PVC to gp3. As committed it points the app at a
> database that does not resolve while running one it ignores. Worth fixing in the repo before this
> post ships, since the post now names the split explicitly.

**Blog companion:** https://blog.ibtisam-iq.com/same-artifact-four-compute-models/ (non-gating)

#### Body

```text
I deployed the same Java artifact four times without rebuilding it once.

EC2 with an Auto Scaling Group. ECS Fargate. A bare metal Kubernetes cluster. Then EKS. Before any of those I ran it on the host with a native JVM and MySQL, then in Docker Compose.

EC2 and Fargate shared one VPC, one set of security groups and one RDS, so those two compare cleanly: only the compute layer moved. On EC2 I wrote the bootstrap myself, pulling the JAR from S3 through an instance profile and running it under systemd. On Fargate all of it collapsed into a task definition.

The Kubernetes pair did not share that. Bare metal ran on an ephemeral lab machine with MySQL inside the cluster, and EKS ran in a separate sandbox account against its own RDS.

So the database followed the compute. That is the part I would design differently: the last two are not the controlled comparison the first two are.

Post 1 of 5 on deploying one application four ways.

If you had to hand one of these four to a team of three, which one, and what would you regret?
```

#### First comment

```text
Full write-up: what each layer actually costs to operate, the exact Kustomize split between bare metal and EKS, and why the storage class is deliberately absent from the base:
https://blog.ibtisam-iq.com/same-artifact-four-compute-models/

Manifests and infrastructure for all four:
https://github.com/ibtisam-iq/platform-engineering-systems/tree/main/systems/java-monolith

Deployment runbook, one phase per model:
https://runbook.ibtisam-iq.com/projects/deployments/java-monolith/

One detail worth stealing: I left storageClassName out of the base PVC entirely. Hardcoding gp3 there is the fastest way to make a manifest that only works in one place. Each overlay patches it in, local-path on bare metal and gp3 on EKS.   
```

---

### #13 (global) · Phase 4 Post 2 of 5 · `p4-05-ampersand` · ACCESSIBLE

**Added 2026-08-12.** The 2026-08-12 coverage audit found four Phase 4 blogs linked from no first
comment at all, so the standing "a blog with no post loses nothing, it is reachable from an adjacent
comment" argument did not hold for them. This is the strongest of the four and the only one that is
not stack-specific: no AWS, no Kubernetes, no Helm.

**Slotted second, not last.** It is chronologically earliest (local validation, before any deploy),
it is the widest door in the phase, and it keeps #14 and #15 from being three consecutive debugging
posts. It also seeds the Phase 6 capstone rather than competing with it.

**Asset:** `assets/p4-05-ampersand.svg` **(built)**.

**Blog companion:** https://blog.ibtisam-iq.com/two-local-databases-one-artifact/ (non-gating)

> **CORRECTED 2026-08-12 against the blog itself.** The draft said the truncated URL "was just
> shorter, and shorter still connects", which contradicted the post's own opening ("the application
> still could not reach MySQL"). The blog is precise and better: the truncated string is **a valid
> JDBC URL**, the driver parses it happily, and "the failure surfaces somewhere entirely unrelated to
> the assignment that caused it." Rewritten to match.
>
> **Added from the blog, and stronger than the line it replaced:** "Any query string in any
> environment variable has this problem. JDBC URLs are just where most people meet it first."
>
> **The example is `localhost:3306/db`,** which is the broken snippet in the blog, not the Compose
> `db:3306` I had invented. The asset now matches.
>
> **Unused but available if a future post needs it:** the blog's own "The Part That Undermines It
> Slightly" section, where `driver-class-name` and `spring.jpa.database-platform` stay inside
> `application.properties` rather than `.env`, so switching H2 to MySQL means editing a file inside
> the artifact. He names the correct fix (Spring profiles via `SPRING_PROFILES_ACTIVE`) and says he
> would build it that way now. That is a better self-critical post than most things in Phase 5.

#### Body

```text
My database connection failed. The URL in the file was correct. It was not the URL the application received.

The connection string ends with a query: useSSL=false, an ampersand, then serverTimezone=UTC. Unquoted in a .env file, that ampersand is not part of the value. It is the shell's background operator, so the line ends there and the rest runs as a separate command.

What made it expensive is that the truncation left something valid. A malformed URL fails loudly at parse time. This one the driver accepted, so the failure surfaced far from the line that caused it.

Then echo printed the truncated value back and it looked right, because I was checking it against what I meant to write instead of reading to the end. The missing part was past where the eye stops.

The fix is one pair of double quotes. Any query string in an environment variable has this problem. JDBC URLs are where most people meet it.

One of three apps I keep public. This happened before any CI existed.

Post 2 of 5 on deploying one application four ways.

What is the longest you have spent debugging something your own check told you was fine?
```

#### First comment

```text
The full write-up, including running the same artifact against H2 and MySQL locally and why the dialect has to be set explicitly:
https://blog.ibtisam-iq.com/two-local-databases-one-artifact/

The app, with the quoting documented at the point it bites:
https://github.com/ibtisam-iq/java-monolith-app

Adjacent, and the same shape of problem: reading a Helm chart somebody else wrote, where the values you care about are three files away from where they are used:
https://blog.ibtisam-iq.com/reading-a-helm-chart-you-did-not-write/

Worth being precise about the mechanism. The shell is not mangling your string, it is parsing the line exactly as documented. An unquoted & ends a command. Everything after it becomes a second command that happens to run, succeed, and print nothing. There is no error because nothing errored.

The general version: a value that is checked by the same tool that corrupted it will always look correct.
```

---

### #14 (global) · Phase 4 Post 3 of 5 · `p4-02-alb-loop` · HYBRID

**On LinkedIn because** it is a symptom almost every engineer has hit behind a TLS-terminating
proxy, so the hook lands cold and invites replies from people with their own version.

**Asset:** `assets/p4-02-alb-loop.svg` **(built)**. Built as a two-loop diagram rather than a
terminal screenshot: both failure chains fit in one frame, and no console identifiers are invented.

**Blog companion:** https://blog.ibtisam-iq.com/alb-health-check-https-redirect-loop/ **(publish first)**

> **AUDITED 2026-08-12 against `java-monolith-app/docs/alb-troubleshooting.md`. Body holds up.**
> Every claim is in the source: the app logging a clean start while the ALB called it unhealthy;
> `curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/actuator/health` returning `302`;
> Spring Security's `.anyRequest().authenticated()` catching `/actuator/health`; the one-line
> `permitAll()` matcher working only above the catch-all; and three properties for the redirect loop.
>
> **The ASG loop is verbatim, and better than I had it:** "The ASG interpreted unhealthy instances as
> failed launches and entered a replacement loop", with the real state cycle
> `initial -> unhealthy -> draining -> terminated -> new instance -> repeat`. The asset now shows
> those states rather than a paraphrase.
>
> **One imprecision fixed.** The draft said the browser "dropped the session cookie set on the other
> scheme", which merged the doc's Problem A and Problem B. Problem B is specific: the cookie lacked
> the `Secure` flag, so the browser would not send it over HTTPS at all. Reworded.
>
> **Available and unused:** the diagnosis order (suspect the JAR on S3 first, confirm it is there,
> read the app logs, only then curl the health endpoint locally) and the two commit hashes,
> `6dc03ed` and `08fe939`. The first comment already promises "the diagnosis order that actually
> found it", so the blog must carry it.

#### Body

```text
The load balancer said the instance was unhealthy. The application said it had started fine.

Both were telling the truth.

The health endpoint was returning 302, not 200. Spring Security was intercepting every unauthenticated request, including the load balancer's health check, and redirecting it to a login page. The checker followed the redirect, got HTML, and marked the target failed.

The Auto Scaling Group then did exactly what it was told: replaced the unhealthy instance, which failed the same check, and looped.

One line fixed it, and only because it was placed above the catch-all rule rather than below it.

Then the next failure appeared. Login worked and immediately bounced back to the login page, forever. TLS terminated at the load balancer, so the app saw plain HTTP and issued an http:// redirect after login. The browser upgraded that to https://, and the session cookie did not come with it, because nothing had marked it Secure.

That one needed three properties, not one.

Post 3 of 5 on deploying one application four ways.

What is the longest you have spent on a failure where every component was individually working?
```

#### First comment

```text
The full chain, with the diagnosis order that actually found it, all three properties, and why sticky sessions were needed on top:
https://blog.ibtisam-iq.com/alb-health-check-https-redirect-loop/

The original notes, written while debugging:
https://github.com/ibtisam-iq/java-monolith-app/blob/main/docs/alb-troubleshooting.md

The two fixes, in short.

Health check: put a permitAll matcher for the health path ABOVE the anyRequest catch-all. Spring Security evaluates top to bottom and stops at the first match, so ordering is the whole fix.

Redirect loop: server.forward-headers-strategy=native so Spring trusts X-Forwarded-Proto, cookie.secure=true so the cookie survives HTTPS, and cookie.same-site=lax so the browser keeps it across the login POST.

The same shape shows up behind any proxy that terminates TLS, not just an ALB.
```

---

### #15 (global) · Phase 4 Post 4 of 5 · `p4-03-acme-nat` · HYBRID

**On LinkedIn because** "the certificate authority could not reach my cluster, and neither could
my own cluster" is a self-contained absurdity that lands cold, and NAT'd home labs are a large
audience with exactly this problem.

**Asset:** `assets/p4-03-acme-nat.svg` **(built)**. Four-hop self-check path on top, the three
faults below with the two fixes in amber.

**Blog companion:** https://blog.ibtisam-iq.com/cert-manager-gateway-http01-baremetal/ **(publish first)**

> **AUDITED 2026-08-12 against `docs/cert-manager/cert-manager-gateway-troubleshooting.md`.
> Clean. No corrections.** All six claims verify against the source, including the one I was least
> sure of: "NGF creates a **per-Gateway nginx Deployment and Service in the application namespace**.
> This per-Gateway Service is the correct NodePort entrypoint, not the controller Service", with
> `bankapp-gateway-nginx` as NodePort in `bankapp` and `ngf-nginx-gateway-fabric` staying ClusterIP
> in `nginx-gateway`. The iptables OUTPUT-chain point is section 6 ("Redirect locally generated
> traffic to NodePorts as well"), the CoreDNS override is section 7, and the first comment's promise
> of a clean ACME retry is section 8. The asset matches the source wording.
>
> ### ENVIRONMENT DRIFT, worth resolving in the repos
>
> The bare-metal Kubernetes target is described three different ways across the sources:
>
> | Source | Says |
> |---|---|
> | `runbook/.../phase-6-kubernetes-deployments.md:12` | "an ephemeral iximiuz dev machine" |
> | `java-monolith-app/README.md` | "iximiuz Labs" |
> | `docs/cert-manager/cert-manager-gateway-troubleshooting.md:10` | "single-node control-plane on **EC2**" |
> | `k8s/README.md:32` | "local development (minikube, kind, local bare-metal)" |
>
> The cert-manager doc is almost certainly right about its own exercise: it uses a `172.31.x.x`
> private address, which is a default AWS VPC CIDR, and the whole problem is the 1:1 public IP not
> being on the interface. That is an EC2 condition, not an iximiuz one. So the **deployment** was
> validated on iximiuz and the **TLS work** was done on EC2, which is reasonable, but no single
> document says so. Post 3 does not name a platform, so it ships safely either way. Post 1 says
> "an ephemeral lab machine", which matches the deployment. A reader who follows the links from Post
> 1 into this material will hit the discrepancy.

#### Body

```text
Let's Encrypt could not reach my cluster to issue a certificate. Neither could the cluster itself.

The second half is the part that took longest.

cert-manager runs a self-check before it asks Let's Encrypt to validate. It resolves your domain, fetches the challenge token, and only proceeds if it can see its own answer. On a single node behind NAT, that self-check resolved my domain to the public IP, left the box, and never came back.

Three things were wrong at once.

The Gateway controller service was not the thing serving traffic. NGINX Gateway Fabric creates a separate nginx deployment per Gateway, in the application namespace, and that is the one holding the NodePort. I had been checking the wrong service.

Nothing was bound to port 80 on the host, so iptables needed redirects. Both directions, because traffic the node generates itself does not pass through PREROUTING.

And DNS inside the cluster still pointed at the public address, so I overrode it to the node's private IP in CoreDNS.

Post 4 of 5 on deploying one application four ways.

What is your approach to TLS on a cluster with no public IP?
```

#### First comment

```text
The full chain, every command, and how to force a clean ACME retry after the fix so stale challenges do not mask it:
https://blog.ibtisam-iq.com/cert-manager-gateway-http01-baremetal/

If you are on ingress-nginx rather than Gateway API, none of the above applies to you and the setup is much simpler. That comparison, plus the hostNetwork alternative:
https://blog.ibtisam-iq.com/cert-manager-ingress-vs-gateway-solver/

And if your cluster has no public IP at all, HTTP-01 cannot work by design. Three approaches that do, with a decision matrix:
https://blog.ibtisam-iq.com/tls-three-approaches-behind-nat/

The short version of that last one: DNS-01 proves ownership with a TXT record instead of an inbound request, so it never needs to reach you. It is the only Let's Encrypt path that works behind CGNAT without a tunnel.

If you are weighing Gateway API against Ingress in the first place, all three implementations side by side, and what the newer API actually buys:
https://blog.ibtisam-iq.com/gateway-api-three-ways/

Source, all three documents: https://github.com/ibtisam-iq/platform-engineering-systems/tree/main/systems/java-monolith/docs
```

---

### #16 (global) · Phase 4 Post 5 of 5 · `p4-04-helmfile-ladder` · VALUE-FIRST

**On LinkedIn because** "one chart, six rungs of dependency" is a concrete reusable pattern
peers can adopt immediately, and it surfaces a repo people can clone.

**Asset:** `assets/p4-04-helmfile-ladder.svg` **(built)**. **Spec said two rungs are wired into
helmfiles. It is three:** `values-02`, `values-03` and `values-06`, one per scenario. Verified by
grepping the three helmfile YAMLs.

**Blog companion:** https://blog.ibtisam-iq.com/helmfile-dependency-ladder/ (non-gating)

> **CORRECTION 2026-08-12, from reading `retail-store-sample-app/README.md` and the three helmfiles.**
> Two invented details removed:
> 1. **"one for my laptop and one for the cloud."** There is no laptop. The README opens the Lab
>    Environment section with "no local VM, no personal AWS account, no pre-configured cloud
>    instance." Bare metal is the **SilverStack Dev Machine on iximiuz Labs**; EKS is the
>    **KodeKloud AWS Playground**. Reworded to "one cheap and one real", which keeps the point and
>    invents nothing.
> 2. **"catalog and orders start together."** False. `helmfile-eks.yaml` has `orders` needing
>    `catalog/catalog`, so orders waits. The pair that genuinely runs in parallel is **cart and
>    orders**, both of which need only catalog. Corrected.
>
> **Verified true and unchanged:** six orders values files matching the six descriptions in order;
> 26 overlays; three scenarios; five services; `ui` needing all four (`catalog`, `cart`, `orders`,
> `checkout`); `values-endpoints.yaml` present for `ui` in all three scenarios; on EKS the catalog
> MySQL, orders PostgreSQL and checkout Redis all stay in-cluster on PVCs with only cart's DynamoDB
> and orders' SQS actually AWS-managed; and the SQS to Lambda to SNS pipeline exists, with the Lambda
> created via Console because `iam:PassRole` was blocked for the lab user.
>
> **Repo inconsistency worth fixing:** the README's service table says Orders depends on "Cart,
> Checkout", but every helmfile declares `orders` needing `catalog` and `checkout` needing `orders`.
> The table and the deployment graph disagree about the direction.

#### Body

```text
The same Helm chart deploys my orders service six different ways.

In memory. PostgreSQL with in-memory messaging. PostgreSQL and RabbitMQ on local disk. The same pair on EBS. Both pointed at external endpoints. Or PostgreSQL with AWS SQS.

Six values files, one chart, no forks.

That is the part I got wrong the first time. I assumed portability meant two configurations, one cheap and one real. It is actually a ladder, and every rung is a real place to stand.

The lowest rung needs no infrastructure at all, which makes it the fastest way to check that a deployment works before any storage exists. The top rung is the one with an IAM role attached to a service account.

Five services, twenty six of these overlays, and three Helmfile scenarios that pick a rung each. Release order is a dependency graph rather than a list, so cart and orders roll out in parallel once catalog is up, while the UI waits for all four services it calls at startup.

Post 5 of 5 on deploying one application four ways.

Where do you draw the line between a values file and a separate chart?
```

#### First comment

```text
Full write-up: the whole ladder per service, why the UI needs an endpoints overlay in every scenario, and what the needs: graph buys over waiting on everything:
https://blog.ibtisam-iq.com/helmfile-dependency-ladder/

The three scenarios, runnable:
https://github.com/ibtisam-iq/retail-store-sample-app/tree/main/helmfile

Per-service charts and every overlay:
https://github.com/ibtisam-iq/retail-store-sample-app/tree/main/src

Deployment runbook including the IRSA bindings and the SQS to Lambda to SNS pipeline on the top rung:
https://runbook.ibtisam-iq.com/projects/deployments/retail-store-sample-app/

What the top rung actually involves, where a pod gets AWS permissions without a credential anywhere in the manifest:
https://blog.ibtisam-iq.com/irsa-serverless-event-pipeline/

Worth being precise about one thing: on EKS the databases still run in the cluster on gp3 volumes. Only the cart's DynamoDB and the orders messaging are actually AWS managed. The ladder has rungs above where I stopped.
```

---

### #17 (global) · Phase 5 Post 1 of 3 · `p5-01-buildkit-epoch` · HYBRID

**On LinkedIn because** two widely recommended practices silently cancelling each other is a
genuinely surprising claim that peers will argue with, which is exactly what a feed rewards.

**Asset:** `docker manifest inspect` output showing `created: 1970-01-01T00:00:00Z` beside
Image Updater logging `images_updated=0`.

**Blog companion:** https://blog.ibtisam-iq.com/buildkit-epoch-broke-image-updater/ **(publish first)**

#### Body

```text
My builds were reproducible. That is why my deployments stopped happening.

I had ten microservices on EKS, images in a registry, and ArgoCD Image Updater watching for new ones. CI ran, images landed, and nothing rolled. No errors. The logs just said images considered 10, images updated 0.

Image Updater was set to track the newest build. It decides which tag is newest by reading the created timestamp inside the image config.

BuildKit sets that timestamp to zero. Not to the build time, to 1970-01-01T00:00:00Z, deliberately, because a real timestamp makes the same source produce a different image every time. That is the entire point of a reproducible build.

So every image I pushed was exactly as old as every other image. There was no newest. The comparison was working perfectly on data designed to carry no information.

The fix was to stop ranking by age and start comparing digests instead, which took two more failed attempts to configure correctly.

Post 1 of 3 on running ten services with no manual deploys.

Which two tools have you seen cancel each other out while both worked as documented?
```

#### First comment

```text
The whole chain, all three strategy attempts and the two configuration errors between them, plus how I confirmed the timestamp rather than guessing:
https://blog.ibtisam-iq.com/buildkit-epoch-broke-image-updater/

Runbook, with the exact log lines at each stage:
https://runbook.ibtisam-iq.com/projects/deployments/microservices-demo/gitops-argocd/

The working Image Updater config, all ten services:
https://github.com/ibtisam-iq/platform-engineering-systems/blob/main/systems/microservices-demo/addons/image-updater/image-updater.yaml

Two traps if you go the same way.

allowTags needs a regexp: prefix. Without it the pattern is silently ignored rather than rejected, which is how you get a filter that matches nothing and says nothing.

The digest strategy needs a version constraint, so every imageName has to carry an explicit tag to track. A bare repository path is not enough, and the error message for that one is at least honest.
```

---

### #18 (global) · Phase 5 Post 2 of 3 · `p5-02-push-vs-pull` · HYBRID

**On LinkedIn because** it is a fork-in-the-road decision every team hits once, and having built
both sides is the credential that makes the opinion worth reading.

**Asset:** two-lane diagram. Top: CI writes a tag to the CD repo, ArgoCD reads Git.
Bottom: CI stops at the registry, Image Updater polls and patches.

**Blog companion:** https://blog.ibtisam-iq.com/gitops-push-vs-pull-handoff/ (non-gating)

#### Body

```text
I built the same handoff twice, in opposite directions, and only one of them scales.

In my three monolith pipelines, CI ends by committing an image tag into the deployment repository. Git is the trigger. It is easy to reason about and every deploy has a commit behind it.

For ten microservices I stopped doing that.

The problem is not the mechanism, it is the volume. Every code push became a commit in the deployment repo. Ten services means ten times the noise, in a repo whose history should read as intent rather than as a build log.

Worse, I now had two things that both believed they decided which image runs: the commit CI wrote, and the controller watching the registry. That is not a race you want to discover during an incident.

So CI stops at the registry. The controller watches for new digests and patches the application itself. CI has no idea a cluster exists.

The tradeoff is real. I gave up a Git commit per deploy, which means the audit trail moved into the controller.

Post 2 of 3 on running ten services with no manual deploys.

Push or pull, and what did it cost you?
```

#### First comment

```text
Full comparison, including the third option I tried first and why it only worked for releases and not for continuous delivery:
https://blog.ibtisam-iq.com/gitops-push-vs-pull-handoff/

The push model, in the three monolith pipelines:
https://github.com/ibtisam-iq/java-monolith-app/blob/main/Jenkinsfile

The pull model, in the microservices trigger:
https://github.com/ibtisam-iq/microservices-demo/blob/main/.github/workflows/ci-trigger.yaml

One nuance that matters. Even in the pull model, one thing still writes to the deployment repo: the chart release. Image digests and chart versions answer different questions. A digest change means the container has new code. A chart version change means the Deployment itself has a new field. Letting the same mechanism own both is how you end up with a controller and a commit fighting over one file.

The add-on tier this all sits on, and the three defaults in it that silently do nothing:
https://blog.ibtisam-iq.com/eks-cluster-addons/
```

---

### #19 (global) · Phase 5 Post 3 of 3 · `p5-03-terraform-scp` · DEEP-DIVE

**On LinkedIn because** a named, reproducible defect in a module thousands of teams use is a
specific public contribution, not a story about my lab.

**Asset:** the six-row policy table, blocked action beside consequence beside workaround.

**Blog companion:** https://blog.ibtisam-iq.com/terraform-eks-module-silent-drop/ **(publish first)**

#### Body

```text
The most-used EKS Terraform module silently dropped the setting that gives you admin access to your own cluster.

Not an error. Not a warning. The field is accepted, and then it is not sent.

I was provisioning EKS in a restricted AWS account where an organisation policy blocks iam:PassRole unless the role has an exact whitelisted name. So I had to create the roles separately and tell the module not to make its own.

That single flag is what triggers it. With role creation disabled, version 21 of the module stops passing the bootstrap admin permissions field to the API. The cluster comes up clean. Then kubectl returns 401, because nothing on earth has permission to talk to it.

I confirmed it against the API rather than guessing: the field is simply absent from the response.

The fix was to stop using the module for the cluster itself and call the raw resource, where the setting reaches AWS untouched.

That was one of seventeen failures. Six were policy denials I confirmed with the IAM policy simulator.

Post 3 of 3 on running ten services with no manual deploys.

What is the worst silent default you have been bitten by?
```

#### First comment

```text
All seventeen errors with the fix for each, the six confirmed policy denials, and the final working configuration:
https://blog.ibtisam-iq.com/terraform-eks-module-silent-drop/

The runbook version, with the policy simulator output:
https://runbook.ibtisam-iq.com/iac/terraform/provisioning/eks-on-kodekloud-terraform/

The Terraform itself:
https://github.com/ibtisam-iq/silver-stack/tree/main/terraform/aws/eks-kodekloud

Three more that cost real time.

Managed node groups are blocked outright in this account, so the workers are self-managed through CloudFormation. The policy simulator says implicitDeny and AllowedByOrganizations false, which is at least unambiguous.

The CoreDNS addon hangs forever on first apply if you declare it, because its pods need nodes that do not exist yet. Leave it out and EKS installs it once nodes join.

Destroy fails on addon deletion and on log group deletion. preserve = true on every addon, and do not manage the log group in Terraform at all.
```

---

### #20 (global) · Phase 6 Post 1 of 3 · `p6-01-static-hosting` · VALUE-FIRST

**On LinkedIn because** the cost number is a hook that stops a scroll on its own, and it reaches
an AWS and security audience the Kubernetes posts do not.

**Asset:** CloudFront distribution screenshot beside the billing summary.

**Blog companion:** https://blog.ibtisam-iq.com/cloudfront-oac-dual-kms-static-hosting/ (non-gating)

#### Body

```text
Seven days of global static hosting on AWS cost me $1.45.

There is no compute in it at all. No Lambda, no container, no instance. A private S3 bucket and a CDN in front of it.

Zero compute does not mean zero decisions, which is the part worth writing down.

The bucket is fully private. CloudFront reaches it with Origin Access Control and signed requests, not the legacy access identity and not a public bucket policy. Objects are encrypted with a customer managed key.

Replication to a second region uses a separate key, so each region holds its own key material. Objects are decrypted at the source and re-encrypted at the destination rather than sharing one key across both.

Bucket Keys are on, which batches the key API calls per bucket instead of per object. That is most of why the bill is small.

Every API call against both buckets is logged, and old object versions age into Glacier after thirty days.

The hardest part was not the CDN. It was the single-page routing, where a missing path returns 403 rather than 404.

What is the smallest AWS bill you have been proud of?
```

#### First comment

```text
Full build, every command, including the bucket policy that makes the private origin work and the custom error response that fixes client-side routing:
https://blog.ibtisam-iq.com/cloudfront-oac-dual-kms-static-hosting/

Runbook, five phases from buckets through verification:
https://runbook.ibtisam-iq.com/projects/deployments/static-website/

Terminal session and the distribution screenshot:
https://github.com/ibtisam-iq/platform-engineering-systems/tree/main/systems/static-website

The single-page routing detail, since it catches people. A private bucket returns 403 for a missing key, not 404, because the caller is not allowed to know whether it exists. So the CloudFront custom error response has to map 403 to index.html with a 200, not 404. Map the wrong one and every deep link breaks while the home page looks fine.
```

---

### #21 (global) · Phase 6 Post 2 of 3 · `p6-02-silent-failures` · HYBRID · CAPSTONE

**On LinkedIn because** it is one claim supported by ten instances the audience has already
watched accumulate across four phases, which is the only post in the plan that gets stronger
the more of the series someone has read.

**Asset:** the ten-row table, tool beside what it silently ignored. No commentary needed.

**Blog companion:** https://blog.ibtisam-iq.com/ten-silent-failures/ (non-gating)

#### Body

```text
I went back through a year of my own failures and found the same one ten times.

Every case had the same shape. I set a value. The tool accepted it. The tool did not apply it. Nothing logged anything.

Maven took a version override for a dependency its parent does not expose, and used the parent's version.

Terraform took a cluster admin setting and did not send it to AWS, so the cluster came up with nobody able to reach it.

An image tag filter was ignored rather than rejected because it was missing a prefix, which meant it matched everything instead of nothing.

S3 skipped every encrypted object during replication because one field in the rule was unset.

Spring ignored the header telling it the request arrived over HTTPS, so it generated redirects to the wrong scheme and logged in nobody.

The common thread is not carelessness. Each of those defaults is individually defensible. The problem is that "accepted" and "applied" are different states, and almost nothing distinguishes them for you.

What I do now: after setting anything that matters, I check the far side. Not the config, not the plan. What the API actually returns.

Post 2 of 3 closing out this series.

What is the worst one you have hit?
```

#### First comment

```text
All ten, with the error each one produced and how I confirmed it:
https://blog.ibtisam-iq.com/ten-silent-failures/

The five with their own full write-ups:

Maven BOM ignoring a property key
https://blog.ibtisam-iq.com/maven-bom-cve-overrides/

Terraform dropping the EKS admin bootstrap field
https://blog.ibtisam-iq.com/terraform-eks-module-silent-drop/

BuildKit zeroing timestamps and stalling GitOps
https://blog.ibtisam-iq.com/buildkit-epoch-broke-image-updater/

Spring and the forwarded-proto header
https://blog.ibtisam-iq.com/alb-health-check-https-redirect-loop/

Groovy interpolation producing a deployable tag of "null"
https://blog.ibtisam-iq.com/jenkins-pipeline-hardening-fixes/

The pattern that catches most of them is boring and works: after any setting you would notice the absence of, read it back from the thing that consumes it. describe-cluster, not terraform plan. dependency:tree, not the pom.

---

### #22 (global) · Phase 6 Post 3 of 3 · `p6-03-how-i-work` · CLOSING

**On LinkedIn because** it is the only post whose subject is the reader's model of me rather
than a technical artifact, and it needs the preceding posts as evidence to land.

**Asset:** the methodology pipeline diagram from the projects site.

**Blog companion:** none, by design. It routes to the projects site, and a blog version
would compete with the page it is meant to send people to.

#### Body

```text
Everything I have posted for the last few months came out of the same loop.

It starts one of two ways. Either I do not understand something, or I need to actually run it.

Both end in the same place: I build the thing, and I write down what broke.

The writing is not documentation after the fact. It is the part that tells me whether I understood it. A step I cannot explain is a step I got working by accident, and those are the ones that fail later in front of someone else.

Four things come out. A machine image, so the environment is repeatable. A blog post, so the reasoning survives. A project entry, so the work is findable. A runbook, so I can do it again in a year without re-deriving it.

The loop is why the failures show up in my posts as often as the results. A cluster that came up first try teaches nothing worth publishing.

That is the whole system. Nothing counts as understood until it survives contact with what was actually built.

If you have written up something that broke this week, link it. I would rather read that than another launch announcement.
```

#### First comment

```text
The methodology, laid out properly: https://projects.ibtisam-iq.com

Everything it produced:
Blog https://blog.ibtisam-iq.com
Runbook https://runbook.ibtisam-iq.com
Playgrounds anyone can launch https://labs.iximiuz.com/a/ibtisam-iq
Source https://github.com/ibtisam-iq

If you only open one, make it the runbook. It is the least polished and the most useful, because it is written for the version of me who has forgotten all of this.
```

---

## THE FULL BLOG SET (22 posts, after the 2026-08-03 consolidation)

Written as 28. Cut to **22** in the consolidation review: four archived, two merged, one
reassigned to Phase 3. The ratio is now 10 LinkedIn posts against 22 blogs.

!!! danger "Why 28 was wrong, recorded so it is not repeated"
    The 28 figure came from enumerating unused source material and writing one post per unused
    body. That is a coverage exercise, not an editorial decision, and it produced four posts that
    would never have been proposed if the question had been *does this idea need an article?*

    The overlap probes were clean, so redundancy was never the problem. The problems were
    **proportionality** (three posts each on a $1.45 static site and one lab cluster, against one
    post per concept for the ten-service GitOps system) and **origin** (posts analysing other
    people's design, or restating a runbook).

    Nothing was deleted. Every archived file sits in `blog/docs/_archive/` with a banner naming
    where its material went.

### Phase 4 (10 blogs)

| # | Blog | Source | Tier |
|---|---|---|---|
| 1 | Four Compute Models, One Artifact | runbook phases 4/5/6, CD `ec2-asg`, `ecs`, `k8s` READMEs | Spine 1/4 |
| 2 | Two Failures Behind One Load Balancer | `docs/alb-troubleshooting.md` | Spine 2/4 **gates #13** |
| 3 | An ACME Challenge That Could Not Reach Itself | `cert-manager-gateway-troubleshooting.md`, `cert-manager-overview.md` | Spine 3/4 **gates #14** |
| 4 | One Chart, a Ladder of Dependencies | `helmfile/`, 26 overlays, 5 chart runbooks | Spine 4/4 |
| 5 | Two cert-manager Solvers, and the Flag That Is Off By Default | `cert-manager-overview.md`, `cert-manager-ingress-http01.md` | Companion |
| 6 | TLS Behind NAT Is Two Problems, Not One | `tls-complete-guide.md` | Companion |
| 7 | The Ampersand That Silently Truncated My Database URL | java phases 0 and 1 | Companion |
| 8 | Gateway API Three Ways | networking guides (52 KB) + all three real implementations | Standalone |
| 9 | Reading a Helm Chart You Did Not Write | 5 chart runbooks, `_helpers.tpl`, `configmap.yml` | Standalone |
| 10 | A Pod With AWS Permissions and No Credentials | retail `application-resources.md` | Standalone |
| ~~11~~ | ~~Five Services, Five Answers to Where Does State Go~~ | retail runbooks 01 to 05 | 📦 **archived** |
| ~~12~~ | ~~A Bootstrap Script Is Mostly Refusing to Break Things~~ | `bootstrap/kubernetes/cluster-kubeadm` | 📦 **archived** |

### Phase 5 (8 blogs)

| # | Blog | Source | Tier |
|---|---|---|---|
| 13 | My Builds Were Reproducible | `gitops-argocd.md` strategies 1 to 3 | Spine 1/3 **gates #16** |
| 14 | Push or Pull: Two Ways to Hand Off a Deployment | `ci.md` iteration table, `chart-release.yaml` | Spine 2/3 |
| 15 | The EKS Module Accepted the Setting | `eks-on-kodekloud-terraform.md` | Spine 3/3 **gates #18** |
| 16 | Seventeen Errors, and the Ones That Were Caused by the Fix | challenges file **plus** `eks-on-kodekloud-eksctl.md` | Standalone, **absorbed blog 17** |
| 17 | 401 and 403 Are Different Failures | eksctl auth table, challenges errors 8 to 12 | Standalone |
| 18 | Building Only What Changed, and the Permissions Ceiling | `ci-trigger.yaml`, `reusable-build.yaml` | Standalone |
| 19 | The Monitoring Stack Is the One Thing ArgoCD Does Not Manage | `observability.md` decision | Standalone |
| 20 | Four Add-ons Between a Bare EKS Cluster and a Working One | `cluster-addons.md` + addon YAML, **plus the capacity model** | Standalone, **absorbed blog 23** |
| ~~21~~ | ~~I Used Three Tools to Build One Cluster~~ | `eks-on-kodekloud-eksctl.md` (36 KB) | 🔀 **merged into 16** |
| ~~22~~ | ~~I Used Helmfile Before ArgoCD on Purpose~~ | retail Key Decisions | 📦 **archived** |
| ~~23~~ | ~~Observability Is a Workload, and I Did Not Budget for It~~ | ELK install, Kibana pending bug | 📦 **archived**, capacity section moved to 20 |

### Phase 6 (4 blogs)

| # | Blog | Source | Tier |
|---|---|---|---|
| 24 | Zero Compute, and Still a Dozen Decisions | static index, `cloudfront-cdn.md`, `observability-lifecycle.md` | Standalone |
| 25 | **A Site That Loads Proves Almost Nothing** | `verification.md` **plus** `storage-encryption.md`, `iam-replication.md` | Standalone, **absorbed blog 26** |
| 26 | Ten Things That Failed Silently | cross-cutting, all five projects | Standalone **capstone** |
| ~~27~~ | ~~Two Regions, Two Keys, and the Objects S3 Quietly Skipped~~ | `storage-encryption.md`, `iam-replication.md` | 🔀 **merged into 25** |
| 28 | The Jenkinsfile Rewrite Was Mostly Deletions | `understand-jenkinsfile.md` (36 KB) | ➡️ **reassigned to Phase 3** |

!!! note "Blog 25 was retitled"
    The merged verification post is no longer *Four Different 403s*. That framing could not cover
    the replication material folded into it, so the post is now **A Site That Loads Proves Almost
    Nothing**, and the 403 taxonomy is its opening section. The slug is unchanged
    (`static-hosting-verification-and-teardown`), so no link breaks.

!!! note "Blog 28 versus B11, and why it moved phase"
    `understand-jenkinsfile.md` and the existing B11 (`jenkins-pipeline-hardening-fixes`) look
    like duplicates and are not. B11 covers the numbered `FIX` comments, which are defects.
    Blog 28 covers the ~20 "why I did this" design decisions in the old-versus-new rewrite:
    removing `tools {}`, dropping `SCANNER_HOME`, `dir(APP_DIR)`, `mvn clean verify`. Rationale,
    not repair. Cross-link them; do not merge.

    It sat in Phase 6 because that is where there was room, not because it belonged there. Java,
    Jenkins and CI are Phase 3 material, so it is **filed under Phase 3 for routing**. It is not
    renumbered into that eight-part series: the series argues a cross-application contract, and
    this post argues about one Jenkinsfile. Standalone, with a `Related` block pointing into
    Phase 3.

---

## SOURCE FILES USED

**java-monolith-app**: `docs/alb-troubleshooting.md`, `Dockerfile`, `compose.yml`
(excluding `src/`, and `.scratchpad/` is gitignored so nothing there is publishable)
**platform-engineering-systems**: `systems/java-monolith/{k8s,terraform,ec2-asg,ecs}/`,
`image.env`, `systems/microservices-demo/{application.yaml,kustomization.yaml,chart,addons,manifests}/`,
`systems/static-website/`
**microservices-demo**: `.github/workflows/{ci-trigger,reusable-build,chart-release}.yaml`,
`README.md`, `assets/` (12 screenshots)
**retail-store-sample-app**: `helmfile/` (3 scenarios), `src/*/chart/` (~25 overlays and
5 chart runbooks), `runbooks/` (8 files), `assets/` (5 screenshots)
**silver-stack**: `terraform/aws/eks-kodekloud/` (canonical)
**runbook**: `projects/deployments/{java-monolith,microservices-demo,retail-store-sample-app,static-website}/`,
`iac/terraform/provisioning/` (including the 17-error challenges file)
**projects**: `data/projects.yaml`

---

## AFTER THIS PHASE SET

The publishing plan is complete at 19 posts. Two things remain open.

**The authoring surface**, carried over from Phase 2 and still the largest unexploited
opportunity. A challenge series running on the CI/CD Stack playground is a bigger content
play than posts alone.

**The `eks-on-kodekloud-terraform-challenges.md` file** is the single strongest artifact in
the portfolio and still under-published even after P5-03. Seventeen documented failures with
policy simulator output is a reference other people would link to. Worth its own expansion
pass, possibly as a standalone guide rather than a blog post.
