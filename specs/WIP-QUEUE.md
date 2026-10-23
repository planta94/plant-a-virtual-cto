# Live Engineering WIP Queue ("Swap, Don't Stack")

> **⚠️ AUTO-SYNCHRONIZED BY GITHUB ACTIONS (`.github/workflows/wip-queue-sync.yml`)**
> To prevent Git merge conflicts and stale markdown tables, **do not manually edit this file on feature branches**.
>
> ### How WIP Tracking Works (Zero-Conflict Architecture):
> 1. **Create a Spec (Stage 1):** Open a GitHub Issue using the [1-Page Feature Spec Form](../.github/ISSUE_TEMPLATE/1-page-spec.yml) (or via terminal: `gh issue create --template "1-page-spec.yml" --label "spec,status:active" --assignee "@me"`).
> 2. **Automatic "Swap, Don't Stack" Enforcement:** Each developer is capped at **1 `status:active` Spec**. If you assign yourself a new `status:active` Spec (e.g., after a [Boss Ad-Hoc Idea Triage](../.github/ISSUE_TEMPLATE/boss-triage-swap.yml)), the GitHub Action automatically flips your previous active Spec to `status:paused` and logs the swap on the Issue thread.
> 3. **Automatic Promotion & Closure on Merge:**
>    - When your PR referencing `SPEC-XXX` merges into `UAT`, the bot automatically updates the Issue to `status:uat` (`IN-UAT`).
>    - When `UAT` merges into `MAIN`, the bot automatically closes the Issue as `status:done` (`SHIPPED (MAIN)`) and rebuilds the table below.

---

## 🟢 Active WIP (Max 1 Active Spec per Developer)

| Spec / Issue | Developer | Current Stage | Target Repositories | Last Updated |
| :--- | :--- | :--- | :--- | :--- |
| `[SPEC-015] Export Monthly Invoices` | `@dev-backend-1` | `ACTIVE-DEV` | `service-a`, `web-portal` | `2026-10-24` |
| `[SPEC-016] AI Anomaly Detection Webhook` | `@dev-python-1` | `IN-UAT` | `service-b`, `contracts/` | `2026-10-24` |

---

## ⏸️ Paused / Swapped Specs (On Hold due to Boss Triage Swap)

| Spec / Issue | Developer | Paused By (Swap Reason) | Frozen Branch | Last Updated |
| :--- | :--- | :--- | :--- | :--- |
| `[SPEC-012] Multi-Currency Dashboard` | `@dev-backend-1` | Swapped for `SPEC-015` (Founder Priority) | `feature/SPEC-012-currency` | `2026-10-22` |

---

## ✅ Recently Shipped to MAIN (Last 10 Completed Specs)

| Spec / Issue | Developer | Status | Completed Date |
| :--- | :--- | :--- | :--- |
| `[SPEC-014] Tenant RBAC Enforcement` | `@dev-backend-1` | `SHIPPED (MAIN)` | `2026-10-20` |
| `[SPEC-013] Mobile Push Notification Token Sync` | `@dev-mobile-1` | `SHIPPED (MAIN)` | `2026-10-18` |
