---
channel_id: "linkedin-debugbox-announcement"
platform: "linkedin"
format: "post"
source_packet: "2026-07-16-debugbox-k8s-announcement"
channel_status: "ready"

dates:
  planned_date: "2026-07-16T09:00:00Z"
  published_date: ""

distribution:
  published_url: ""
  syndication_canonical_url: ""

content_spec:
  hook: "I built a Kubernetes debugging toolkit. The smallest variant is 93% smaller than netshoot."
  cta_type: "question"
  cta_text: "What does your team use for ephemeral container debugging, and what is the biggest friction point?"
  media_paths: []

performance_metrics:
  impressions: 0
  engagements: 0
  likes: 0
  comments: 0
  shares: 0
  clicks: 0
  conversions: 0
  last_measured_at: ""
---

## Hook

I built a Kubernetes debugging toolkit. The smallest variant is 93% smaller than netshoot.

## Post Body

netshoot pulls 202 MB every time you need to check DNS on a pod. On an edge cluster or a metered connection, that bandwidth adds up fast.

DebugBox fixes this by splitting tools into three variants so you pull only what the task requires:

Lite (15 MB): curl, dig, netcat, jq, yq
Balanced (47 MB): tcpdump, openssl, strace, kubectx/kubens
Power (91 MB): tshark, nmap, iptables, conntrack

One command:
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:lite

Every variant is multi-arch (amd64 + arm64), Trivy-scanned on every release with hard-fail on HIGH/CRITICAL, and published to both GHCR and Docker Hub.

v1.2.0 is live. MIT licensed and open for contributions.

I also published a hands-on tutorial covering all three variants end-to-end in a live Kubernetes playground, no local cluster required:
https://labs.iximiuz.com/tutorials/kubernetes-debugging-with-debugbox-74e481c8

Blog: https://blog.ibtisam-iq.com/choosing-kubernetes-debugging-container/
GitHub: https://github.com/ibtisam-iq/debugbox
Docs: https://debugbox.ibtisam-iq.com

What does your team use for ephemeral container debugging, and what is the biggest friction point?

Built this for people who are tired of pulling 200 MB just to run dig.

Ibtisam

## Hashtags

#Kubernetes #DevOps #OpenSource #Containers #CloudNative #SRE
