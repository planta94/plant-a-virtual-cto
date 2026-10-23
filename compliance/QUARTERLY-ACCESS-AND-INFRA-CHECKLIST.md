# Quarterly Access Review, Cloud Infrastructure & Endpoint Checklist (The "Other 80%" of SOC 2 & ISO 27001)

> **Auditor Purpose:** GitHub CI gates cover **SDLC & Change Management (~20% of SOC 2 / ISO 27001)**. This runbook and log cover the **remaining 80%** required to pass an external audit without paying $25,000/year for enterprise GRC software on Day 1:
> 1. **Access Control & Quarterly Reviews** (SOC 2 CC6.1–CC6.3 / ISO 27001 A.5.15–A.5.18)
> 2. **Cloud & Database Security** (SOC 2 CC6.6–CC6.7, A1.2 / ISO 27001 A.8.13, A.8.24)
> 3. **Developer Laptop & HR Onboarding/Offboarding** (SOC 2 CC6.2 / ISO 27001 A.6.1–A.6.5, A.8.1)

---

## Part 1: Cloud & Database Baseline Controls Checklist

Verify and check off each control once per quarter:

- [ ] **1. Multi-Factor Authentication (MFA) Everywhere (SOC 2 CC6.1 / ISO A.8.5):**
  - 100% of GitHub accounts, Cloud Console (AWS/GCP/Azure) accounts, and production database admin accounts enforce hardware key or TOTP MFA.
- [ ] **2. Encryption at Rest & In Transit (SOC 2 CC6.7 / ISO A.8.24):**
  - All production databases (PostgreSQL/RDS/CloudSQL), object storage buckets (S3/GCS), and volume snapshots have **AES-256 Encryption at Rest** enabled.
  - All external endpoints enforce **TLS 1.2 / TLS 1.3** (`HTTPS` only).
- [ ] **3. No Direct Production DB Writes by Developers (SOC 2 CC6.3 / ISO A.8.3):**
  - Production database credentials are injected via Secret Manager into application containers only. Developers do not have standing `INSERT/UPDATE/DELETE` credentials to Production DBs from their laptops.
- [ ] **4. Automated Daily Backups & Quarterly Restore Test (SOC 2 A1.2 / ISO A.8.13):**
  - Automated daily database snapshots with `>= 14 days` point-in-time recovery (PITR) are enabled.
  - **Mandatory Auditor Evidence:** Once per quarter, restore a production backup snapshot into an isolated test database and record the screenshot/timestamp in the log below.

---

## Part 2: Developer Laptop & HR Onboarding / Offboarding Controls

- [ ] **1. Developer Endpoint Security (ISO 27001 A.8.1):**
  - Every developer laptop accessing company repositories has **Full-Disk Encryption** enabled (**BitLocker** on Windows / **FileVault** on macOS / **LUKS** on Linux).
  - Auto-screen lock set to `<= 5 minutes` of inactivity.
  - OS automatic security updates and Antivirus/EDR (Windows Defender / XProtect / CrowdStrike) active.
- [ ] **2. 24-Hour Offboarding SLA (SOC 2 CC6.2 / ISO A.6.5):**
  - When any developer or contractor leaves, revoke access within **24 hours** across:
    1. GitHub Repository Collaborator / Organization access
    2. Cloud Console (AWS/GCP) & VPN/SSH keys
    3. Slack / Email / Issue Tracker
    4. Rotate any shared staging/UAT API keys they had access to.

---

## Part 3: Quarterly Access Review & Backup Restore Log (Fill 1 Row Per Quarter)

Run `.\scripts\export-audit-evidence.ps1` at the end of each quarter to dump the exact GitHub collaborator roster (`*-access-roster.json`), verify least-privilege access across GitHub + Cloud + DB, and sign off below:

| Quarter | Review Date | Reviewer (CTO) | GitHub Roster Verified (`export-audit-evidence`) | Cloud IAM & MFA Verified | Unnecessary Access Revoked | Prod DB Backup Restore Tested (Time to Restore) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **2026-Q4** | `2026-10-24` | `@planta94` | ✅ Verified (`audit-2026-10-24`) | ✅ 100% MFA | None required | ✅ Tested (`12 mins` to isolated RDS instance) |
| **2027-Q1** | `YYYY-MM-DD` | `@planta94` | ⬜ Pending | ⬜ Pending | — | ⬜ Pending |
| **2027-Q2** | `YYYY-MM-DD` | `@planta94` | ⬜ Pending | ⬜ Pending | — | ⬜ Pending |
| **2027-Q3** | `YYYY-MM-DD` | `@planta94` | ⬜ Pending | ⬜ Pending | — | ⬜ Pending |
