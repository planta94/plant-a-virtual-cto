# Team Training & A–Z Developer Guide: Working With Our "Virtual CTO" (Junior-Friendly Edition)

> **Trainer Note for CTO (`@planta94`):**
> - **Sections 1–3** give you the plain-English **45-Minute Training Script & 6 Everyday Scenarios** to present to your team next week.
> - **Section 4 (The A–Z Step-by-Step Developer Checklist)** is the complete, command-by-command daily manual your junior and mid-level developers can keep open on their second monitor from **Step A (Laptop Setup)** all the way to **Step X (Production Release)**.

---

## Part 1: The 3-Minute Kickoff Speech (What to Say to Your Team)

*"Starting next week, we are officially dropping Agile bureaucracy—no daily standups, no sprint planning marathons, and no guessing story points.*

*You also get total freedom to use whichever AI coding tool you like best—GitHub Copilot, Cursor, Claude Code, OpenAI Codex, or Antigravity.*

*There is only one catch when 5 developers use 5 different AI tools: **if we don't give our AI tools the same rulebook, they invent 5 different ways to write code, break each other's APIs, and create giant 2,000-line Pull Requests that nobody wants to review.***

*So we planted a **Virtual CTO (`AGENTS.md`)** inside every repository. Your AI tool reads this file automatically before it writes code for you. You only need to know **4 simple habits**, **6 everyday scenarios**, and follow our **A–Z Checklist**."*

---

## Part 2: The 4 Simple Habits Every Developer Needs to Know

Think of our workflow like driving with GPS:

1. **One Main Task at a Time ("Swap, Don't Stack"):**
   - You never juggle 3 big features at once. You have **1 Active Feature (`SPEC`)** at a time.
2. **Agree on the Plug Before Building the Wall Socket (API Contracts First):**
   - If Backend and Frontend/Mobile need to talk to each other, we write down the exact JSON request/response in `plant-a-virtual-cto/contracts/` *first* so nobody has to guess field names.
3. **Bite-Sized Pull Requests (`< 400 lines` into `UAT`):**
   - AI can generate 1,500 lines in 2 minutes, but humans can't review 1,500 lines safely. Keep every Pull Request under **400 lines of code** and always merge into **`UAT`** first (`feature/* → UAT → MAIN`).
4. **No "Fake" AI Tests:**
   - Sometimes AI gets lazy and writes a fake test that doesn't actually check the database or security. Every new endpoint needs a real test showing:
     - It works when given good data (`200 OK`)
     - It blocks bad data (`400 Bad Request`)
     - **User A cannot sneak a peek at User B's data (`403 Forbidden`)**.

---

## Part 3: The 6 Everyday Scenarios (How to React in Real Life)

### 🟢 Scenario 1: "I'm just fixing a small bug or tiny UI tweak (`< 100 lines`)"
* **Do I need a 1-Page Spec?** **No!** If it's under 100 lines and doesn't touch packages, database tables, or API contracts, use **`[FAST-TRACK]`** (see **Step F** below).

### 🔵 Scenario 2: "I'm building a new feature (`>= 100 lines` or adding a new API/DB table)"
* **How do Backend and Frontend/Mobile stay in sync?**
  1. Submit a **1-Page Spec Issue (`SPEC-018`)** in `plant-a-virtual-cto` → our bot automatically creates `specs/SPEC-018.md` and pushes it to every service repo.
  2. Update the OpenAPI contract in `contracts/openapi/` → our bot (or `generate-sdk`) generates the exact same TypeScript/Python/Dart types in `src/generated/contracts/` for everyone!

### 🟡 Scenario 3: "I opened an old file in `Service A` and the existing code looks messy!"
* **The 3 Rules for Old Code:**
  1. **Don't reformat old functions you aren't working on** (keep diffs surgical).
  2. **Don't copy bad habits** (like `any` or raw SQL) from neighboring old code—write your new function the clean way. *(Our CI only grades the lines you touched, so old files won't fail your build!)*
  3. **Before changing an old API route that has no OpenAPI spec**, run the 2-minute contract extractor prompt (**Step H**).

