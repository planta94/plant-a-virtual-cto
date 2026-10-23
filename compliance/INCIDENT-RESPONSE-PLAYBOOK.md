# Security Incident, Secret Leak & Data Breach Response Playbook (SOC 2 CC7.3–CC7.4 / ISO 27001 A.5.24–A.5.28)

> **Auditor Purpose:** SOC 2 and ISO/IEC 27001:2022 require a documented, repeatable Incident Response Plan (IRP) and a log of security incidents or tabletop exercises.

---

## 1. Severity Classification & Response SLAs

| Severity | Definition | Examples | Initial Response SLA | Resolution / Containment SLA |
| :--- | :--- | :--- | :--- | :--- |
| **SEV-1 (Critical)** | Confirmed production data breach, active unauthorized access, or leaked production secret/key in Git | Production DB credential committed to Git; cross-tenant IDOR exploited in prod; complete prod outage | **< 15 Minutes** | **< 4 Hours** (Secret rotation within 30 mins) |
| **SEV-2 (High)** | High/Critical vulnerability in production dependency or partial service degradation | Critical CVE (`CVSS >= 9.0`) in deployed package; failed post-deploy canary `/health` check | **< 2 Hours** | **< 24 Hours** (via `[HOTFIX-TRACK]`) |
| **SEV-3 (Medium)** | Non-production secret leak, SAST finding on `UAT`, or minor security misconfiguration | Staging API key committed and blocked by Gitleaks; non-exploitable OWASP warning | **< 1 Business Day** | **< 5 Business Days** |

---

## 2. Step-by-Step Runbook: What to Do If a Secret Is Leaked or a Breach Occurs

### Scenario A: Developer Commits a Secret or API Key to Git
Even with `.pre-commit-config.yaml` and CI Gate 2 (Gitleaks), if a secret ever touches a remote Git branch:
1. **Assume Immediate Compromise (Minute 0–15):** Deleting the secret in a new commit does **not** remove it from Git history.
2. **Revoke & Rotate Immediately (Minute 15–30):**
   - Generate a new key/credential in AWS/GCP/Stripe/DB Secret Manager.
   - Deploy the new secret to production (`UAT` / `MAIN` runtime environment).
   - **Revoke/Delete** the exposed key immediately.
3. **Audit Access Logs (Minute 30–60):** Check CloudTrail / API access logs for any unauthorized usage of the leaked key during the exposure window.
4. **Log the Incident Below:** Record the event in Section 3 for SOC 2 / ISO 27001 audit evidence.

### Scenario B: Production Vulnerability or Outage Requiring Emergency Fix (`[HOTFIX-TRACK]`)
1. **Contain & Triage:** CTO declares a `SEV-1` or `SEV-2` incident.
2. **Execute `[HOTFIX-TRACK]` (`< 200 LOC`):**
   - Open a PR prefixed with `[HOTFIX-TRACK]` targeting `MAIN`.
   - Gate 2 (Gitleaks + Semgrep SAST) and Gate 3 (Unit/Integration/403 Security Tests) **still run and must pass**.
   - Requires **1 Peer + CTO approval**.
3. **24-Hour Retroactive Spec & Post-Mortem:**
   - Within **24 hours**, the author must commit a retroactive `specs/SPEC-XXX-hotfix-postmortem.md` documenting Root Cause, Blast Radius, and Prevention Rule (and add a new Golden Rule to `AGENTS.md` if an AI coding mistake caused the issue).

---

## 3. Security Incident & Tabletop Exercise Register (Audit Evidence Log)

> *Note: If zero real security incidents occur during the year, SOC 2 and ISO 27001 require at least **one simulated Tabletop Exercise per year** to prove the team tested this playbook.*

| Date | Incident / Exercise ID | Type (`Real` or `Tabletop Drill`) | Severity | Summary of Event | Containment Action Taken | Root Cause & `AGENTS.md` Rule Added | Signed Off By |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `2026-10-24` | `INC-DRILL-001` | `Tabletop Drill` | `SEV-1 (Simulated)` | Simulated accidental commit of a staging Stripe API key in a PR to `service-a`. | Verified Gitleaks in CI Gate 2 blocked the PR within 18 seconds; practiced key rotation procedure. | Added `.pre-commit-config.yaml` local Gitleaks hook via `sync-microservice`. | `@cto-handle` |
