# Plant-A-Virtual-CTO

> **"Plant a Virtual CTO inside every repository so every developer's AI tool follows one shared engineering brain 24/7."**

Welcome to **`Plant-A-Virtual-CTO`**—the central governance, contract, and AI-context hub for our microservice architecture.

Instead of Agile bureaucracy (daily standups, sprints, story points) or the human CTO having to police every developer's AI prompts manually, **`Plant-A-Virtual-CTO`** plants your architectural standards, Golden Stack rules, API contracts, and SOC 2 / ISO 27001 guardrails directly into every microservice, Angular, and Mobile repository—so **GitHub Copilot, OpenAI Codex, Antigravity, Cursor, and Claude Code** act as extensions of the CTO.

---

## Architecture of `Plant-A-Virtual-CTO`

```text
Plant-A-Virtual-CTO/
├── AGENTS.md                                  # The "Virtual CTO Brain" (Single Source of Truth for all AI tools)
├── CONTRIBUTING-GOLDEN-RULES.md               # How developers teach the Virtual CTO new Golden Rules, Skills & ADRs
├── golden-examples/
│   └── README.md                              # Canonical 100-line code examples for AI tools to copy
├── ai-context/
│   ├── copilot-instructions.md                # Synced to .github/copilot-instructions.md in all repos
│   ├── antigravity-rules.md                   # Synced to .gemini/rules/Plant-A-Virtual-CTO.md
│   ├── triage-boss-idea.skill.md              # AI Skill: Converts on-the-fly founder ideas into a 1-Page Spec + Swap Card
│   ├── reverse-engineer-contract.skill.md     # AI Skill: Extracts OpenAPI contracts from existing Brownfield endpoints
│   └── propose-golden-rule.skill.md           # AI Skill: Turns an AI mistake or review lesson into a 2-line AGENTS.md PR
├── specs/
│   ├── WIP-QUEUE.md                           # Live "Swap, Don't Stack" WIP Tracker (Max 1 active spec per dev)
│   ├── TEMPLATE-BOSS-TRIAGE.md                # 30-Min Executive Triage & Trade-Off Card
│   └── TEMPLATE-1PAGE-SPEC.md                 # Mandatory 1-Page Feature Spec Template (SPEC-XXX)
├── docs/
│   ├── Plant-A-Virtual-CTO-Playbook.pdf       # Complete Executive & Developer Manual with 6 Vector Diagrams (PDF)
│   ├── Plant-A-Virtual-CTO-Playbook.md        # Complete Executive & Developer Manual with 6 Mermaid Diagrams (MD)
│   ├── SERVICE-A-AND-B-PLAYBOOK.md            # Step-by-step guide: Maintaining Service A vs. Starting Service B
│   ├── TESTING-STRATEGY-AND-STANDARDS.md      # Full-Fledged 5-Layer Testing Standard (Anti-AI-Mock-Trap)
│   ├── SOC2-ISO27001-COMPLIANCE.md            # Auditor-ready SOC 2 & ISO 27001:2022 control mapping
│   ├── CTO-ROLLOUT-PLAYBOOK.md                # 30-Day CTO rollout guide & executive communication scripts
│   ├── DEVELOPER-ONBOARDING.md                # Developer workflow & copy-paste AI prompts per stage
│   ├── FRIDAY-CHANGELOG-TEMPLATE.md           # Weekly async pulse template (replaces daily standups)
│   └── adr/
│       └── TEMPLATE-ADR.md                    # 20-Line Architecture Decision Record (for new dependencies/patterns)
├── contracts/
│   ├── openapi/
│   │   └── service-template.openapi.yaml      # Canonical OpenAPI 3.1 REST Contract Template
│   └── events/
│       └── event-template.schema.json         # Canonical Async Event JSON Schema Template
├── scripts/
│   ├── sync-microservice.ps1                  # Windows PowerShell script to "plant" the Virtual CTO in any repo
│   ├── sync-microservice.sh                   # POSIX Bash script to "plant" the Virtual CTO in any repo
│   └── generate-sdk.sh                        # Auto-generates Node, Python, Angular, & Mobile types from contracts/
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md               # PR template for developers contributing Golden Rules / Specs / Contracts
│   └── workflows/
│       ├── reusable-sdge-gates.yml            # Central GitHub Action (feature/* -> UAT -> MAIN, [CTO-OVERRIDE], 5-Layer QA)
│       └── auto-broadcast-standards.yml       # Auto-broadcasts Virtual CTO updates to all microservice repos on merge
└── microservice-template/
    ├── .pre-commit-config.yaml                # Local laptop 3s Gitleaks secret check + linter before git push
    └── .github/
        ├── CODEOWNERS                         # Locks package manifests, DB migrations, and contracts to @cto / @deputy
        ├── PULL_REQUEST_TEMPLATE.md           # Enforces Track selection, [CTO-OVERRIDE], & SOC2/AI sign-off
        └── workflows/
            └── ci-gates.yml                   # Self-contained CI workflow dropped into each microservice repo
```

---

## Quickstart: Planting the Virtual CTO in Any Microservice Repo

```powershell
# Windows PowerShell (set -Stack to "node", "python", "angular", or "mobile")
.\scripts\sync-microservice.ps1 -TargetRepoPath "..\service-a" -Stack "node"
```

```bash
# macOS / Linux / Git Bash
./scripts/sync-microservice.sh ../service-a node
```