### 🟠 Scenario 4: "The Boss just messaged me on Slack with an urgent new idea while I'm busy!"
* **How our system protects you ("Swap, Don't Stack"):**
  - Never secretly juggle two features at once. Run the **Boss Triage Prompt (Step T)** to generate a 2-minute Trade-Off Card (`Option A: Swap Now & Pause Current Spec` vs. `Option B: Queue Next`). If you Swap Now, our bot automatically marks your old Spec as `PAUSED` so nobody blames you on Friday!

### 🟣 Scenario 5: "Where do I put notes specific to my own service (`AGENTS.local.md`) vs. Company Rules (`AGENTS.md`)?"
* **Company Law (`AGENTS.md` Top Section):** Locked at Line 1 by `@planta94`. Never edit `AGENTS.md` directly inside your service repo.
* **House Notes (`AGENTS.local.md`):** Freely editable by you! Put your service's port numbers, DB seed commands, and domain notes in `AGENTS.local.md`. Our sync script automatically attaches `AGENTS.local.md` to the bottom of `AGENTS.md` (as Part III) while reminding the AI that Company Law (Part I & II) always wins if there's a conflict.

### 🟤 Scenario 6: "I need to `npm install` a new library (or teach the Virtual CTO a new rule)"
* **New Library:** AI often hallucinates fake packages, so any change to `package.json` / `requirements.txt` / `pubspec.yaml` requires a quick 20-line note in `docs/adr/` and `@planta94` approval (**Step L**).
* **New Golden Rule:** If your AI makes a dumb mistake and you want to fix it for the whole team, run `propose-golden-rule.skill.md` (**Step V**).

---

# Part 4: The Complete A–Z Developer Step-by-Step Walkthrough

Keep this checklist open while you work. Follow **Steps A–E** once during setup, and **Steps F–X** for your daily coding!

---

### 🛠️ PHASE 1: One-Time Laptop & Repository Setup (Steps A–E)

#### Step A — Clone `plant-a-virtual-cto` and Your Service Repo Side-by-Side
Open your terminal and clone the central hub next to your microservice repositories:
```bash
cd ~/Desktop/Github
git clone git@github.com:planta94/plant-a-virtual-cto.git
git clone git@github.com:planta94/service-a.git
```

