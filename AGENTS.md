# Engineering Standards, Security, Testing & AI Context (`AGENTS.md`)

> **SINGLE SOURCE OF TRUTH FOR ALL AI AGENTS & DEVELOPERS**
> Every AI coding assistant (Antigravity, GitHub Copilot, OpenAI Codex, Cursor, Claude Code) and every human engineer MUST follow the rules in this file.
> **Compliance Mandate:** This repository and all connected production microservices operate under **SOC 2 (CC6, CC7, CC8)** and **ISO/IEC 27001:2022 (Annex A.8.25–A.8.32)** Secure SDLC controls.

---

## 1. The Core Lifecycle Law (3-Track Spec-Driven Engineering)

We do not use Scrum, story points, or daily standups. We use **Spec-Driven, Gate-Enforced Engineering (SDGE)** with full auditability for SOC 2 and ISO 27001.

### 1.1 The Three-Track Rule (Every PR Must Declare One Track)

1. **Fast Track (`[FAST-TRACK]` — Small Maintenance & Bugfixes):**
   - **Criteria:** `< 100 lines of code (LOC)` changed AND **zero changes** to:
     - Dependencies (`package.json`, `pyproject.toml`, `requirements.txt`, `pubspec.yaml`)
     - Database schemas / migrations
     - Cross-service API contracts (OpenAPI) or Event schemas (JSON Schema)
     - Authentication, authorization, encryption, or security middleware
   - **Audit & Test Requirement:** Must reference an Issue/Bug ID (e.g., `ISSUE-123`), include a regression unit test proving the bug is fixed, and pass automated CI + 1 human peer review.

2. **Spec Track (`SPEC-XXX` — Standard Feature & Architecture Track):**
   - **Criteria:** Any change `>= 100 LOC`, any new feature, or any change touching dependencies, DB schemas, auth/security, or API/Event contracts.
   - **Stage 1 — 1-Page Spec (`SPEC-XXX`):** Draft and merge a 1-page spec in `specs/` (including Security Impact & Mandatory Test Matrix) before writing implementation code.
   - **Stage 2 — Contract Lock:** Merge OpenAPI 3.1 (`contracts/openapi/`) or JSON Schema event changes (`contracts/events/`) first.
   - **Stage 3 — Bounded Implementation + Full Testing:** Write code + tests in stacked PRs. **Hard limit: Max 400 LOC per PR** (excluding lockfiles and generated SDKs).
   - **Stage 4 — Automated CI & Peer Review:** All SAST, secret scan, contract diff, test coverage, and quality gates must pass + human peer approval.

3. **Emergency Hotfix Track (`[HOTFIX-TRACK]` — SOC 2 / ISO 27001 Emergency Change Control):**
   - **Criteria:** Critical production outage (SEV-1/SEV-2) or active security vulnerability patch requiring immediate remediation.
   - **Process:** May bypass pre-implementation Spec creation to restore production, **provided**:
     - Diff is strictly limited to fixing the incident (`< 200 LOC`).
     - All automated security/secret gates pass.
     - **Mandatory Post-Condition:** A retroactive `SPEC-HOTFIX-XXX` (Root Cause + Permanent Regression Test) must be merged within **24 business hours** (ISO 27001 A.8.32 Emergency Change Control).

---

## 2. Brownfield Production Rules ("Touch It, Standardize It")

Because we operate existing services in production, we apply a **Strangler / Boy Scout Rule** rather than halting feature work for full-repo rewrites:

1. **Do Not Copy Legacy Anti-Patterns:**
   - Existing files in production may contain legacy patterns predating this standard. **AI agents MUST NOT mimic legacy patterns** found in surrounding files (such as untyped `any`, raw SQL in controllers, or deprecated Pydantic v1 methods).
   - All newly written or modified functions must strictly follow the **Golden Stack** below.
2. **"Touch an Endpoint, Lock Its Contract & Add Characterization Tests":**
   - You do not need to write OpenAPI specs or tests for untouched legacy endpoints.
   - However, **before modifying an existing production endpoint**, extract its current contract into `contracts/openapi/` (using `ai-context/reverse-engineer-contract.skill.md`) and write a characterization/integration test locking its existing behavior so your changes do not break live clients.
3. **Zero Unrelated Refactoring in Feature PRs:**
   - Never let an AI tool reformat or refactor untouched functions in a legacy file during a feature PR. Keep diffs surgical (`< 400 LOC`).
4. **Backward Compatibility for Live Production Services:**
   - **Database Migrations (Expand-and-Contract):** Never drop or rename an active production DB column in the same release that deploys code changes.
   - **API Versioning:** Never remove required fields or change field types in live endpoints consumed by Mobile or Angular clients without versioning.

---

## 3. SOC 2 & ISO 27001 Mandatory Security Rules (ISO A.8.28 Secure Coding)

All AI agents and developers MUST enforce these security controls on every line of code:

1. **AI Data Privacy & Confidentiality (ISO A.5.12 / SOC 2 Confidentiality):**
   - **NEVER** paste production customer PII, PHI, payment data, `.env` files, private keys, JWT secrets, or proprietary production database dumps into any AI prompt or context window.
2. **Zero Secrets in Code (Enforced by Gitleaks CI Gate):**
   - Never hardcode API keys, passwords, tokens, connection strings, or private certificates—even in test files.
3. **Input Validation & Injection Prevention (OWASP Top 10):**
   - Validate all external inputs against strict schemas (Zod / Pydantic v2 / `class-validator`) with `additionalProperties: false` / `extra="forbid"`.
   - Never construct SQL, NoSQL, OS shell commands, or LLM prompts via raw string concatenation with untrusted input.
