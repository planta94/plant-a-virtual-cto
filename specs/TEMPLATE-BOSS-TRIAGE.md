# Executive Idea Triage & Swap Card: `TRIAGE-XXX`

- **Date / Time:** `YYYY-MM-DD HH:MM`
- **Requested By:** `[CEO / Founder / Stakeholder]`
- **Triaged By:** `[CTO / Tech Lead]`
- **Target Track:** `[ ] Production Microservice Feature` | `[ ] Isolated Sandbox PoC (Throwaway)`

---

## 1. The Idea in One Sentence
> *State the exact business outcome and user behavior requested on the fly.*

## 2. Recommended Scope (Fastest Path to Value)
- **What we WILL build now (MVP):**
  - `[Bullet 1]`
  - `[Bullet 2]`
- **What we will cut/defer to keep delivery fast:**
  - `[Deferred item 1]`

## 3. Microservice & Contract Blast Radius
| Layer | Affected Repo(s) | Impact Summary |
| :--- | :--- | :--- |
| **Contracts** | `Plant-A-Virtual-CTO/contracts` | `[e.g., 1 new POST endpoint in OpenAPI 3.1]` |
| **Backend (Node/TS)** | `[e.g., order-service]` | `[e.g., New service method + DB column]` |
| **Backend (Python)** | `[e.g., ai-service / None]` | `[e.g., New prompt pipeline endpoint]` |
| **Web (Angular)** | `[e.g., web-portal]` | `[e.g., 1 new standalone component + Signal state]` |
| **Mobile** | `[e.g., mobile-app / None]` | `[e.g., No mobile changes in MVP]` |

## 4. Effort & Delivery Forecast
- **Estimated Effort:** `[e.g., 3 Days (3 Bounded PRs < 400 LOC)]`
- **Earliest Ship Date (if started today):** `YYYY-MM-DD`

---

## 5. The "Swap, Don't Stack" Decision (Requires Boss Sign-Off)

Because each engineer works on **1 active Spec at a time** to guarantee predictable delivery and zero broken microservices, choose one option below:

- [ ] **Option A — Queue Next (Zero Disruption):** Put this at **#1 in the Ready Queue**. `@dev-X` starts immediately after finishing `SPEC-YYY` on `YYYY-MM-DD`.
- [ ] **Option B — Immediate Swap (Pause Current Work):** `@dev-X` pauses `SPEC-YYY` today (delaying `SPEC-YYY` by ~`N` days) and starts `TRIAGE-XXX` immediately.
- [ ] **Option C — Throwaway Sandbox PoC Only (1 Day):** Build a mocked UI/script in the `sandbox` repo by tomorrow to test the concept; do not touch production microservices yet.

