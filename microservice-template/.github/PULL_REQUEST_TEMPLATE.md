## 1. Branch Promotion & Change Control Track (SOC 2 CC8.1 & ISO 27001 A.8.32)
Select **one** track below (automatically verified by CI):

- [ ] **Fast Track (`[FAST-TRACK]`, `feature/* → UAT`):** `< 100 LOC` changed AND zero changes to dependencies, DB schemas, auth/security, or API/Event contracts.
  - **Issue / Ticket ID:** `ISSUE-000`
- [ ] **Spec Track (`SPEC-XXX`, `feature/* → UAT`):** Links to an approved 1-Page Spec and locked Contract (`< 400 LOC` per PR).
  - **Spec ID:** `SPEC-000` *(Replace with actual Spec ID, e.g., `SPEC-014`)*
  - **Contract PR (if touching API/Events):** `N/A` or link to contract PR
  - **ADR ID (required if modifying dependencies):** `N/A` or `ADR-000`
- [ ] **Release Promotion (`UAT → MAIN`):** Promotes UAT-verified features to Production (`MAIN`). Automatically bypasses the 400-LOC feature cap.
- [ ] **Emergency Hotfix Track (`[HOTFIX-TRACK]`):** Critical production incident remediation (`< 200 LOC`).
  - **Incident ID:** `INC-000` *(Requires retroactive `SPEC-HOTFIX-XXX` within 24h)*
- [ ] **Authorized Startup Exception (`[CTO-OVERRIDE: <reason>]`):** CTO/Deputy authorized waiver of soft gates (400-LOC cap / pre-Spec) for urgent startup delivery; logged for SOC 2 audit trail.

---

## 2. Summary of Changes & Brownfield Impact
*Briefly describe what changed, how backward compatibility is preserved for live services/mobile apps, and how it was tested.*

- **Changes:** 
- **DB Migration / Rollback Safety:** `[ ] None` | `[ ] Expand-and-Contract (Backward-compatible)`

---

## 3. Developer, AI & Security Compliance Sign-Off (Enforced by CI)
> *Note: CI will block merge if the first two checkboxes below are not checked.*

- [ ] I have read, understood, and verified every line of AI-generated code in this PR.
- [ ] No production secrets, customer PII, or proprietary credentials were shared with external AI tools or committed.
- [ ] No unapproved dependencies or legacy anti-patterns from surrounding brownfield files were replicated.
- [ ] Unit, real-DB integration, and 403 IDOR security tests are included (`>= 85%` diff coverage).