4. **Authentication, Authorization & Tenant Isolation (SOC 2 CC6.1):**
   - Every endpoint (unless explicitly marked `@Public()`) must verify authentication AND check resource-level authorization (preventing IDOR / cross-tenant data leakage).
5. **Safe Logging & Error Handling (ISO A.8.15 Logging):**
   - Never log passwords, Authorization headers, session tokens, or full PII objects.
   - Return standardized **RFC 7807 Problem Details** with a `traceId`; never leak raw stack traces to clients.
6. **Supply Chain & Dependency Lock (ISO A.8.28 / A.8.32):**
   - **NEVER** add a new package to `package.json`, `pyproject.toml`, `requirements.txt`, or `pubspec.yaml` without an approved `ADR-XXX`.

---

## 4. Golden Stack Standards by Technology

### 4.1 Node.js & TypeScript Microservices
- **Runtime & Language:** Node.js LTS + TypeScript (`strict: true`, `noImplicitAny: true`).
- **Framework:** NestJS or Fastify (match existing repo; never mix frameworks).
- **Database & ORM:** Prisma or Drizzle ORM (parameterized queries only; Expand-and-Contract migrations).
- **Testing Stack:** Vitest or Jest + Supertest + Testcontainers (real Postgres/Redis in integration tests).
- **Banned in New/Modified Code:** `any`, `@ts-ignore`, `axios` (use native `fetch` or internal client), `moment.js`, floating promises, `eval()`.

### 4.2 Python Microservices & AI/Data Services
- **Runtime & Tooling:** Python 3.11+, `ruff`, `mypy --strict` on new/modified modules.
- **Framework:** FastAPI + Pydantic v2 (`model_validate`, `ConfigDict(extra="forbid")`).
- **Database:** SQLAlchemy 2.0 async + Alembic migrations.
- **Testing Stack:** `pytest` + `pytest-asyncio` + `httpx.AsyncClient` + `schemathesis` (OpenAPI property testing).
- **Banned in New/Modified Code:** Untyped functions, Pydantic v1 `.dict()`, synchronous `requests` inside `async def` routes, `pickle.loads()` on untrusted data, bare `except:`.

### 4.3 Angular Web Frontend
- **Architecture:** Standalone Components (`standalone: true`), Angular Signals (`signal`, `computed`), `ChangeDetectionStrategy.OnPush`.
- **Testing Stack:** Vitest/Jest + Angular Testing Library + MSW (Mock Service Worker driven by OpenAPI schemas) + Playwright for critical E2E flows.
- **API Consumption:** OpenAPI-generated services/types only; never hardcode URLs or duplicate backend interfaces.

### 4.4 Mobile Applications (Flutter / React Native / Native)
- **Contract Alignment:** Consume generated OpenAPI models; handle older/newer API fields gracefully (`ignoreUnknownFields`).
- **Testing Stack:** Widget/Component tests against OpenAPI mock responses + Maestro (or integration_test) for critical device flows.
- **Secure Storage:** Store auth tokens exclusively in hardware-backed secure storage (`Keychain` / `EncryptedSharedPreferences`).

---

## 5. Full-Fledged 5-Layer Testing Standard (Anti-AI-Hallucination Rules)

AI coding tools frequently write **tautological mock tests** (mocking a function and asserting the mock returns what it was told to return). **Tautological mock tests are strictly banned.** Every feature PR must implement the appropriate layers of our **5-Layer Testing Trophy**:

1. **Layer 1 — Spec-Derived Test Cases (No Implementation Bias):**
   - Generate test cases directly from **Section 6 of `SPEC-XXX`** and the locked **OpenAPI/Event contract**, *not* by asking AI to summarize implementation code it just wrote.
2. **Layer 2 — Pure Domain Unit Tests (`>= 85%` Diff Coverage Required):**
   - Test business rules, calculations, validators, and state transitions in `services/` and UI signals/pipes.
   - **Anti-Mock Rule:** Never mock internal domain classes or the unit under test. Only mock external I/O boundaries (third-party HTTP APIs, payment gateways, LLM providers, clock/time).
3. **Layer 3 — Real-Database & Repository Integration Tests (No Mocked ORMs):**
   - Do **not** mock Prisma, Drizzle, or SQLAlchemy in repository tests—mocked ORMs hide broken SQL queries, missing migrations, and constraint violations.
   - Run repository/service integration tests against an ephemeral test database (Docker `Testcontainers` or CI service containers) with real migrations applied.
4. **Layer 4 — Contract Conformance & Security Negative Tests (ISO 27001 A.8.29):**
   - Every new or modified API endpoint MUST have automated HTTP integration tests verifying:
     - **2xx Happy Path:** Response body strictly validates against the OpenAPI 3.1 schema.
     - **400 Validation Gate:** Malformed/extra fields return RFC 7807 `application/problem+json`.
     - **401 / 403 Tenant Isolation (IDOR Security Test):** User from `Tenant A` attempting to read/modify `Tenant B`'s resource is rejected with `403` or `404`.
5. **Layer 5 — Contract-Driven Frontend/Mobile & Critical-Path E2E Tests:**
   - Angular and Mobile tests must mock network responses using payloads validated against `contracts/openapi/<service>.openapi.yaml` (via MSW / Prism), never hand-invented JSON fixtures.
   - Core revenue/auth user journeys require a passing Playwright (Web) or Maestro (Mobile) E2E smoke test.
