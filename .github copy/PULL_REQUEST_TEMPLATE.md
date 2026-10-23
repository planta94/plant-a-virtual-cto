## Contribution Type (Central `Plant-A-Virtual-CTO` Hub PR)
Select what you are contributing to our shared engineering hub:

- [ ] **Golden Rule / Banned Pattern Update (`AGENTS.md`):** Teaching our AI tools a new rule or banning a bad pattern spotted during coding/review.
- [ ] **New AI Skill / Prompt (`ai-context/*.skill.md`):** Sharing a reusable AI workflow with the team.
- [ ] **Golden Code Example (`golden-examples/`):** Adding a canonical reference file for Node, Python, Angular, or Mobile.
- [ ] **Architecture Decision Record (`docs/adr/ADR-XXX.md`):** Proposing a new approved dependency or architectural pattern.
- [ ] **Feature Spec (`specs/SPEC-XXX.md`) or Executive Triage (`specs/TRIAGE-XXX.md`)**
- [ ] **API / Event Contract Lock (`contracts/openapi/` or `contracts/events/`)**

---

## Why Is This Needed? (1–3 Sentences)
*Example: "Copilot kept generating Angular components without `ChangeDetectionStrategy.OnPush`, or we need `bullmq` (`ADR-004`) for background retries in `order-service`."*

- **Problem / Mistake Observed:** 
- **How This PR Fixes It Across the Team:** 

---

## Checklist
- [ ] If updating `AGENTS.md`, the rule is concise (1–2 lines) and placed under the correct stack section.
- [ ] If proposing a new dependency (`ADR-XXX`), I verified it has a permissive license (MIT/Apache-2.0/BSD) and zero high/critical CVEs.
- [ ] Upon merge, `.github/workflows/auto-broadcast-standards.yml` will automatically sync this update to all microservice, Angular, and Mobile repos.

