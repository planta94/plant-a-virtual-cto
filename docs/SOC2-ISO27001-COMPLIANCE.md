# SOC 2 & ISO/IEC 27001:2022 Compliance & Brownfield Guide

This document maps our **Spec-Driven, Gate-Enforced Engineering (SDGE)** lifecycle directly to **SOC 2 Trust Services Criteria** and **ISO/IEC 27001:2022 Annex A controls**, so you can hand this repository directly to an external auditor as proof of a compliant Secure SDLC—without using Agile/Scrum.

---

## 1. Control Mapping Matrix (Auditor Reference)

| Standard & Control | Requirement Summary | How Our SDGE Framework Enforces It (Audit Evidence) |
| :--- | :--- | :--- |
| **SOC 2 CC8.1**<br>**ISO 27001 A.8.32**<br>*(Change Management)* | All production changes must be authorized, documented, tested, peer-reviewed, and assessed for impact/rollback before deployment. | 1. **Gate 1 CI (`change-control-gate`)** blocks any PR lacking a traceable `SPEC-XXX`, `[FAST-TRACK]` Issue ID, or `[HOTFIX-TRACK]` Incident ID.<br>2. `specs/TEMPLATE-1PAGE-SPEC.md` records authorization (`Approved By: @cto`), rollback plan, and blast radius.<br>3. GitHub Branch Protection enforces human peer review (Segregation of Duties). |
| **ISO 27001 A.8.25**<br>*(Secure Development Life Cycle)* | Rules for the secure development of software and systems shall be established and applied. | Codified in [`AGENTS.md`](../AGENTS.md) and automatically injected into every developer's IDE & AI assistant (`Copilot`, `Antigravity`, `Codex`, `Cursor`, `Claude`) via `sync-microservice`. |
| **ISO 27001 A.8.26**<br>*(Application Security Requirements)* | Information security requirements shall be identified, specified, and approved when developing applications. | Section 5 of every `SPEC-XXX` (`specs/TEMPLATE-1PAGE-SPEC.md`) requires explicit sign-off on Authentication, Tenant Isolation (IDOR prevention), and PII classification before coding begins. |
| **ISO 27001 A.8.27**<br>*(Secure System Architecture)* | Principles for engineering secure systems shall be established, documented, and applied across layers. | Contract-first architecture (`contracts/openapi/`), strict layered boundaries (`Controller -> Service -> Repository`), and mandatory `ADR-XXX` approval (`CODEOWNERS`) for any architectural or dependency change. |
| **ISO 27001 A.8.28**<br>*(Secure Coding)* | Secure coding principles shall be applied to software development (including AI-assisted coding). | Section 3 of `AGENTS.md` enforces strict input validation, parameterized ORM queries, RFC 7807 error masking, and safe logging across Node.js, Python, Angular, and Mobile. |
| **ISO 27001 A.8.29**<br>**SOC 2 CC7.1**<br>*(Security Testing in Dev & Acceptance)* | Security testing processes shall be defined and implemented in the development life cycle. | **Gate 2 CI (`security-compliance-gate`)** runs automated **Gitleaks** (secret scanning), **Semgrep** (OWASP Top 10 SAST on changed files), and **`npm audit` / `pip-audit`** (high/critical CVE blocking) on every PR. |
| **ISO 27001 A.5.12 & A.5.15**<br>**SOC 2 Confidentiality**<br>*(AI Data Governance)* | Protection of confidential data, secrets, and PII from unauthorized disclosure to third-party AI models. | Mandatory PR sign-off enforced by Gate 1 CI: *"`[x]` No production secrets, customer PII, or proprietary credentials were shared with external AI tools or committed."* |
| **ISO 27001 A.8.32**<br>*(Emergency Changes)* | Emergency changes (hotfixes) must follow a controlled process with retroactive authorization and review. | **`[HOTFIX-TRACK]`** in Gate 1 CI caps emergency diffs at `< 200 LOC`, still runs secret/security scans, and mandates a retroactive `SPEC-HOTFIX-XXX` within 24 hours. |

---

## 2. Brownfield Production Strategy: How to Adopt Without Breaking Live Services

Since you already have services shipped to production, **do not** attempt to write specs or OpenAPI contracts for existing untouched code all at once. Follow these three rules:

1. **Diff-Only CI Gates (Zero Legacy Halt):**
   - Look at `Gate 3 (brownfield-quality-gate)` in [`.github/workflows/reusable-sdge-gates.yml`](../.github/workflows/reusable-sdge-gates.yml): it runs `git diff --name-only` and only runs strict `ruff` / `mypy --strict` / `eslint` & Semgrep SAST against **files touched in the current PR**.
   - Untouched legacy files will **never** block a developer's PR.
2. **"Touch It, Contract It" (2-Minute AI Extraction):**
   - When a `SPEC-XXX` requires modifying an existing production endpoint that lacks an OpenAPI spec, the developer runs the [`reverse-engineer-contract.skill.md`](../ai-context/reverse-engineer-contract.skill.md) prompt.
   - The AI extracts the current live route into `contracts/openapi/` in 2 minutes so you lock the baseline before changing it.
3. **Expand-and-Contract Database Rule:**
   - Because live production instances are running, `AGENTS.md` forbids destructive schema changes (dropping/renaming columns) in the same PR as application code changes.

---

## 3. Starting with a Personal GitHub Repository (And Collaborators)

**Can you start this in a personal GitHub repository and invite colleagues as collaborators?**
**Yes.** We have configured the scripts so you can launch immediately from a personal GitHub account:

### How It Works in a Personal Repo Setup:
1. **Self-Contained CI Workflow Sync (Bypassing GitHub's Personal Repo Limitation):**
   - GitHub blocks *private personal repositories* from sharing reusable workflows (`workflow_call`) across repos.
   - To make sure your CI gates work out-of-the-box on a personal account, `scripts/sync-microservice.ps1` and `scripts/sync-microservice.sh` copy the **complete, self-contained workflow** directly into `.github/workflows/ci-gates.yml` in each microservice repo.
2. **`CODEOWNERS` Format for Personal Repos:**
   - In a personal repo, GitHub `CODEOWNERS` supports individual usernames (e.g., `@your-github-username`) rather than `@org/team-name`. Keep `@your-github-username` in `CODEOWNERS`.
3. **Transitioning for Your Official SOC 2 / ISO 27001 Audit:**
   - Using a personal repo with collaborators is great for your **Rollout Pilot (Weeks 1–4)**.
   - Before your formal SOC 2 / ISO 27001 audit window begins, use GitHub's **Settings → Transfer ownership** to move the repo into a **GitHub Organization** (even the Free tier works). Auditors require company-owned repositories under an Organization so access can be centrally revoked when an employee offboards (SOC 2 CC6.2 / ISO 27001 A.5.18).
