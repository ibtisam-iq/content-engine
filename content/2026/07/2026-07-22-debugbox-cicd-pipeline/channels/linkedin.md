---
channel_id: "linkedin-debugbox-cicd-pipeline"
platform: "linkedin"
format: "post"
source_packet: "2026-07-22-debugbox-cicd-pipeline"
channel_status: "ready"

dates:
  planned_date: "2026-07-22T09:00:00Z"
  published_date: ""

distribution:
  published_url: ""
  syndication_canonical_url: ""

content_spec:
  hook: "Every release of DebugBox runs 3 Trivy scans, builds 6 images in CI, and pushes 22 tags to two registries. No manual steps."
  cta_type: "question"
  cta_text: "What is the one gate your container pipeline cannot ship without?"
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

Every release of DebugBox runs 3 Trivy scans, builds 6 images in CI, and pushes 22 tags to two registries. No manual steps.

## Post Body

The release pipeline has three stages:

1. Validate: extract the version from the git tag and confirm it follows semver. Catches typos before any images are built.
2. Build and Scan: build each of the three variants for amd64, load locally, run Trivy. Any HIGH or CRITICAL finding stops the release. No override.
3. Push: rebuild all variants for amd64 and arm64, push to both GHCR and Docker Hub.

The base image has its own dedicated workflow. Before v1.1.0, it was built and pushed manually. A gap: the base could change without being scanned, and variants would silently pick up whatever :latest pointed to. Now it triggers on changes to Dockerfile.base, builds both architectures, scans, and pushes independently.

Every variant Dockerfile pins the base image by SHA digest. If the base changes and the digest is not updated, the variant build uses the exact same base it was tested against. No silent drift.

Dependency hygiene mattered too. Bumping yq from v4.50.1 to v4.53.3 resolved multiple HIGH and CRITICAL CVEs in the Go runtime it shipped with. kubectx went from v0.9.5 to v0.11.0 with a patched golang.org/x/net.

The Makefile mirrors all of this locally. make check runs lint, build, test, and scan. Same gates, locally.

https://github.com/ibtisam-iq/debugbox

## Call to Action

What is the one gate your container pipeline cannot ship without?

## Hashtags

#CICD #DevOps #GitHubActions #Kubernetes #ContainerSecurity #CloudNative
