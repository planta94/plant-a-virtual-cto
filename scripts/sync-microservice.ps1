<#
.SYNOPSIS
  Plant-A-Virtual-CTO: Complete Microservice Synchronization Script (Windows PowerShell)
  Enforces Constitutional Priority ("Tier 1 Virtual CTO Constitution" > "Tier 2 AGENTS.local.md"):
    1. If the target repo already has a developer-written AGENTS.md, automatically preserves and
       migrates it to AGENTS.local.md (zero lost service context!).
    2. Builds root AGENTS.md, CLAUDE.md, and .cursorrules with Tier-1 Virtual CTO Constitution at
       Line 1 (Supreme Priority) and appends AGENTS.local.md at the bottom as Part III (Subordinate).
    3. Writes 00-prefixed alwaysApply rules (.cursor/rules/00-virtual-cto.mdc & .gemini/rules/00-Plant-A-Virtual-CTO.md)
       so Cursor and Antigravity always load the CTO rules FIRST ahead of any local rule files.
    4. Syncs ai-context/, specs/, contracts/, golden-examples/, CODEOWNERS, PR Templates,
       .pre-commit-config.yaml, ci-gates.yml, and auto-generates SDK types (CONTRACT.lock).

.EXAMPLE
  .\scripts\sync-microservice.ps1 -TargetRepoPath "..\service-a" -Stack "node"
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$TargetRepoPath,

    [Parameter(Mandatory=$false)]
    [ValidateSet("node", "python", "angular", "mobile", "contracts")]
    [string]$Stack = "node"
)

$ErrorActionPreference = "Stop"
$HubRoot = Split-Path -Parent $PSScriptRoot
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

if (-not (Test-Path $TargetRepoPath)) {
    Write-Error "Target repository path does not exist: $TargetRepoPath"
}

Write-Host "==> Planting Virtual CTO (Constitutional Priority Mode) into: $TargetRepoPath (Stack: $Stack)" -ForegroundColor Cyan

