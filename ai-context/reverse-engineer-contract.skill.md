---
name: reverse-engineer-contract
description: Extract an OpenAPI 3.1 contract or JSON Schema event definition from an existing brownfield production endpoint before modifying it.
---

# Skill: Brownfield Contract Extraction ("Touch It, Contract It")

Use this skill when modifying an **existing production microservice endpoint or event** that does not yet have a formal OpenAPI 3.1 or JSON Schema contract in `contracts/`.

## Why This Matters
We have live services in production. Rather than freezing development to document every legacy route at once, we apply the **"Touch It, Contract It"** rule: whenever you need to modify an existing endpoint or event for a `SPEC-XXX`, extract its current contract in 2 minutes first.

---

## Step-by-Step Instructions for the AI Agent

1. **Locate the Existing Route & Handler:**
   - Read the existing controller/router file (NestJS, Fastify, Express, or FastAPI), request/response DTOs, validation schemas, and database entity returned by the endpoint.
2. **Capture the Exact Baseline ("As-Is" Production Behavior):**
   - Document the exact HTTP method, path, query/header/path parameters, request body fields, and response status codes currently in production.
   - Flag any existing undocumented fields that Angular or Mobile clients currently rely on so we do not accidentally introduce a breaking change.
3. **Generate or Update the OpenAPI 3.1 YAML:**
   - Add the endpoint definition to `contracts/openapi/<service-name>.openapi.yaml` following the structure in `contracts/openapi/service-template.openapi.yaml`.
4. **Propose the "To-Be" Delta Safely (Backward-Compatible):**
   - Ensure new request fields are optional (or defaulted) if Mobile clients in the wild haven't updated yet.
   - Ensure existing response fields are preserved (additive changes only, unless a new `/v2/` route is created).
