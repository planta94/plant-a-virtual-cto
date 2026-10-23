# Operational Playbook: Maintaining "Service A" vs. Building "Service B" From Scratch

This guide provides the exact step-by-step workflows, commands, and AI prompts for two real-world scenarios:
1. **Scenario 1: Maintaining `Service A`** (an existing microservice already running in production).
2. **Scenario 2: Starting `Service B` From Scratch** (a brand-new greenfield microservice).

---

## Prerequisite: Central Hub Setup (One-Time, 10 Minutes)

Before working on `Service A` or `Service B`, your central `Plant-A-Virtual-CTO` repository is hosted on GitHub (can start under your **Personal GitHub Account** with colleagues invited as **Collaborators**, and later transfer to a GitHub Organization before your SOC 2 / ISO 27001 audit).

```text
Your GitHub Account / Org
├── Plant-A-Virtual-CTO/        <-- Central Hub (Specs, OpenAPI Contracts, ADRs, AI Rules, WIP Queue)
├── service-a/                    <-- Existing Brownfield Production Microservice
├── service-b/                    <-- Brand-New Greenfield Microservice
├── web-angular/                  <-- Angular Frontend
└── mobile-app/                   <-- Mobile Client
```

---

## Scenario 1: Maintaining "Service A" (Existing Production Service)

`Service A` is already in production. It has legacy code, existing database tables, and undocumented endpoints. **You do NOT rewrite `Service A` or write OpenAPI contracts for all its existing endpoints at once.** Instead, you onboard it in 5 minutes and apply the **"Touch It, Standardize It"** rule.

### Step 0: One-Time Onboarding of `Service A` (5 Minutes)

1. Clone `Plant-A-Virtual-CTO` and `service-a` side-by-side on your machine.
2. Run the sync script from `Plant-A-Virtual-CTO`:
   ```powershell
   # Windows PowerShell (use -Stack "node" or -Stack "python")
   .\scripts\sync-microservice.ps1 -TargetRepoPath "..\service-a" -Stack "node"
   ```
   ```bash
   # macOS / Linux / Git Bash
   ./scripts/sync-microservice.sh ../service-a node
   ```
3. What this installs into `service-a`:
   - `AGENTS.md`, `.github/copilot-instructions.md`, `.gemini/rules/Plant-A-Virtual-CTO.md`, `.cursorrules`, `CLAUDE.md` (every AI tool now obeys your Golden Stack and Brownfield rules).
   - `.github/CODEOWNERS` (locks `package.json` / `pyproject.toml`, DB migrations, and contracts to your review).
   - `.github/PULL_REQUEST_TEMPLATE.md` (enforces track selection and SOC 2 / ISO 27001 attestations).
   - `.github/workflows/ci-gates.yml` (runs **diff-only** linting/SAST so untouched legacy files never break CI).
4. Commit, push to `service-a`, and enable **Branch Protection** on `main` (Require 1 peer review, Require Code Owner review, Require status checks to pass).

---

### How to Work on `Service A` Day-to-Day (The 4 Cases)

#### Case 1A: Small Bugfix or Internal Tweak (`< 100 LOC`, No API/DB/Dep Changes)
*Example: Fixing a rounding bug or null check inside `Service A`.*

1. **Skip the Spec.** You qualify for the **Fast Track (`[FAST-TRACK]`)**.
2. **Prompt your AI tool (Copilot / Codex / Antigravity):**
   > *"Read `AGENTS.md`. Fix the bug in `src/services/billing.ts` where [describe issue]. Do not modify unrelated functions in this file, do not add any dependencies, follow our Golden Stack rules, and add a unit test. Keep the total diff under 100 lines."*
3. **Open PR in `service-a`:**
   - Check `[x] Fast Track ([FAST-TRACK])` and enter the bug ticket (`ISSUE-104`).
   - Check the two mandatory AI verification & SOC 2 data-privacy checkboxes.
   - CI verifies `< 100 LOC`, scans for secrets/CVEs, lints only your modified file, and merges after 1 peer review.

---

#### Case 1B: Adding a Feature or Modifying an Existing Endpoint in `Service A`
*Example: Modifying `POST /v1/orders` in `Service A` to support discount codes and saving them to the DB.*

Because this touches an API contract and database schema (or is `>= 100 LOC`), it uses the **Spec Track**:

1. **Stage 1 — Write a 1-Page Spec (`SPEC-012`) in `Plant-A-Virtual-CTO` (10 Mins):**
   - Check `specs/WIP-QUEUE.md` to confirm you have no other active Spec in progress.
   - Prompt your AI tool in `Plant-A-Virtual-CTO`:
     > *"Read `AGENTS.md` and `specs/TEMPLATE-1PAGE-SPEC.md`. Draft `specs/SPEC-012-order-discounts.md` for `service-a` to add optional `discountCode` to `POST /v1/orders`. Ensure backward compatibility for existing Angular/Mobile clients and Expand-and-Contract DB migration."*
   - CTO approves `SPEC-012` in 5 minutes.
