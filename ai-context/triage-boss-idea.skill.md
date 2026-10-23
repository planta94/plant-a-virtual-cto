---
name: triage-boss-idea
description: Rapidly convert an "on-the-fly" founder/CEO idea or urgent feature request into a 1-Page Executive Triage & Swap Card plus a draft Technical Spec in under 10 minutes.
---

# Skill: 30-Minute Executive Idea Triage ("Swap, Don't Stack")

Use this skill whenever the CEO, Founder, or Product Stakeholder brings an unplanned, "on-the-fly" idea, pivot, or urgent request.

## Goal
Protect engineering predictability without saying "wait for the next sprint." Turn a rough 2-sentence idea into an objective **1-Page Executive Triage & Swap Card** (`specs/TRIAGE-XXX.md`) so the boss can make an informed **1-for-1 priority swap**.

---

## Step-by-Step Instructions for the AI Agent

### Step 1: Extract the Core Intent (2 Minutes)
From the user's raw note or Slack message, identify:
1. **The Business Outcome:** What user/business behavior is the boss trying to test or unlock?
2. **Prototype vs. Production Check:** Does the boss need a **Production Microservice Feature** (reliable, scalable, contract-locked) or a **Throwaway PoC / Demo** (isolated sandbox to validate an idea)?

### Step 2: Analyze Microservice & Contract Blast Radius (3 Minutes)
Map which parts of our stack are impacted:
- **Angular Web Frontend:** New screens, state changes, or UI flows?
- **Mobile App:** Requires app store release or API version support?
- **Node.js / Python Microservices:** Which specific services need logic changes?
- **Contracts & Data:** New OpenAPI 3.1 endpoints, async events, or DB migrations?
- **Third-Party Dependencies:** Any external APIs or new packages needed?

### Step 3: Estimate T-Shirt Effort & Bounded PR Count (2 Minutes)
Break the implementation into `< 400 LOC` PR slices and estimate elapsed calendar days for 1 developer:
- **Small (1–2 Days):** 1–2 PRs, single service/frontend, minor contract addition.
- **Medium (3–5 Days):** 3–5 PRs across 2+ repos, new contract + DB migration.
- **Large (1–2+ Weeks):** Cross-cutting architectural change; recommend splitting into a Phase 1 MVP (`<= 3 days`) and Phase 2.

### Step 4: Check `specs/WIP-QUEUE.md` for the "Swap, Don't Stack" Decision (3 Minutes)
Read `specs/WIP-QUEUE.md` and identify which currently active `SPEC-XXX` has the right developer skillset and lowest switching cost to pause if the boss wants to start immediately.

### Step 5: Output the Populated Triage Card
Generate a complete markdown document following `specs/TEMPLATE-BOSS-TRIAGE.md` ready for the CTO to share with the boss.