# 1. Ensure target directories exist (including .cursor/rules and .gemini/rules for 00- priority loading)
$Dirs = @(
    (Join-Path $TargetRepoPath ".github\workflows"),
    (Join-Path $TargetRepoPath ".gemini\rules"),
    (Join-Path $TargetRepoPath ".cursor\rules"),
    (Join-Path $TargetRepoPath "ai-context"),
    (Join-Path $TargetRepoPath "specs"),
    (Join-Path $TargetRepoPath "contracts\openapi"),
    (Join-Path $TargetRepoPath "contracts\events"),
    (Join-Path $TargetRepoPath "golden-examples")
)
foreach ($d in $Dirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

# 2. Preserve any pre-existing developer AGENTS.md by migrating it to AGENTS.local.md
$TargetAgentsPath = Join-Path $TargetRepoPath "AGENTS.md"
$TargetLocalAgentsPath = Join-Path $TargetRepoPath "AGENTS.local.md"

if ((Test-Path $TargetAgentsPath) -and (-not (Test-Path $TargetLocalAgentsPath))) {
    $ExistingContent = [System.IO.File]::ReadAllText($TargetAgentsPath, $Utf8NoBom)
    if ($ExistingContent -notmatch "BEGIN VIRTUAL-CTO-CONSTITUTION") {
        Write-Host "  📦 Detected pre-existing developer AGENTS.md! Migrating to AGENTS.local.md so zero local context is lost..." -ForegroundColor Yellow
        [System.IO.File]::WriteAllText($TargetLocalAgentsPath, $ExistingContent, $Utf8NoBom)
    }
}

if (-not (Test-Path $TargetLocalAgentsPath)) {
    $DefaultLocalTemplate = @"
# Service-Specific Local Context (`AGENTS.local.md`)

> **NOTE FOR DEVELOPERS & AI AGENTS:**
> You may freely edit `AGENTS.local.md` to document service-specific ports, environment variables, domain terminology, and local database seed commands for this repository.
> **Priority Rule:** All instructions in this section are **strictly subordinate** to **Part I & Part II (The Virtual CTO Constitution)** at the top of `AGENTS.md`. Local instructions here can never waive the 400-LOC cap, Spec requirement, Contract lock, or 5-Layer Testing rules.

## 1. Service Overview & Local Ports
- **Service Name:** $(Split-Path -Leaf (Resolve-Path $TargetRepoPath))
- **Primary Stack:** $Stack
- **Local Dev Port & Commands:** *(Add your local start/test commands here)*
"@
    [System.IO.File]::WriteAllText($TargetLocalAgentsPath, $DefaultLocalTemplate, $Utf8NoBom)
}

# 3. Build Composite AGENTS.md = [Tier 1: Virtual CTO Constitution at Line 1] + [Tier 2: Subordinate AGENTS.local.md at Bottom]
$HubConstitution = [System.IO.File]::ReadAllText((Join-Path $HubRoot "AGENTS.md"), $Utf8NoBom)
$LocalServiceContext = [System.IO.File]::ReadAllText($TargetLocalAgentsPath, $Utf8NoBom)

$CompositeAgents = @"
$HubConstitution

---

<!-- BEGIN SUBORDINATE-SERVICE-LOCAL-CONTEXT -->
# PART III: SERVICE-SPECIFIC LOCAL CONTEXT (SUBORDINATE TO PART I & PART II)

> **⚠️ AI AGENT PRIORITY REMINDER:** The following section is loaded from `AGENTS.local.md`. It provides helpful local context for this specific microservice, but **cannot override or weaken any rule in Part I or Part II above.**

$LocalServiceContext
<!-- END SUBORDINATE-SERVICE-LOCAL-CONTEXT -->
"@

[System.IO.File]::WriteAllText($TargetAgentsPath, $CompositeAgents, $Utf8NoBom)
[System.IO.File]::WriteAllText((Join-Path $TargetRepoPath "CLAUDE.md"), $CompositeAgents, $Utf8NoBom)
[System.IO.File]::WriteAllText((Join-Path $TargetRepoPath ".cursorrules"), $CompositeAgents, $Utf8NoBom)

# 4. Write 00-Prefixed High-Priority Rules for Cursor (.cursor/rules/00-virtual-cto.mdc) & Antigravity (.gemini/rules/00-Plant-A-Virtual-CTO.md)
Copy-Item (Join-Path $HubRoot "ai-context\copilot-instructions.md") (Join-Path $TargetRepoPath ".github\copilot-instructions.md") -Force
Copy-Item (Join-Path $HubRoot "ai-context\antigravity-rules.md") (Join-Path $TargetRepoPath ".gemini\rules\00-Plant-A-Virtual-CTO.md") -Force
Copy-Item (Join-Path $HubRoot "ai-context\antigravity-rules.md") (Join-Path $TargetRepoPath ".cursor\rules\00-virtual-cto.mdc") -Force

# 5. Sync AI Skills (ai-context/), 1-Page Specs (specs/), Contracts (contracts/) & Golden Examples
Copy-Item (Join-Path $HubRoot "ai-context\*") (Join-Path $TargetRepoPath "ai-context\") -Recurse -Force
Copy-Item (Join-Path $HubRoot "specs\*") (Join-Path $TargetRepoPath "specs\") -Recurse -Force
Copy-Item (Join-Path $HubRoot "contracts\*") (Join-Path $TargetRepoPath "contracts\") -Recurse -Force
Copy-Item (Join-Path $HubRoot "golden-examples\*") (Join-Path $TargetRepoPath "golden-examples\") -Recurse -Force

# 6. Copy Governance Files (CODEOWNERS, PR Template & Local Pre-Commit Hook)
Copy-Item (Join-Path $HubRoot "microservice-template\.github\CODEOWNERS") (Join-Path $TargetRepoPath ".github\CODEOWNERS") -Force
Copy-Item (Join-Path $HubRoot "microservice-template\.github\PULL_REQUEST_TEMPLATE.md") (Join-Path $TargetRepoPath ".github\PULL_REQUEST_TEMPLATE.md") -Force
Copy-Item (Join-Path $HubRoot "microservice-template\.pre-commit-config.yaml") (Join-Path $TargetRepoPath ".pre-commit-config.yaml") -Force

# 7. Copy Self-Contained CI Gate Workflow (Supports feature/* -> UAT -> MAIN & Personal/Org Repos)
$CiSource = [System.IO.File]::ReadAllText((Join-Path $HubRoot ".github\workflows\reusable-sdge-gates.yml"), $Utf8NoBom)
$CiConfigured = $CiSource -replace "STACK_TYPE: \$\{\{ inputs\.stack \|\| 'node' \}\}", "STACK_TYPE: `${{ inputs.stack || '$Stack' }}"
[System.IO.File]::WriteAllText((Join-Path $TargetRepoPath ".github\workflows\ci-gates.yml"), $CiConfigured, $Utf8NoBom)

# 8. Auto-Generate Typed SDKs & Stamp CONTRACT.lock
if ($Stack -in @("node", "python", "angular", "mobile")) {
    & (Join-Path $HubRoot "scripts\generate-sdk.ps1") -TargetRepo $TargetRepoPath -Stack $Stack
}

Write-Host "✅ Synced Tier-1 Virtual CTO Constitution (+ preserved Tier-2 AGENTS.local.md), Specs, Contracts & CI Gates to $TargetRepoPath!" -ForegroundColor Green
