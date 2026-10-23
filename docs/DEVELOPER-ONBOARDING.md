# Developer Onboarding: Working with AI Tools in SDGE

You have full freedom to use your preferred AI coding assistant (**Antigravity, GitHub Copilot, OpenAI Codex, Cursor, or Claude Code**). Every repository is pre-configured with `AGENTS.md` (and tool-specific bridges in `.github/copilot-instructions.md`, `.gemini/rules/`, `.cursorrules`, and `CLAUDE.md`) so your AI assistant automatically knows our architecture and Golden Stack.

---

## Quick Decision Tree: Which Track Am I On?

```
Is your change < 100 LOC AND touches ZERO dependencies, DB schemas, or API/Event contracts?
 ├── YES ──► FAST TRACK: Open PR directly with [FAST-TRACK] checked.
 └── NO  ──► SPEC TRACK: Follow the 4 Stages below (1-Page Spec -> Contract -> Stacked PRs < 400 LOC).
```

---

## Copy-Paste AI Prompts for Each Stage

Instead of asking your AI tool to *"Build feature X"* in one giant prompt (which produces 2,000 lines of unreviewable code that fails CI), use these four stage-specific prompts:

### Stage 1: Draft a 1-Page Spec in 5 Minutes
> **Prompt:**
> *"Read `AGENTS.md` and `specs/TEMPLATE-1PAGE-SPEC.md`. I need to build [describe feature in 2–3 sentences]. Draft a concise 1-Page Spec (`specs/SPEC-XXX-feature-name.md`) identifying the affected repositories, required OpenAPI/Event contract changes, DB schema changes, failure modes, and a breakdown of stacked PRs where every PR is under 400 LOC."*

### Stage 2: Lock the OpenAPI 3.1 / Event Contract First
> **Prompt:**
> *"Based on approved `specs/SPEC-XXX.md`, update the OpenAPI 3.1 contract in `contracts/openapi/<service>.openapi.yaml` (or event schema in `contracts/events/`) following `contracts/openapi/service-template.openapi.yaml`. Ensure all error responses use `$ref: '#/components/responses/ProblemDetailsError'` and strict `additionalProperties: false`."*

*(Once merged, run `./scripts/generate-sdk.sh` so Node, Python, Angular, and Mobile all share the exact generated types.)*

### Stage 3: Implement One Bounded PR at a Time (`< 400 LOC`)
> **Prompt:**
> *"Read `AGENTS.md` and `specs/SPEC-XXX.md`. Implement ONLY **PR #2** from the Spec Breakdown (`[e.g., Service & Repository layer]`). Strictly obey the Golden Stack and Banned Patterns in `AGENTS.md`. Do not add any new packages to `package.json`/`pyproject.toml`, use the generated contract types, write unit tests, and keep the total diff under 350 lines."*

### Stage 4: Pre-PR Self-Review via AI
> **Prompt:**
> *"Review my current `git diff` against every rule in `AGENTS.md`. Flag any banned patterns, missing strict types, unhandled errors, duplicate DTOs, or files that push this PR over 400 LOC."*

---

## Why CI Might Block Your PR (And How to Fix It)

| CI Gate Failure | Cause | Fix |
| :--- | :--- | :--- |
| **`PR exceeds the 400 LOC hard limit`** | AI generated too many changes in a single branch. | Split the branch into 2 stacked PRs (e.g., data/domain layer first, controller/UI second). |
| **`Spec-Track PRs MUST reference SPEC-XXX`** | PR is `>= 100 LOC` or touches DB/Contracts/Deps without a Spec ID. | Add your approved `SPEC-XXX` ID to the PR title or body. |
| **`Dependency manifest modified without ADR-XXX`** | AI added a library to `package.json`, `pyproject.toml`, or `pubspec.yaml`. | Remove the package and use the Golden Stack, OR submit a 20-line `docs/adr/ADR-XXX.md` for CTO approval. |
| **`Missing AI-Review Sign-Off Checkbox`** | The accountability checkbox in the PR template wasn't ticked. | Review every line of your diff and check `[x] I have read, understood, and verified every line...` |
