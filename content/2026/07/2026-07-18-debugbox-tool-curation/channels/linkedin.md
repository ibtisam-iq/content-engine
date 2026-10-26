---
channel_id: "linkedin-debugbox-tool-curation"
platform: "linkedin"
format: "post"
source_packet: "2026-07-18-debugbox-tool-curation"
channel_status: "ready"

dates:
  planned_date: "2026-07-18T09:00:00Z"
  published_date: ""

distribution:
  published_url: ""
  syndication_canonical_url: ""

content_spec:
  hook: "I removed 5 packages from my open-source container image. It got smaller and more useful."
  cta_type: "question"
  cta_text: "When you maintain a shared tool or image, what is the hardest part of deciding what to remove?"
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

I removed 5 packages from my open-source container image. It got smaller and more useful.

## Post Body

In the first release of DebugBox, the power variant carried everything I could think of. bird (a BGP routing daemon), bridge-utils, nano, py3-pip, speedtest-cli. All technically "networking-adjacent." None of them belong in an ephemeral Kubernetes debugging container.

For v1.1.0, I reviewed every package with two questions:
1. Does this serve the variant's stated purpose?
2. Does it overlap with something already included?

What moved:
openssl moved from power to balanced. TLS certificate debugging is daily work, not a power-user task.
nmap, iperf3, iftop, ethtool moved from balanced to power. Specialized tools that most sessions never touch.

What was removed entirely:
bird (BGP daemon, not a debugging tool), bridge-utils (rarely relevant in container networking), nano (vim is already included), py3-pip (installs arbitrary packages into a controlled image), speedtest-cli (tests external servers, not pod-to-pod bandwidth).

Result: balanced dropped from 51 MB to 47 MB. Power dropped from 112 MB to 91 MB.

Adding tools is easy. Removing them requires understanding who uses what and why.

https://github.com/ibtisam-iq/debugbox/releases/tag/v1.1.0

## Call to Action

When you maintain a shared tool or image, what is the hardest part of deciding what to remove?

## Hashtags

#DevOps #Kubernetes #Containers #OpenSource #SRE #CloudNative
