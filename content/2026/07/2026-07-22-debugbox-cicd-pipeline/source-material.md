# Raw Source Material

## 1. Reference Links

- Repository: https://github.com/ibtisam-iq/debugbox
- CI workflow: https://github.com/ibtisam-iq/debugbox/blob/main/.github/workflows/ci.yml
- Release workflow: https://github.com/ibtisam-iq/debugbox/blob/main/.github/workflows/release.yml
- Base image workflow: https://github.com/ibtisam-iq/debugbox/blob/main/.github/workflows/base.yml

## 2. Key Data Points

- Variants: 3 (lite, balanced, power)
- Architectures: 2 (amd64, arm64)
- CI matrix: 3 variants x 2 arch = 6 build+smoke-test jobs per push
- Trivy scans per release: 3 (one per variant, amd64 only - cannot load multi-arch locally)
- Tags pushed per release: 22 (11 patterns x 2 registries)
- Registries: GHCR + Docker Hub

## 3. Pipeline Stages

Release pipeline (release.yml):
1. Validate: semver format check from git tag
2. Build and Scan: build 3 variants (amd64), load locally, Trivy scan each with exit-code: 1 on HIGH/CRITICAL
3. Push: rebuild all 3 variants for amd64+arm64, push 22 tags to 2 registries

## 4. SHA Digest Pinning

```dockerfile
ARG BASE_IMAGE=ghcr.io/ibtisam-iq/debugbox-base@sha256:56a6c7cc829a5b3eefbced578ffc097bdeedee0e0489c7a73604c409e501023f
FROM ${BASE_IMAGE}
```

## 5. Dependency Hygiene Examples

- yq: v4.50.1 to v4.53.3 (resolved HIGH/CRITICAL CVEs in Go runtime; power variant uses pinned binary via scripts/install-yq-binary)
- kubectx/kubens: v0.9.5 to v0.11.0 (patched golang.org/x/net to v0.55.0 in Go builder stage)
