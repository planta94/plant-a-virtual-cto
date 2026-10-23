# Full-Fledged Testing Strategy & Standards (Anti-AI-Hallucination)

## Why Traditional Testing Fails With AI Coding Tools

When developers ask AI tools (Copilot, Codex, Antigravity, Cursor) to *"Write unit tests for my code"* **after** writing the code, AI defaults to the **"AI Mock Trap"**:
1. It reads the potentially buggy implementation it just wrote.
2. It mocks the database/ORM and internal collaborators to return hardcoded data.
3. It asserts that the mock returned what the mock was told to return.

Result: **95% line coverage that catches 0% of real production bugs** (broken SQL queries, missing DB migrations, OpenAPI contract drift, cross-tenant IDOR leaks, and Angular/Mobile serialization errors).

---

## Our 5-Layer Testing Trophy (Mandatory Across All Repos)

```text
                    ┌───────────────────────────────────┐
                    │   Layer 5: Critical-Path E2E      │  (Playwright / Maestro)
                 ┌──┴───────────────────────────────────┴──┐
                 │  Layer 4: OpenAPI Contract & Security   │  (2xx Schema + 400 + 401/403 IDOR)
              ┌──┴─────────────────────────────────────────┴──┐
              │ Layer 3: Real-DB Integration (No Mocked ORMs) │  (Testcontainers / CI Postgres)
           ┌──┴───────────────────────────────────────────────┴──┐
           │     Layer 2: Pure Domain Unit Tests (>=85% Diff)    │  (Zero I/O, Zero Internal Mocks)
        ┌──┴─────────────────────────────────────────────────────┴──┐
        │   Layer 1: Spec-Derived Test Matrix (Before Coding)       │  (Section 6 of SPEC-XXX)
        └───────────────────────────────────────────────────────────┘
```

---

## Detailed Rules by Layer

### Layer 1: Spec-Derived Test Matrix (Stage 1 — Before Code)
Every `SPEC-XXX` (`specs/TEMPLATE-1PAGE-SPEC.md`, Section 6) defines the required test cases **before** implementation code is written. When prompting an AI tool to write tests, **always feed it `SPEC-XXX` and the OpenAPI contract**, never just the implementation file.

### Layer 2: Pure Domain Unit Tests (`services/`, Utils, Signals/Pipes)
- **What to test:** Business rules, pricing/discount math, state machine transitions, permission evaluators, and Angular computed signals/pipes.
- **The Anti-Mock Rule:**
  - ❌ **BANNED:** Mocking Prisma/SQLAlchemy/Repositories and asserting `expect(repo.save).toHaveBeenCalled()` without testing actual business outcomes.
  - ✅ **ALLOWED:** Mocking external third-party boundaries (Stripe, SendGrid, AWS S3, external LLM APIs, system clock).
- **Coverage Gate:** CI enforces **`>= 85%` Diff Coverage** on modified lines (`diff-cover`). You do not need to backfill 85% coverage on untouched legacy files in `Service A`, only on the code touched in your PR.

### Layer 3: Real-Database & Repository Integration Tests
- **What to test:** Repository queries, transactions, unique constraints, pagination cursors, and Expand-and-Contract migrations.
- **How it runs:** Against a real ephemeral PostgreSQL/MySQL/Redis instance (via Docker `Testcontainers` locally and the `services: postgres` container in `Gate 3` of `.github/workflows/reusable-sdge-gates.yml`).
- **Why:** Catches invalid SQL syntax, N+1 queries, missing indexes, and ORM mapping bugs that mocked repositories completely miss.

### Layer 4: Contract Conformance & Security Negative Tests (ISO 27001 A.8.29)
Every new or modified HTTP endpoint or Async Event handler must include an integration test suite (`supertest` in Node.js / `httpx.AsyncClient` + `schemathesis` in Python) that proves 4 mandatory assertions:
1. **2xx Contract Conformance:** Response status, headers, and JSON body strictly validate against `contracts/openapi/<service>.openapi.yaml`.
2. **400 Input Validation Gate:** Sending invalid types, missing required fields, or unapproved extra fields (`additionalProperties: false`) returns `400 Bad Request` in **RFC 7807 Problem Details** format (`application/problem+json`).
3. **401 Unauthenticated Gate:** Missing or expired token returns `401 Unauthorized`.
4. **403 / 404 Cross-Tenant IDOR Security Gate (Mandatory for SOC 2 CC6.1):** Authenticated user belonging to `Tenant A` attempting to read, update, or delete a resource owned by `Tenant B` is rejected (`403` or `404`).

### Layer 5: Contract-Mocked Client Tests (Angular/Mobile) & Critical-Path E2E
- **Angular & Mobile Component Integration Tests:**
  - Never hand-type fake JSON responses in frontend tests (if a developer invents fake JSON, the test passes while production breaks).
  - Use **MSW (Mock Service Worker)** or **Stoplight Prism** fed directly by `contracts/openapi/<service>.openapi.yaml`.
- **Critical-Journey E2E Tests (Playwright for Angular / Maestro for Mobile):**
  - Keep E2E tests focused on the **Top 5–10 Critical Business Flows** (Login/MFA, Core Transaction/Checkout, Tenant Switching, Role Permissions).

---

## Copy-Paste AI Prompts for Full-Fledged Testing

### 1. Brownfield Characterization Test Prompt (Before Modifying `Service A`)
> *"Read `AGENTS.md`. I am about to modify `POST /v1/orders` in `service-a` for `SPEC-012`. Before I change any production code, write an HTTP integration test locking the current production behavior of `POST /v1/orders` (happy path and error cases) so we guarantee zero regressions for live Angular and Mobile clients."*

### 2. Spec-Derived Domain & Real-DB Integration Test Prompt
> *"Read `AGENTS.md` and Section 6 (Mandatory Test Matrix) of `specs/SPEC-012.md`. Write the unit tests and real-DB repository integration tests for every scenario listed in Section 6. Do NOT mock the ORM/database in repository tests—use the test database connection. Only mock external third-party HTTP APIs."*

### 3. Contract & SOC 2 IDOR Security Test Prompt
> *"Read `AGENTS.md` and `contracts/openapi/service-b.openapi.yaml`. Write the HTTP contract and security integration tests for `[endpoint]`. Verify: (1) 2xx response validates against the OpenAPI schema, (2) 400 malformed payload returns RFC 7807 ProblemDetails without stack traces, (3) 401 unauthenticated rejection, and (4) 403/404 IDOR test proving a user from Tenant A cannot access Tenant B's data."*
