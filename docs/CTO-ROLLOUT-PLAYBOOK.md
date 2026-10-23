# CTO Rollout Playbook: Spec-Driven, Gate-Enforced Engineering (SDGE)

This playbook gives you the exact sequence, scripts, and governance levers to standardize development across your 5+ microservice repositories without using Agile ceremonies—while handling an "on-the-fly" CEO/Founder smoothly.

---

## Part 1: Managing Up — How to Handle Your Boss's "On-the-Fly" Ideas

When a founder or CEO thinks on the fly, traditional Agile fails because telling them *"Wait 2 weeks for the next sprint planning"* creates frustration, while letting developers immediately prompt AI to hack on production repos creates chaos and broken services.

### Your New Rule: "Yes, in 30 Minutes We'll Have a Spec & Swap Card"

Whenever your boss drops a sudden idea in Slack or a hallway conversation:

1. **Never let the request go straight to a developer's IDE.**
2. **Run the 10-Minute AI Triage Skill (`ai-context/triage-boss-idea.skill.md`):**
   - Feed your boss's raw idea into your AI tool with `specs/TEMPLATE-BOSS-TRIAGE.md` and `specs/WIP-QUEUE.md`.
   - Within 15–30 minutes, hand the boss a 1-page **`TRIAGE-XXX` Executive Swap Card**.
3. **Use This Exact Script With Your Boss:**
   > *"I mapped out how to ship [Idea X] cleanly across our services. Here is the 1-page breakdown: it touches `service-a` and `web-angular`, and will take **3 days**. Right now `@dev-2` is 1 day away from finishing [Feature Y]. To make sure we don't break production or leave half-finished branches, do you want `@dev-2` to start [Idea X] tomorrow right after finishing [Feature Y] (Option A), or pause [Feature Y] right now and swap (Option B)?"*

**Why this works every time:**
- Your boss feels **heard and fast-tracked** (they get a concrete architectural plan and ship date in 30 minutes).
- You eliminate hidden multitasking ("shadow work") because the boss explicitly chooses what gets paused or queued.
- If the boss isn't sure whether the idea is worth pausing existing work, offer **Option C (1-Day Isolated Sandbox PoC)** where a developer prototypes a throwaway mock outside production repos.

---

## Part 2: Managing Down — Pitching This to Developers (Zero Pushback)

Developers hate process when it means more meetings (Scrum, standups, story-point poker). They **love** process when it means:
- Zero daily status meetings
- Freedom to use any AI tool they want (Copilot, Codex, Antigravity, Cursor)
- Only working on **1 clear task at a time** (protected from random interrupts)
- Clear contracts so another developer's microservice doesn't break their frontend/mobile build

### What to Say at the All-Hands Engineering Kickoff (15 Mins):
> *"Starting this week, we are permanently banning Agile ceremonies—no sprints, no story points, no daily standups. You can continue using whichever AI coding tool makes you fastest (Copilot, Codex, Antigravity, Cursor). In exchange for total autonomy on how you code, we are standardizing **inputs** and **outputs** across all microservice repos:*
> *1. **Every repo now has `AGENTS.md`** so all our AI tools follow the exact same Golden Stack and stop inventing conflicting patterns.*
> *2. **Two-Track Rule:** Bugfixes under 100 lines go straight to PR. Anything bigger or touching APIs/DBs starts with a 1-page Markdown Spec (`SPEC-XXX`) and an OpenAPI/Event Contract PR first.*
> *3. **Max 400 lines per PR:** Use AI to write code fast, but ship in small stacked PRs so code review takes 10 minutes instead of 2 days.*
> *4. **Protection from Interrupts:** You will only ever have 1 active Spec at a time in `WIP-QUEUE.md`. If leadership has an urgent new idea, I will triage it first and we will cleanly swap, never stack."*

---

## Part 3: 4-Week Rollout Checklist

### Week 1: Establish the Central Hub & Stop Dependency Sprawl
- [ ] Create the `Plant-A-Virtual-CTO` repository on GitHub and push the files in this directory.
- [ ] Replace `@cto-handle` in `microservice-template/.github/CODEOWNERS` and `YOUR-GITHUB-ORG` in `microservice-template/.github/workflows/ci-gates.yml` with your real GitHub handle and org name.
- [ ] Run `.\scripts\sync-microservice.ps1` across your 5+ microservice, Angular, and Mobile repositories.
- [ ] Enable **Branch Protection** on `main` across all repos:
  - Require pull request reviews before merging
  - Require review from **Code Owners** (enforces `CODEOWNERS` on `package.json`, `pyproject.toml`, migrations, and contracts)
  - Require status checks to pass (`Gate 1`, `Gate 2`, `Gate 3`)

### Week 2: Enforce Stage 1 (1-Page Spec) & Stage 2 (Contract Lock)
- [ ] Populate `specs/WIP-QUEUE.md` with what each developer is currently building (cap at 1 active item per developer; move everything else to the Ready Queue).
- [ ] Enforce the **Contract-First rule** on the very next cross-service feature: merge the OpenAPI 3.1 YAML (`contracts/openapi/`) and run `./scripts/generate-sdk.sh` before backend or Angular/Mobile implementation starts.

### Week 3: Turn On the 400-LOC & Spec-ID Hard Gates
- [ ] Verify that `Gate 1: Spec-Track, PR Size & Dependency Lock` is blocking PRs over 400 lines or PRs missing a `SPEC-XXX` tag.
- [ ] Use your first executive "on-the-fly" request to demonstrate the `TRIAGE-XXX` Swap Card with your boss.

### Week 4: Replace Status Meetings with the Friday Async Changelog
- [ ] Have every developer post their 5-bullet update every Friday using `docs/FRIDAY-CHANGELOG-TEMPLATE.md`.
- [ ] Measure **Spec Cycle Time** (Days from `Spec Approved` → `Merged to Main`). A healthy AI-assisted microservice team should average **2 to 4 days per Spec**.

