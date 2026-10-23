# GitHub Copilot Repository Instructions

Always read and strictly enforce all rules defined in [`AGENTS.md`](../AGENTS.md) at the root of this repository.

## Non-Negotiable Constraints for Copilot
1. **Follow the Golden Stack in `AGENTS.md`:**
   - **Node.js / TypeScript:** Strict TypeScript (`noImplicitAny`, no `any`), layered architecture (`Controller -> Service -> Repository`), native `fetch` or internal HTTP wrapper, RFC 7807 error format.
   - **Python:** FastAPI, Pydantic v2 (`model_validate`, `ConfigDict`), SQLAlchemy 2.0 async, complete type annotations (`mypy --strict`), `ruff` compliance.
   - **Angular:** Standalone components (`standalone: true`), `ChangeDetectionStrategy.OnPush`, Angular Signals (`signal`, `computed`), OpenAPI-generated client services only.
   - **Mobile:** Generated contract models only; zero HTTP or business logic inside UI widgets/screens.
2. **Never Add Unapproved Dependencies:** Do not suggest adding new packages to `package.json`, `pyproject.toml`, `requirements.txt`, or `pubspec.yaml` unless explicitly instructed with an `ADR-XXX` reference.
3. **Contract-First:** Never hand-write API request/response DTOs that duplicate OpenAPI (`contracts/openapi/`) or Event (`contracts/events/`) schemas. Import generated types.
4. **Keep Diffs Under 400 Lines:** Propose modular, incremental changes that fit within our 400 LOC per PR gate.
