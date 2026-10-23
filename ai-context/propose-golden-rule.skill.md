---
name: propose-golden-rule
description: Turn a recurring AI coding mistake, PR review lesson, or new library proposal into a concise PR updating AGENTS.md, golden-examples/, or docs/adr/ in under 3 minutes.
---

# Skill: Propose a Golden Rule / Shared AI Memory Update

Use this skill whenever a developer notices an AI coding assistant (Copilot, Codex, Antigravity, Cursor, Claude) generating suboptimal code, or when the team agrees on a new convention/library during code review.

## Instructions for the AI Agent

1. **Identify the Contribution Type:**
   - **Type A — Golden Rule / Banned Pattern (`AGENTS.md`):** No new third-party dependency is needed; we are tightening coding, security, or testing rules for Node.js, Python, Angular, or Mobile.
   - **Type B — New Dependency or Architecture Change (`docs/adr/ADR-XXX.md` + `AGENTS.md`):** Introduces a new package or architectural pattern.
   - **Type C — Golden Reference Snippet (`golden-examples/`):** Adds a canonical code example for AI tools to copy.

2. **Draft the Exact Change Concisely:**
   - Rules in `AGENTS.md` must be **imperative, unambiguous, and 1–2 lines long** (AI models follow short, explicit rules far better than long paragraphs).
   - Bad rule: *"We should generally try to avoid using synchronous calls when we are in async Python endpoints."*
   - Good rule: *"❌ Blocking synchronous I/O (`requests.get`, `time.sleep`) inside `async def` endpoints; always use `httpx.AsyncClient` and `asyncio.sleep`."*

3. **If Type B (New Dependency/Pattern), Also Generate the 20-Line ADR:**
   - Populate `docs/adr/ADR-XXX-<slug>.md` from `docs/adr/TEMPLATE-ADR.md`, including license check (must be MIT/Apache-2.0/BSD—no GPL/AGPL for SOC 2 / ISO 27001 compliance) and CVE status.

4. **Generate the PR Description:**
   - Output a ready-to-paste PR title and description following `.github/PULL_REQUEST_TEMPLATE.md` in `Plant-A-Virtual-CTO`.