#### Step B — Plant the Virtual CTO into Your Service Repo (If Not Synced Yet)
From inside `plant-a-virtual-cto`, run the sync script for your service's tech stack (`node`, `python`, `angular`, or `mobile`):
```powershell
# Windows PowerShell:
cd C:\Users\chine\OneDrive\Desktop\Github\plant-a-virtual-cto
.\scripts\sync-microservice.ps1 -TargetRepoPath "..\service-a" -Stack "node"
```
```bash
# macOS / Linux / Git Bash:
cd ~/Desktop/Github/plant-a-virtual-cto
./scripts/sync-microservice.sh ../service-a node
```
*What this just did:* It planted `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `.cursor/rules/00-virtual-cto.mdc`, `.gemini/rules/00-Plant-A-Virtual-CTO.md`, `.github/copilot-instructions.md`, `specs/`, `contracts/`, `src/generated/contracts/`, `CONTRACT.lock`, and `.github/workflows/ci-gates.yml` inside `service-a` (and if `service-a` already had an old `AGENTS.md`, it safely moved it into `AGENTS.local.md`!).

#### Step C — Turn On the 3-Second Laptop Safety Hook (`pre-commit`)
Inside your microservice repository (`service-a`), install the local pre-commit hook once:
```bash
cd ../service-a
pip install pre-commit   # (or: brew install pre-commit)
pre-commit install
```
*Why:* Now, every time you run `git commit`, your laptop takes 3 seconds to verify you didn't accidentally commit a secret API key or broken YAML/JSON before it ever leaves your computer.

#### Step D — Flip the "Privacy / Zero-Training" Switch in Your AI Tool (1 Minute)
To comply with our security standards ([`compliance/AI-AND-VENDOR-RISK-REGISTER.md`](../compliance/AI-AND-VENDOR-RISK-REGISTER.md)), check this setting once in your AI tool:
- **Cursor:** `Cursor Settings → General → Privacy Mode = "Enabled (Zero Data Retention)"`
- **GitHub Copilot:** `GitHub Settings → Copilot → Uncheck "Allow GitHub to use my code snippets for product improvements"`
- **ChatGPT / Codex:** `Settings → Data Controls → Turn OFF "Improve the model for everyone"`
- **Golden Rule:** Never paste `.env` secrets or real customer personal data (names, emails, phone numbers, credit cards) into any AI chat!

#### Step E — Add Your Service's Local Notes into `AGENTS.local.md`
Open `AGENTS.local.md` inside your service repo (`service-a/AGENTS.local.md`) and write down helpful local facts for your AI:
- What port this service runs on (e.g., `PORT=3002`)
- How to run tests locally (e.g., `npm run test:unit` and `npm run test:int`)
- Any special domain words for this service.
*(Remember: Never edit the top of `AGENTS.md` directly—always edit `AGENTS.local.md`, then re-run `sync-microservice` if you want it merged into the bottom of `AGENTS.md`.)*

---

### 📋 PHASE 2: Starting a Task — Spec & Contract First (Steps F–I)

#### Step F — Decide Your Track in 10 Seconds (`Fast Track` vs. `Spec Track`)
Before writing code, ask yourself:
1. **Is my change `< 100 lines of code` AND does NOT touch `package.json`/`requirements.txt`, Database tables, API Contracts, or Login/Auth?**
   - **YES → Use `[FAST-TRACK]`!** Skip Steps G, H, and I, and jump straight to **Step J**!
2. **Is my change `>= 100 lines`, a new feature, or touching DB / API Contracts / Packages / Auth?**
   - **YES → Use `SPEC-TRACK` (`SPEC-XXX`)!** Follow **Steps G, H, and I** below (takes ~10 minutes with AI).

#### Step G — Create Your 1-Page Feature Spec (`SPEC-XXX`)
1. Open your AI tool and paste this prompt to draft your Spec in 60 seconds:
   > *"I need to build [describe feature in 2 sentences]. Draft the 4 sections needed for our `1-Page Feature Spec` (`Problem & Goal`, `Explicit Non-Goals`, `API/DB Impact`, and the `4-Part Acceptance & Security Test Matrix`) following `AGENTS.md`."*
2. Open GitHub in your browser → go to **`planta94/plant-a-virtual-cto` → Issues → New Issue → "📋 1-Page Feature Spec (SPEC-XXX)"**.
3. Paste the 4 boxes, assign the Issue to yourself, and click **Submit new issue** (e.g., `[SPEC-018] Export Monthly Invoices`).
4. **What happens automatically:**
   - Within 15 seconds, our GitHub Bot creates `specs/SPEC-018.md`, puts your name in `specs/WIP-QUEUE.md` as `ACTIVE-DEV` (auto-pausing any older Spec you had open), and broadcasts `specs/SPEC-018.md` to all microservice repos!

#### Step H — Lock the API or Event Contract First (If Backend & Frontend/Mobile Talk)
If your feature changes or adds an API endpoint or event:
- **Case 1 — You are modifying an old endpoint in `Service A` that doesn't have an OpenAPI contract yet:**
  Open the old controller in your AI tool and paste:
  > *"Follow `ai-context/reverse-engineer-contract.skill.md` for this endpoint and output the OpenAPI 3.1 YAML for `contracts/openapi/`."*
- **Case 2 — You are adding a new endpoint or field:**
  Update `contracts/openapi/<service>.openapi.yaml` (or `contracts/events/<event>.schema.json`) inside `plant-a-virtual-cto` and open a quick PR to `main`.
  *(Note: Our `oasdiff` check will automatically verify you didn't delete or rename existing fields that would break the live Mobile or Angular app!)*

#### Step I — Generate the Shared SDK Types (`src/generated/contracts/` + `CONTRACT.lock`)
Once the contract is updated in `plant-a-virtual-cto`, every developer working on Backend, Angular, or Mobile pulls the generated types into their service repo with **1 command**:
```powershell
# Windows PowerShell (run from inside your microservice repo, e.g., service-a):
..\plant-a-virtual-cto\scripts\generate-sdk.ps1 -TargetRepo "." -Stack "node"

