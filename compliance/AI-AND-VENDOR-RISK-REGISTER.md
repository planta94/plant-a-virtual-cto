# AI Coding Tools & Third-Party Vendor Risk Register (SOC 2 CC9.2 / ISO 27001 A.5.19–A.5.23)

> **Auditor Purpose:** Modern SOC 2 and ISO/IEC 27001:2022 auditors explicitly ask: *"Since your developers use multiple AI coding tools (Copilot, Codex, Antigravity, Cursor, Claude Code), how do you prevent proprietary code or customer PII from being used to train public foundation models?"*
> This register documents our mandatory privacy/opt-out settings and vendor risk assessments across all AI tools and cloud subprocessors.

---

## 1. Approved AI Coding Tools & Mandatory Privacy Lockdown Settings

Every developer using an AI coding assistant on company repositories **MUST** verify that the following **Zero Training / Privacy Mode** settings are enabled before opening a Pull Request:

| AI Coding Tool | Approved Tier / Mode | Mandatory Privacy / Zero-Training Setting | Allowed Data Scope | Verified By / Frequency |
| :--- | :--- | :--- | :--- | :--- |
| **GitHub Copilot** | Copilot Business / Enterprise (or Individual with Training Opt-Out) | **Settings → Copilot → "Allow GitHub to use my code snippets for product improvements" = OFF (Unchecked)** | Source code & synthetic test fixtures only. Never production DB dumps or `.env` secrets. | CTO / Quarterly |
| **OpenAI Codex / ChatGPT** | Team / Enterprise / API Key (or Opted-Out Account) | **Settings → Data Controls → "Improve the model for everyone" = OFF** (API usage is zero-training by default) | Source code & OpenAPI contracts. No customer PII. | CTO / Quarterly |
| **Google Antigravity** | Workspace / Enterprise / Opted-Out Mode | Verify workspace privacy settings; `.gemini/rules/` enforces zero secret/PII injection in prompts. | Source code, specs, and local workspace files excluding `.env*`. | CTO / Quarterly |
| **Cursor** | Cursor Pro / Business | **Cursor Settings → General → Privacy Mode = "Enabled (Zero Data Retention)"** (No code stored or trained by Cursor/LLM providers) | Source code & specs. `.cursorignore` blocks `.env*` and `*.pem`. | CTO / Quarterly |
| **Claude Code (Anthropic)** | Anthropic API / Claude for Work / Team | API & Team plans prohibit training on customer prompts by default. Verify consumer web chat is not used for proprietary code. | Source code, specs, and local test runs. | CTO / Quarterly |

### Mandatory `.aiignore` / `.cursorignore` Baseline
All microservice repositories must ignore sensitive files from AI context indexing:
```gitignore
.env
.env.*
!.env.example
*.pem
*.key
*.p12
secrets/
compliance/evidence-bundles/
```

---

## 2. Core Infrastructure & SaaS Subprocessor Register (ISO 27001 A.5.19)

| Vendor Name | Category | Data Processed | Compliance Certifications Verified | Risk Level | Last Reviewed Date | Reviewer |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **GitHub, Inc.** | Source Control & CI/CD | Source code, CI logs, PR audit trail | SOC 2 Type II, ISO 27001 | Critical | `YYYY-MM-DD` | `@cto-handle` |
| **AWS / GCP / Azure** | Cloud Hosting & Managed DB | Production app data, customer PII, encrypted backups | SOC 2 Type II, ISO 27001 | Critical | `YYYY-MM-DD` | `@cto-handle` |
| **OpenAI, LLC** | AI Coding / LLM API | Code snippets (Zero-training opted out) | SOC 2 Type II | Medium | `YYYY-MM-DD` | `@cto-handle` |
| **Anthropic, PBC** | AI Coding / Claude API | Code snippets (Zero-training API/Team) | SOC 2 Type II, ISO 27001 | Medium | `YYYY-MM-DD` | `@cto-handle` |
| **Anysphere (Cursor)** | AI IDE | Ephemeral code context (`Privacy Mode = ON`) | SOC 2 Type II | Medium | `YYYY-MM-DD` | `@cto-handle` |