2. **Stage 2 — "Touch It, Contract It" (Extract & Lock the Endpoint Contract First):**
   - Since `POST /v1/orders` in `Service A` is a legacy endpoint without an OpenAPI contract yet, extract ONLY that endpoint into `Plant-A-Virtual-CTO/contracts/openapi/service-a.openapi.yaml` using this AI prompt:
     > *"Follow `ai-context/reverse-engineer-contract.skill.md`. Read `src/controllers/orders.controller.ts` in `service-a`, extract the current production contract for `POST /v1/orders` into `contracts/openapi/service-a.openapi.yaml`, and add the new optional `discountCode` field without breaking existing clients."*
   - Merge the Contract PR and run `./scripts/generate-sdk.sh` so `service-a`, `web-angular`, and `mobile-app` get updated TypeScript/Dart/Python types.
3. **Stage 3 — Implement in Bounded Stacked PRs (`< 400 LOC` each) in `service-a`:**
   - **PR #1 (`SPEC-012` — DB & Repository Layer, ~180 LOC):** Add nullable `discount_code` column migration + repository query + test.
   - **PR #2 (`SPEC-012` — Service & Controller Wiring, ~220 LOC):** Wire validation, business logic, and RFC 7807 error handling using the generated contract types.
4. **Stage 4 — Automated CI & Merge:**
   - CI verifies `SPEC-012` is referenced, diff is `< 400 LOC`, no unapproved dependencies were added, no breaking OpenAPI changes occurred, and SAST/secret scans pass.

---

#### Case 1C: Production Outage at 2 AM (`[HOTFIX-TRACK]`)
*Example: A downstream payment webhook change is causing 500 errors in `Service A`.*

1. Fix the bug immediately in `service-a` (keep diff surgical, `< 200 LOC`).
2. Open PR with `[HOTFIX-TRACK]` and `INC-042` in the title/body.
3. CI bypasses the pre-implementation Spec requirement while still enforcing secret scanning and SAST.
4. **Within 24 Hours (SOC 2 / ISO 27001 A.8.32 Requirement):** Merge a retroactive `specs/SPEC-HOTFIX-042.md` in `Plant-A-Virtual-CTO` documenting root cause and permanent test coverage.

---

#### Case 1D: The Boss Has an "On-the-Fly" Idea for `Service A`
1. Run `ai-context/triage-boss-idea.skill.md` in `Plant-A-Virtual-CTO` to generate `specs/TRIAGE-005.md` in 15 minutes.
2. Show the boss the **Swap Card**: *"We can build this in `Service A` in 2 days. Should `@dev-1` finish `SPEC-012` tomorrow first (Option A), or pause `SPEC-012` today and swap (Option B)?"*

---

## Scenario 2: Starting "Service B" From Scratch (New Greenfield Service)

When building a brand-new microservice (`Service B`, e.g., a new Python `recommendation-service` or Node.js `notification-service`), you have the opportunity to build a **100% Golden Stack reference service** where backend, Angular, and Mobile developers work in parallel with zero integration friction.

```
[Step 1: 1-Page Spec] ──► [Step 2: Contract Lock & SDK Gen] ──► [Step 3: Repo Bootstrap & Sync]
                                   │                                        │
                      ┌────────────┴────────────┐                           ▼
                      ▼                         ▼             [Step 4: Stacked PRs < 400 LOC]
            (Angular & Mobile devs    (Backend dev builds        ├── PR 1: Skeleton & Config
             build UI immediately      Service B against         ├── PR 2: DB Schema & Repo
             against generated SDK)    the same contract)        └── PR 3: Domain & Routes
```

### Step 1: Approve the 1-Page Spec (`SPEC-020`) & Any Needed `ADR-XXX`
1. In `Plant-A-Virtual-CTO`, create `specs/SPEC-020-service-b-initial.md` from `specs/TEMPLATE-1PAGE-SPEC.md`.
2. Define:
   - The exact bounded responsibility of `Service B` (and what is out of scope).
   - Stack choice from the Golden Stack (e.g., **Node.js + NestJS/Fastify + Prisma** OR **Python 3.11 + FastAPI + Pydantic v2 + SQLAlchemy 2.0**).
   - Security & tenant isolation rules (ISO 27001 A.8.26).
   - Stacked PR breakdown (`PR 1` through `PR 4`, each `< 400 LOC`).
3. If `Service B` requires a package not in the Golden Stack (e.g., a vector DB client or specialized SDK), submit a 20-line `docs/adr/ADR-001-vector-client.md` and get CTO approval first.

