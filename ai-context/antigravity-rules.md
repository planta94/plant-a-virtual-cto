---
description: Mandatory engineering standards, Golden Stack constraints, and Spec-Driven lifecycle rules for all microservices and frontends.
globs: "**/*"
alwaysApply: true
---

# Antigravity & AI Agent Workspace Rules

You must strictly adhere to [`AGENTS.md`](../../AGENTS.md) in the repository root.

## Mandatory Pre-Coding Checks
1. **Check the Track Before Writing Code:**
   - If the requested change is `>= 100 LOC`, introduces a feature, or modifies API contracts, DB schemas, or dependencies, verify that a `SPEC-XXX` exists or offer to generate a 1-Page Spec using `specs/TEMPLATE-1PAGE-SPEC.md` first.
   - If the user is triaging a sudden executive/founder idea, use the workflow in `ai-context/triage-boss-idea.skill.md` and `specs/TEMPLATE-BOSS-TRIAGE.md`.
2. **Enforce Contract-First Development:**
   - Any cross-service REST API or async event modification must update the OpenAPI 3.1 YAML or JSON Schema contract first.
3. **Obey Dependency Lock:**
   - Never run `npm install <new-pkg>`, `pip install <new-pkg>`, `uv add <new-pkg>`, or `flutter pub add <new-pkg>` without explicit user confirmation and an `ADR-XXX` justification.
4. **Enforce PR Size Limits:**
   - Structure implementation plans into stacked PRs where each PR is `< 400 LOC`.
