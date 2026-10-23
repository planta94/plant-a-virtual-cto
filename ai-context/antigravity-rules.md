---
description: Mandatory Plant-A-Virtual-CTO engineering standards, Golden Stack constraints, Contract Lock, and 5-Layer Testing rules for all microservices and frontends.
globs: "**/*"
alwaysApply: true
---

# Antigravity & AI Agent Workspace Rules (`Plant-A-Virtual-CTO`)

You must strictly adhere to the Master Technical Handover & AI Constitution in [`AGENTS.md`](../../AGENTS.md) at the repository root.

## Mandatory Pre-Coding & Execution Rules
1. **Check the Track Before Writing Code (`AGENTS.md` Section 4):**
   - If the requested change is `>= 100 LOC`, introduces a feature, or modifies API contracts, DB schemas, or dependencies, verify that a `SPEC-XXX` exists or offer to generate a 1-Page Spec using `specs/TEMPLATE-1PAGE-SPEC.md` (or `.github/ISSUE_TEMPLATE/1-page-spec.yml`) first.
   - If triaging an unplanned founder/boss request, use `ai-context/triage-boss-idea.skill.md` and `.github/ISSUE_TEMPLATE/boss-triage-swap.yml`.
   - Do **not** manually edit `specs/WIP-QUEUE.md` on feature branches; it is automatically rebuilt by `.github/workflows/wip-queue-sync.yml`.
2. **Enforce Cross-Repo Contract Safety (`AGENTS.md` Section 5):**
   - Any cross-service REST API or async event modification must update `contracts/openapi/*.yaml` or `contracts/events/*.json` first (verified by `oasdiff breaking` in CI) and regenerate SDKs via `scripts/generate-sdk.ps1` / `.sh`.
   - **Never** manually edit files inside `src/generated/contracts/`—CI Gate 1 verifies the SHA-256 hash against `CONTRACT.lock`.
3. **Brownfield ("Service A") Protection (`AGENTS.md` Section 6):**
   - Never copy legacy anti-patterns from surrounding files.
   - Before modifying an existing legacy endpoint that lacks an OpenAPI spec, run `ai-context/reverse-engineer-contract.skill.md` to lock its contract and write a characterization test.
4. **Obey Dependency Lock (`CODEOWNERS`):**
   - Never run `npm install <new-pkg>`, `pip install <new-pkg>`, `uv add <new-pkg>`, or `flutter pub add <new-pkg>` without explicit user confirmation and an `ADR-XXX` justification.
5. **5-Layer Testing & Anti-Mock Law (`AGENTS.md` Section 8):**
   - Never mock ORMs (Prisma, Drizzle, SQLAlchemy) in integration tests.
   - Every endpoint requires `2xx` schema validation, `400` RFC 7807 validation, `401` unauthenticated, and `403/404` Cross-Tenant IDOR security tests (`>= 85%` diff coverage on modified files).
6. **Branching & PR Size Limits (`AGENTS.md` Section 3):**
   - Structure implementation into stacked PRs (`< 400 LOC`) targeting `UAT` (`feature/* -> UAT -> MAIN`). If a soft rule must be bypassed for an urgent business reason, document `[CTO-OVERRIDE: <reason>]` in the PR body for CTO/Deputy approval.
