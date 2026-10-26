# Editorial Journal

## 1. Editorial Decisions

- Hook corrected: original draft said "6 security scans" which was wrong. Trivy runs 3 times per release (one per variant). CI runs 6 smoke-test jobs. Post now says "3 Trivy scans per release, 6 build jobs in CI."
- CVE counts: removed specific "1 CRITICAL and 16 HIGH" claim (unverifiable from repo files). Post says "multiple HIGH and CRITICAL CVEs."
- Base image lifecycle (was manual, now automated) is the lead story for CI - it is the biggest architectural change in v1.1.0 and directly caused SHA digest pinning to become necessary.

## 2. Reviewer Feedback

- (Pending)

## 3. Post-Publish Retrospective

- (Pending)
