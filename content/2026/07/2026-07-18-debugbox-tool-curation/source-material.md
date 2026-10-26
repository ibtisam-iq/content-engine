# Raw Source Material

## 1. Reference Links

- v1.1.0 Release Notes: https://github.com/ibtisam-iq/debugbox/releases/tag/v1.1.0
- CHANGELOG: https://github.com/ibtisam-iq/debugbox/blob/main/CHANGELOG.md
- Manifest (source of truth): https://github.com/ibtisam-iq/debugbox/blob/main/docs/manifest.yaml

## 2. Key Data Points

- Packages removed entirely: bird, bridge-utils, nano, py3-pip, speedtest-cli (5 total)
- Also removed: wget (from balanced, overlapped with curl)
- Moved balanced to power: nmap, iperf3, iftop, ethtool (4 tools)
- Moved power to balanced: openssl (1 tool)
- Balanced: 51 MB to 47 MB (-4 MB)
- Power: 112 MB to 91 MB (-21 MB, ~19% reduction)

## 3. Decision Framework

Two questions applied to every tool:
1. Does this tool serve the variant's stated purpose?
2. Does this tool overlap with something already included?

Variant scope definitions:
- Lite: Network connectivity and data inspection
- Balanced: Daily Kubernetes troubleshooting
- Power: Packet analysis, firewall debugging, and forensics

## 4. Removal Justifications (key examples)

- bird: BGP routing daemon; runs a routing protocol; not a debugging tool
- nano: vim already included; redundant editor
- py3-pip: contradicts controlled pre-built tool set design goal
- speedtest-cli: tests external Ookla servers, not pod-to-pod bandwidth
- wget: overlaps entirely with curl
- openssl moved to balanced: TLS debugging is daily work, not a power-user task