### Step 2: Lock `Service B`'s Contracts & Generate SDKs *Before* Writing Code
1. Copy `contracts/openapi/service-template.openapi.yaml` to `contracts/openapi/service-b.openapi.yaml` (and `contracts/events/` if `Service B` emits/consumes events).
2. Prompt your AI tool:
   > *"Based on `specs/SPEC-020-service-b-initial.md`, design the complete OpenAPI 3.1 contract in `contracts/openapi/service-b.openapi.yaml`. Use RFC 7807 `ProblemDetailsError` for all error responses and strict `additionalProperties: false` on all schemas."*
3. Merge the Contract PR into `Plant-A-Virtual-CTO` and run:
   ```bash
   ./scripts/generate-sdk.sh contracts/openapi/service-b.openapi.yaml service-b
   ```
4. **Immediate Parallelization Unlock:** The Angular and Mobile developers now have the exact generated TypeScript/Dart client SDKs for `Service B` and can build the UI immediately against mock responses while `Service B` is being implemented.

### Step 3: Create `service-b` Repository & Sync Standards (2 Minutes)
1. Create the empty `service-b` repository on GitHub and clone it locally next to `Plant-A-Virtual-CTO`.
2. Run the sync script:
   ```powershell
   # Use -Stack "node" or -Stack "python"
   .\scripts\sync-microservice.ps1 -TargetRepoPath "..\service-b" -Stack "python"
   ```
3. Now `service-b` already has `AGENTS.md`, Copilot/Antigravity/Codex/Cursor/Claude rules, `CODEOWNERS`, the PR template, and the SOC 2 / ISO 27001 CI workflow before a single line of application code is written.

### Step 4: Implement `Service B` via 4 Bounded Stacked PRs (`< 400 LOC` Each)
Never let an AI tool dump a 3,000-line microservice in one giant commit. Prompt your AI tool to build `Service B` in 4 clean, reviewable PRs referencing `SPEC-020` (and `ADR-001` on PR #1 for initial dependencies):

* **PR #1 (`SPEC-020` / `ADR-001` — Service Skeleton, Config & Healthcheck, `~200 LOC`):**
  > *"Read `AGENTS.md` and `specs/SPEC-020-service-b-initial.md`. Generate PR #1: initialize the project structure (`controllers/`, `services/`, `repositories/`, `config/`), strict TypeScript/Mypy config, validated environment variable loader, RFC 7807 global exception filter, and `/health` endpoint. Keep total non-lockfile lines under 250 LOC."*
* **PR #2 (`SPEC-020` — Database Schema, Migrations & Repository Layer, `~250 LOC`):**
  > *"Read `AGENTS.md` and `specs/SPEC-020-service-b-initial.md`. Generate PR #2: implement the database schema/migration and the `repositories/` data-access layer with unit tests. No business logic or HTTP controllers in this PR. Keep under 300 LOC."*
* **PR #3 (`SPEC-020` — Domain Service Logic, `~250 LOC`):**
  > *"Read `AGENTS.md` and `specs/SPEC-020-service-b-initial.md`. Generate PR #3: implement the `services/` domain logic layer and unit tests covering all edge cases and failure modes listed in Section 5 of `SPEC-020`. Keep under 300 LOC."*
* **PR #4 (`SPEC-020` — API Controllers & Contract Integration Tests, `~250 LOC`):**
  > *"Read `AGENTS.md` and `contracts/openapi/service-b.openapi.yaml`. Generate PR #4: wire the HTTP controllers/routes using the generated contract models, enforce auth/tenant guards, and add integration tests verifying 200/201/400/401/409 responses match the OpenAPI contract. Keep under 300 LOC."*

---

## Summary Comparison: Service A vs. Service B

| Dimension | Maintaining `Service A` (Brownfield) | Building `Service B` (Greenfield) |
| :--- | :--- | :--- |
| **Initial Setup** | Run `sync-microservice.ps1` (5 mins; zero existing code broken) | Create repo + run `sync-microservice.ps1` on Day 1 |
| **Small Bugfixes (`< 100 LOC`)** | **Fast Track (`[FAST-TRACK]`)** — straight to PR with Issue ID | **Fast Track (`[FAST-TRACK]`)** — straight to PR with Issue ID |
| **New Features / API Changes** | **Spec Track (`SPEC-XXX`)** | **Spec Track (`SPEC-XXX`)** |
| **API Contracts** | **"Touch It, Contract It"** — extract only the endpoint being modified | **100% Contract-First** — full OpenAPI 3.1 locked before PR #1 |
| **CI Linting & SAST** | **Diff-Only** (checks only modified files so legacy debt doesn't block PRs) | **100% Repo Strict** (every file created under Golden Stack rules) |
| **Database Changes** | **Expand-and-Contract** (zero-downtime backward-compatible migrations) | Clean initial migration in PR #2 |
| **Max PR Size** | `< 400 LOC` per PR | `< 400 LOC` per PR (built in 4 stacked PRs) |

