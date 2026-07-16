# Canonical Strategic Brief

## 1. Technical Event Context

- **Event Description**: DebugBox v1.2.0 released. Multi-variant Kubernetes debugging container toolkit: lite (15 MB), balanced (47 MB), power (91 MB). Multi-arch (amd64 + arm64), published to GHCR and Docker Hub, MIT licensed.
- **Why It Matters**: The dominant alternative (netshoot) ships as a single 202 MB image regardless of what the user needs. DebugBox lets teams pull only what the task requires, reducing pull times on edge clusters, metered connections, and environments with registry rate limits.

## 2. Target Audience Segments

- **Primary Audience**: Platform engineers and SREs who run kubectl debug in production and care about image pull latency.
- **Secondary Audience**: DevOps engineers building ephemeral container workflows, and engineering managers reviewing tool choices.

## 3. Core Messaging Thesis

- **Primary Thesis**: A tiered variant model solves the all-or-nothing problem in Kubernetes debugging containers.
- **Supporting Arguments**:
  - Argument 1: 93% size reduction (202 MB to 15 MB for DNS-only tasks) is the concrete proof.
  - Argument 2: Each variant has a defined scope (connectivity, daily troubleshooting, forensics) so the trade-off is explicit.
  - Argument 3: Multi-arch, CVE-gated releases, and two-registry publishing make it production-grade from the start.

## 4. Tone and Editorial Constraints

- **Tone**: Direct, factual, project-builder perspective. No marketing language.
- **Constraints**: No em dashes. No banned buzzwords (leverage, seamless, robust, etc.). State sizes and commands literally.
