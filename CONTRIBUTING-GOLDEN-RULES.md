# Contributing to the Golden Rules & Shared AI Brain (`AGENTS.md`)

> **Every Developer Owns Our Engineering Standards.**
> `AGENTS.md` is not a static top-down rulebook—it is our team's **Compound AI Memory**. Whenever you catch an AI tool (Copilot, Codex, Antigravity, Cursor, Claude) making a mistake, hallucinating a bad pattern, or when you discover a prompt/pattern that saves time, **contribute it back here so every developer's AI tool gets smarter immediately.**

---

## How the "Compound AI Memory Loop" Works

```text
[1. Developer Spots AI Mistake or Better Pattern]
                       │
                       ▼
[2. Opens a 5-Line PR in Plant-A-Virtual-CTO]  (Uses propose-golden-rule.skill.md)
   • Updates AGENTS.md (Golden Stack / Banned Pattern)
   • Or adds a reusable prompt in ai-context/*.skill.md
   • Or adds a canonical code snippet in golden-examples/
   • Or proposes a new library in docs/adr/ADR-XXX.md
                       │
                       ▼
[3. Fast Peer + CTO Review (60 Seconds)]         (Protected by CODEOWNERS)
                       │
                       ▼
[4. Auto-Broadcast GitHub Action Fires]          (.github/workflows/auto-broadcast-standards.yml)
   Automatically updates AGENTS.md, .github/copilot-instructions.md,
   .gemini/rules/, .cursorrules, and CLAUDE.md across ALL microservice,
   Angular, and Mobile repositories!
```

---

## 4 Ways Developers Should Contribute

### 1. Add a "Golden Rule" or "Banned Pattern" to `AGENTS.md`
**When to do this:**
- Your AI tool wrote code that caused a bug, failed review, or used an outdated idiom (e.g., *"Copilot used RxJS `.toPromise()` instead of `firstValueFrom()` in Angular"* or *"Codex forgot to filter by `tenant_id` in a SQLAlchemy query"*).
- During PR review, you and a teammate agree on a cleaner convention.

**How to submit (Takes 2 Minutes):**
Ask your AI tool:
> *"Follow `ai-context/propose-golden-rule.skill.md`. Draft a 2-line addition to `AGENTS.md` banning [X] and requiring [Y] in the [Node/Python/Angular/Mobile] section."*

---

### 2. Propose a New Library or Tool via a 20-Line ADR (`docs/adr/ADR-XXX.md`)
**When to do this:**
- You want to add a new npm/PyPI/Pub package or adopt a new architectural tool that isn't in `AGENTS.md` yet.

**How to submit:**
1. Copy `docs/adr/TEMPLATE-ADR.md` to `docs/adr/ADR-XXX-short-title.md`.
2. In the **same PR**, add the approved package/rule to `AGENTS.md`.
3. Open a PR in `Plant-A-Virtual-CTO`. Once the CTO approves and merges, you can use `ADR-XXX` in your microservice PRs without CI blocking your dependency manifest.

---

### 3. Share a High-Leverage AI Skill / Prompt (`ai-context/*.skill.md`)
**When to do this:**
- You figured out a great prompt sequence that makes Copilot, Codex, or Antigravity generate perfect boilerplate (e.g., `scaffold-angular-signal-page.skill.md`, `generate-prisma-migration.skill.md`, `write-idor-security-test.skill.md`).

**How to submit:**
Add a markdown file in `ai-context/<skill-name>.skill.md` and include it in `scripts/sync-microservice.ps1` / `.sh` so the whole team gets it.

---

### 4. Contribute a Canonical Code Snippet (`golden-examples/`)
**When to do this:**
- AI tools follow rules best when they can see a concrete **100-line Golden Example file**.
- If you write a particularly clean Node Controller, Python FastAPI Router, Angular Standalone Signal Component, or Mobile Repository + Test, drop a sanitized version into `golden-examples/<stack>/` and reference it in `AGENTS.md`!

