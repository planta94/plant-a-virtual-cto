# Security & Governance Policy (`Plant-A-Virtual-CTO`)

> **ISO/IEC 27001:2022 (Annex A.5.1, A.8.25–A.8.32) & SOC 2 (CC2.2, CC6.1, CC8.1) Information Security Policy**

## 1. Purpose & Scope
Because **`Plant-A-Virtual-CTO`** is the central governance, contract, and CI/CD hub that broadcasts rules and workflows to all production microservice repositories, **this repository is classified as Tier-0 Critical Infrastructure**. Compromising or weakening a workflow in this repository impacts every downstream service.

## 2. Mandatory Access & Change Controls on This Repository
1. **Branch Protection on `main`:**
   - Direct pushes to `main` are forbidden (`Include administrators = ON` for formal audit window).
   - Every change requires a Pull Request, passing status checks from [`.github/workflows/hub-self-governance-ci.yml`](.github/workflows/hub-self-governance-ci.yml), and approval from `@planta94` or `@deputy-lead-handle` via [`.github/CODEOWNERS`](.github/CODEOWNERS).
2. **Least-Privilege Automation Tokens (`ORG_SYNC_PAT`):**
   - The GitHub Actions secret `ORG_SYNC_PAT` used by `auto-broadcast-standards.yml` and `monthly-audit-evidence.yml` must be a **Fine-Grained Personal Access Token** (or GitHub App token) scoped strictly to the target repositories with a maximum expiration of **90 days**.
3. **Pinned CI Dependencies (Supply-Chain Security):**
   - Workflows in `.github/workflows/` must never execute unverified remote scripts from mutable branches (`curl ... | sh` from `main`). Always use version-pinned actions or checksum-verified releases.

## 3. Reporting a Security Vulnerability or Leaked Secret
If any developer discovers a leaked credential, a bypass in our CI gates, or a security flaw in a Golden Example:
1. **Do NOT open a public GitHub Issue.**
2. Immediately notify `@planta94` and `@deputy-lead-handle` via private Slack/encrypted email and execute the **30-Minute Secret Rotation & Containment Runbook** in [`compliance/INCIDENT-RESPONSE-PLAYBOOK.md`](compliance/INCIDENT-RESPONSE-PLAYBOOK.md).
