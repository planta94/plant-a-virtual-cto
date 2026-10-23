# Engineering WIP Queue ("Swap, Don't Stack")

> **THE GOLDEN WIP RULE:**
> Each developer may have **at most 1 Active Spec (`SPEC-XXX`)** in Stage 2/3 (Contract/Implementation) at any time.
> If an urgent executive request arrives (`TRIAGE-XXX`), we **SWAP** it with an active item (pausing the active item cleanly on a feature-flagged branch) rather than stacking multiple concurrent tasks on one developer.

---

## 1. Active Implementation Queue (Max 1 Spec Per Developer)

| Developer | Active Spec ID | Feature / Summary | Target Repos | Current Stage | Started | Est. Merge Date |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `@dev-1` | `SPEC-001` | Example: User Notification Preferences | `user-service`, `web-angular` | Stage 3: PR 2/3 | 2026-10-22 | 2026-10-25 |
| `@dev-2` | `SPEC-002` | Example: Automated Invoice PDF Export | `billing-service`, `ai-worker-py` | Stage 2: Contract Lock | 2026-10-23 | 2026-10-27 |
| `@dev-3` | `SPEC-003` | Example: Mobile Biometric Login Flow | `auth-service`, `mobile-app` | Stage 3: PR 1/2 | 2026-10-21 | 2026-10-24 |

---

## 2. Approved & Ready Queue (Next Up — Pulled When a Dev Finishes)

| Priority | Spec ID | Feature / Summary | Target Repos | Est. Effort | Contract Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **#1** | `SPEC-004` | Example: Webhook Retry Dead-Letter Queue | `notification-service` | 2 Days (2 PRs) | Draft Ready |
| **#2** | `SPEC-005` | Example: Admin Role Audit Log View | `auth-service`, `web-angular` | 3 Days (3 PRs) | Spec Approved |

---

## 3. On-the-Fly Executive Triage Intake (30-Min SLA)

| Triage ID | Requested By | Idea Summary | Est. Effort | Recommended Swap Target | Decision |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `TRIAGE-001` | CEO / Founder | Example: Instant AI Summary Card on Dashboard | 2 Days | Swap with `SPEC-005` (Next Up) or pause `SPEC-002` | ⏳ Pending Boss Sign-off |

---

## 4. Paused / Swapped Specs (Cleanly Parked Behind Feature Flags)

| Spec ID | Previous Owner | Reason Paused | Resume Prerequisite |
| :--- | :--- | :--- | :--- |
| *None* | - | - | - |