# Or pull directly from GitHub even if you don't have plant-a-virtual-cto cloned locally:
.\scripts\generate-sdk.ps1 -TargetRepo "." -Stack "node" -RemoteHubUrl "https://github.com/planta94/plant-a-virtual-cto.git"
```
```bash
# macOS / Linux / Git Bash:
../plant-a-virtual-cto/scripts/generate-sdk.sh . node
```
*Rule:* **Never hand-edit files inside `src/generated/contracts/`!** Our CI checks `CONTRACT.lock` to make sure nobody tampered with the generated types.

---

### 💻 PHASE 3: Writing Code & Real Tests With AI (Steps J–N)

#### Step J — Branch Off `UAT` (Never Branch Off `main` for Features!)
In your microservice repository (`service-a`), always start from the latest **`UAT`** branch:
```bash
git checkout UAT
git pull origin UAT
git checkout -b feature/SPEC-018-invoice-export
```
*(If it's a small Fast-Track fix: `git checkout -b fix/42-button-padding`)*

#### Step K — Give Your AI the Implementation Prompt
Paste this prompt into Copilot, Cursor, Claude Code, Codex, or Antigravity:
> *"Read `AGENTS.md` and `specs/SPEC-018.md`. Implement the code for `SPEC-018` using the generated types in `src/generated/contracts/`. Keep the total diff under 400 lines of code (if it's larger, let's do Part 1 first), do not reformat untouched legacy functions, and do not use `any` or raw SQL in controllers."*

#### Step L — What If You Need a New Package (`npm install` / `pip install`)?
If your AI says *"We need to install package X"*:
1. **Do NOT just run `npm install` and push** (CI Gate 1 will block any `package.json` / `pyproject.toml` / `pubspec.yaml` change that doesn't have an `ADR-XXX` ID!).
2. Ask your AI:
   > *"Draft a 20-line Architecture Decision Record using `docs/adr/TEMPLATE-ADR.md` (e.g., `ADR-004`) explaining why we need this package, its license, and confirming it has 0 high/critical CVEs."*
3. Put `[ADR-004]` in your PR description so `@planta94` can approve the new dependency.

#### Step M — Generate the 5-Layer Real Tests (No Fake Mocks!)
Before you finish coding, tell your AI to write the tests:
> *"Following Section 3 of `AGENTS.md`, write the unit and real-database integration tests for the code we just wrote. Do NOT mock Prisma/Drizzle/SQLAlchemy in integration tests. For the API endpoint test, make sure we explicitly test all 4 cases:*
> *1. `200/201` Happy Path (validates against our OpenAPI contract)*
> *2. `400/422` Bad Input (returns RFC 7807 error)*
> *3. `401` Unauthenticated request*
> *4. `403/404` Cross-Tenant IDOR test proving User A from Tenant A cannot access User B's data from Tenant B."*

#### Step N — Run Your Linter, Tests & `git diff --stat` Locally
Run a quick check on your laptop before pushing:
```bash
# Check how many lines you changed (must be < 400 lines for a feature PR, or < 100 for [FAST-TRACK]):
git diff --stat origin/UAT

# Run your local linter & tests:
npm test          # (or: pytest)
```

---

### 🚀 PHASE 4: Opening Your PR & Passing the 4 CI Gates (Steps O–S)

#### Step O — Commit & Push Your Branch
```bash
git add .
git commit -m "feat(invoices): add monthly invoice export endpoint [SPEC-018]"
git push -u origin feature/SPEC-018-invoice-export
```
*(If your commit is a small bugfix: `git commit -m "fix(ui): align login button padding [FAST-TRACK] #42"`)*

#### Step P — Open a Pull Request into **`UAT`** on GitHub
1. Go to your service repo on GitHub and click **Compare & pull request**.
2. **CRITICAL:** Set the base branch to **`UAT`** (`base: UAT <- compare: feature/SPEC-018-invoice-export`).
3. **Title Format:**
   - For Spec Track: `[SPEC-018] Add monthly invoice export endpoint`
   - For Fast Track: `[FAST-TRACK] Fix login button padding #42`
