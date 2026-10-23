# 1-Page Feature Specification: `SPEC-XXX`

- **Title:** `[Short Descriptive Title]`
- **Author:** `@github-handle`
- **Status:** `Draft` | `Approved` | `Contract-Locked` | `In-Implementation` | `Shipped`
- **Created:** `YYYY-MM-DD`
- **Approved By (CTO/Tech Lead):** `@cto-handle`

---

## 1. Problem & Intent (Why)
*In 2–4 sentences, explain the user problem or business requirement. If originated from an executive triage card, link `TRIAGE-XXX`.*

## 2. Non-Goals (Out of Scope)
*Explicitly list what this spec does NOT do, so AI tools and developers do not over-engineer or touch unrelated legacy code.*
- ❌ `[Non-goal 1]`
- ❌ `[Non-goal 2]`

## 3. Affected Repositories & Brownfield Impact
| Repository | Stack | Existing Endpoint/Table Modified? | Summary of Changes |
| :--- | :--- | :--- | :--- |
| `[service-a]` | Node.js / TS | `[Yes - Extracted to OpenAPI / No]` | `[e.g., Implement endpoint & Prisma migration]` |
| `[service-b]` | Python / FastAPI | `[No]` | `[e.g., Consume async event & run worker]` |
| `[web-angular]` | Angular | `[No]` | `[e.g., Add standalone settings component]` |
| `[mobile-app]` | Mobile | `[No]` | `[e.g., None / Consume updated SDK]` |

## 4. Stage 2 Contract Lock & Backward Compatibility (Mandatory Before Coding)
- **OpenAPI 3.1 Diff / PR:** `[Link to contracts/openapi/... or "No HTTP API change"]`
- **Async Event Schema PR:** `[Link to contracts/events/... or "No Event change"]`
- **Database Migration Strategy (Expand-and-Contract):**
  - `[ ] No DB changes`
  - `[ ] Additive / Backward-Compatible (safe for zero-downtime deploy & live rollback)`
  - `[ ] Multi-phase migration required (Phase 1: Expand, Phase 2: Migrate, Phase 3: Contract)`
- **New Dependencies Required?** `[ ] None (Standard)` | `[ ] Yes — Approved in ADR-XXX`

## 5. SOC 2 & ISO 27001 Security, Privacy & Rollback Assessment (ISO A.8.26 / A.8.32)
- **Authentication & Authorization (Tenant Isolation):** `[Who can access this? How is cross-tenant IDOR prevented?]`
- **PII / Sensitive Data Classification:** `[ ] No PII touched` | `[ ] Touches PII/Confidential data (specify encryption & log-redaction rules)`
- **Failure / Timeout Handling:** `[What happens if downstream service fails? RFC 7807 error code]`
- **Rollback Plan:** `[Feature flag name or exact revert steps if production metrics degrade]`

## 6. Mandatory Test Matrix (Derived Before Coding — ISO 27001 A.8.29)
*AI agents must generate tests covering every scenario below (no tautological mock tests):*
- **Unit Tests (Pure Domain Logic & Edge Cases):**
  - `[ ] Test 1: [e.g., Calculates discount accurately and caps at 100%]`
  - `[ ] Test 2: [e.g., Rejects expired or already-redeemed code]`
- **Real-DB Repository Integration Tests:**
  - `[ ] Test 3: [e.g., Persists record and enforces unique constraint under concurrent writes]`
- **Contract & Security Negative Tests (HTTP / Event):**
  - `[ ] Test 4 (2xx Contract Conformance): Response matches OpenAPI 3.1 schema`
  - `[ ] Test 5 (400 Input Validation): Rejects malformed payload / extra fields with RFC 7807 error`
  - `[ ] Test 6 (401/403 IDOR & Tenant Isolation): User from Tenant A cannot access/modify Tenant B's resource`

## 7. Stage 3 Bounded PR Breakdown (Each PR Must Be `< 400 LOC` Including Tests)
- [ ] **PR 1 (Contract Lock):** Extract/Update OpenAPI or Event schema in `Plant-A-Virtual-CTO` & regenerate SDKs.
- [ ] **PR 2 (Data & Domain Layer):** Backward-compatible DB migration + real-DB repository tests + domain unit tests (`~280 LOC`).
- [ ] **PR 3 (API / Controller Wiring):** Expose endpoint behind feature flag + OpenAPI contract & IDOR security integration tests (`~220 LOC`).
- [ ] **PR 4 (Client UI):** Angular / Mobile UI integration + contract-mock component tests (`~300 LOC`).

