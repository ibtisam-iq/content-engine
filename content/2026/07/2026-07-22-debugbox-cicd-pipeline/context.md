# Canonical Strategic Brief

## 1. Technical Event Context

- **Event Description**: DebugBox CI/CD pipeline architecture: base.yml (automated base image lifecycle), ci.yml (3x2 matrix smoke tests), release.yml (validate, Trivy-scan 3 variants, push 22 tags to 2 registries). SHA digest pinning for deterministic builds. Hard-fail on HIGH/CRITICAL CVEs.
- **Why It Matters**: Demonstrates that production-grade container CI is achievable on a solo open-source project. The specific design choices (separate base lifecycle, scan-before-push, SHA pinning) are transferable patterns for any team.

## 2. Target Audience Segments

- **Primary Audience**: DevOps engineers and platform engineers building container build pipelines.
- **Secondary Audience**: SREs and engineering managers evaluating CI/CD maturity in their own orgs.

## 3. Core Messaging Thesis

- **Primary Thesis**: Three non-negotiable properties: no image ships without a scan, no manual step cuts a release, local dev runs the same gates as CI.
- **Supporting Arguments**:
  - Argument 1: The numbers make it concrete: 3 scans per release, 22 tags published, 6 smoke test jobs in CI.
  - Argument 2: SHA digest pinning solves the silent drift problem that :latest creates.
  - Argument 3: Dependency hygiene (yq, kubectx bumps) illustrates why automated scanning pays off.

## 4. Tone and Editorial Constraints

- **Tone**: Technical, precise, infrastructure-focused. Numbers-driven hook.
- **Constraints**: No em dashes. "6 security scans" is WRONG - release pipeline runs 3 Trivy scans (one per variant, amd64 only). CI runs 6 smoke-test jobs (not Trivy). Use accurate numbers.