4. **Tick the Mandatory Checkboxes in the PR Template:**
   - Tick which Track applies.
   - Tick **`[x] I have read, understood, and verified every line of AI-generated code`**
   - Tick **`[x] No production secrets, customer PII, or proprietary credentials were shared with external AI tools or committed`**
   *(If you forget to tick `[x]` on these two boxes, CI Gate 1 will fail in 5 seconds!)*

#### Step Q — How to Fix Any Red ❌ CI Gate in 2 Minutes
When you open your PR, GitHub Actions runs **Gates 1, 2, and 3**. If a gate turns red ❌, look at this table for the instant fix:

| Red ❌ Error Message in GitHub Actions | What It Means | 1-Minute Fix |
| :--- | :--- | :--- |
| `PR exceeds the 400 LOC limit` | Your PR changed more than 400 lines of code. | Split the PR into Part 1 & Part 2, OR ask `@planta94` for `[CTO-OVERRIDE: reason]` if it's a mechanical migration. |
| `Spec-Track PRs MUST reference SPEC-XXX` | Your PR is `>= 100 lines` (or touched DB/Contracts/Deps) without a `SPEC-XXX` ID. | Add `SPEC-018` to your PR title/body (see **Step G**). |
| `Production code modified without test files` | You edited `src/` without adding or updating a test file (`*.spec.*`, `*.test.*`, `test_*.py`). | Follow **Step M** to add unit/integration tests for your change. |
| `Mandatory sign-off unchecked` | You forgot to put `[x]` in the two checkboxes at the bottom of the PR description. | Edit your PR description on GitHub and change `[ ]` to `[x]`. |
| `CONTRACT.lock integrity check failed` | Someone manually edited a file inside `src/generated/contracts/`. | Re-run `generate-sdk.ps1` / `.sh` (**Step I**) and commit `CONTRACT.lock`. |
| `AGENTS.md Constitutional Priority violated` | Someone put text above `<!-- BEGIN VIRTUAL-CTO-CONSTITUTION -->` in `AGENTS.md`. | Move your local service notes into `AGENTS.local.md` (**Step E**). |
| `Mocked ORM detected in integration test` | Your AI used `jest.mock('@prisma/client')` or `MagicMock(AsyncSession)` in an integration test. | Tell your AI: *"Remove the ORM mock and run this integration test against the test Postgres DB."* |
| `Diff coverage below 85%` | Less than 85% of the new lines you wrote are covered by tests. | Ask your AI to add test cases covering the untested `if/else` or error branches in your changed files. |

#### Step R — What If You Legitimately Need to Break a Soft Rule? (`[CTO-OVERRIDE]`)
If you are doing something where the 400-line limit or pre-Spec rule genuinely doesn't make sense (for example, renaming a folder across 30 files), ask `@planta94`. If approved, add **`[CTO-OVERRIDE: mechanical folder rename approved by CTO]`** to your PR body—CI Gate 1 will automatically log the exception and let your PR pass!

#### Step S — Merge into `UAT` & Automatic Status Update
Once Gates 1, 2, and 3 are Green ✅ and 1 teammate approves your PR:
1. Click **Squash and merge** into `UAT`.
2. **What happens automatically:**
   - Gate 4 (`post-deploy-canary-gate`) pings `/health` on UAT to make sure your code booted cleanly.
   - Our WIP Bot automatically updates your `SPEC-018` Issue status to **`IN-UAT`**!

---

### 🔄 PHASE 5: Handling Curveballs & Releasing to Production (Steps T–X)

#### Step T — Curveball: The Boss Drops a Sudden Request on You Mid-Week!
If the Founder/Boss messages you on Slack/WhatsApp asking for something new while you are working on `SPEC-018`:
1. **Do NOT start coding it on the side.**
2. Paste this prompt into your AI tool:
   > *"Follow `ai-context/triage-boss-idea.skill.md` for this request: [paste Boss's message]. My current active spec is `SPEC-018`."*
3. Open GitHub → `plant-a-virtual-cto` → **Issues → New Issue → "⚡ Boss Ad-Hoc Idea Triage (Swap, Don't Stack)"** and paste the AI's 30-second output.
4. Ask the CTO/Boss to pick **Option A (Swap Now — Pause `SPEC-018`)** or **Option B (Queue Next — Finish `SPEC-018` first)**.
5. If they pick **Swap Now**, commit your current work on `feature/SPEC-018` (`git commit -m "wip: paused for SPEC-019"`), and when you open `SPEC-019`, the bot **automatically marks `SPEC-018` as `PAUSED`**!

#### Step U — Curveball: Production Is Down! (`[HOTFIX-TRACK]`)
If there is a live production emergency (`SEV-1` outage):
1. Branch off `main` (`git checkout -b hotfix/fix-payment-crash`).
2. Keep the fix surgical (`< 200 lines`).
3. Open a PR with **`[HOTFIX-TRACK]`** in the title. (CI still checks for secrets, security flaws, and passing tests, and skips the pre-Spec requirement so you can restore production immediately).
4. **Within 24 hours after the fire is out:** Create a retroactive `SPEC-HOTFIX-XXX` Issue explaining what caused the crash and adding a permanent test so it never happens again.

#### Step V — Teach the Virtual CTO a New Rule ("Compound AI Memory")
Whenever your AI tool makes a silly mistake during the week (or you and a teammate discover a great code pattern during PR review):
1. Tell your AI:
   > *"Follow `ai-context/propose-golden-rule.skill.md`. Today my AI made mistake [X]. Draft a 2-line rule for `AGENTS.md`."*
2. Open a 2-line PR to `planta94/plant-a-virtual-cto`. Once `@planta94` merges it, every developer's AI tool across all repos learns your lesson automatically!

#### Step W — Promoting `UAT → MAIN` (Shipping to Production!)
When features in `UAT` have been tested and are ready for real customers:
1. Open a Pull Request on GitHub with **`base: main <- compare: UAT`** titled `Release: Promote UAT to MAIN (YYYY-MM-DD)`.
2. **Automatic Release Mode:** CI Gate 1 automatically recognizes that `UAT → MAIN` is a Release PR—so even if 5 features (`1,200 lines total`) are bundled inside `UAT`, **CI automatically bypasses the 400-line cap**, runs the full security and test suite, checks the live production `/health` endpoint after merge, and **automatically closes all shipped `SPEC-XXX` Issues as `SHIPPED (MAIN)`!**

#### Step X — Friday 5-Minute Async Changelog (Instead of Daily Standups!)
We don't waste 15 minutes every morning in a "What did you do yesterday?" standup meeting. Instead, before logging off on Friday afternoon, drop 3 quick bullets in the team channel (using [`docs/FRIDAY-CHANGELOG-TEMPLATE.md`](FRIDAY-CHANGELOG-TEMPLATE.md)):
- ✅ **Shipped to `MAIN` this week:** `SPEC-018` (Invoice Export)
- 🚀 **Currently in `UAT`:** `SPEC-019` (WhatsApp Webhook)
- ⏸️ **Paused / Swapped or Blocked:** `SPEC-015` (Paused on Wednesday due to Boss Swap for `SPEC-019`)

---

## Part 5: 15-Minute Live Hands-On Exercise (End of Training Session)

Before wrapping up the training session, have every developer do this 10-minute check on their laptop:

1. **Open a synced service repo** in their favorite editor (VS Code with Copilot, Cursor, Claude Code, or Antigravity).
2. **Type this exact question into their AI chat:**
   > *"Read `AGENTS.md`. What are the 4 steps you must execute before writing code for me, where do I put local notes for this service, and which rules win if there is a conflict?"*
3. **Verify the AI's answer together:**
   - The AI recites the **4-Step Pre-Coding Protocol** (`[FAST-TRACK]` vs `SPEC-XXX`, Contract/Dependency Lock, `< 400 LOC`, and 5-Layer Real Tests).
   - The AI confirms that local service notes go in **`AGENTS.local.md`** (Part III), while **Part I & II (The Virtual CTO Constitution)** always hold supreme priority!
