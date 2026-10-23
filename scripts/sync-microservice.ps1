<#
.SYNOPSIS
  Synchronizes AGENTS.md, AI tool instruction files (Antigravity, Copilot, Codex, Cursor, Claude),
  CODEOWNERS, PR Templates, Local Pre-Commit Hooks (.pre-commit-config.yaml), and self-contained
  SOC2/ISO27001 CI workflows (supporting feature/* -> UAT -> MAIN) into any target microservice repo.

.EXAMPLE
  .\scripts\sync-microservice.ps1 -TargetRepoPath "..\order-service" -Stack "node"
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

if (-not (Test-Path $TargetRepoPath)) {
    Write-Error "Target repository path does not exist: $TargetRepoPath"
}

Write-Host "==> Syncing SDGE + SOC2/ISO27001 Standards to: $TargetRepoPath (Stack: $Stack)" -ForegroundColor Cyan

# 1. Ensure target directories exist
$Dirs = @(
    (Join-Path $TargetRepoPath ".github\workflows"),
    (Join-Path $TargetRepoPath ".gemini\rules")
)
foreach ($d in $Dirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

# 2. Copy Master AGENTS.md & Bridge Files for Every AI Tool
Copy-Item (Join-Path $HubRoot "AGENTS.md") (Join-Path $TargetRepoPath "AGENTS.md") -Force
Copy-Item (Join-Path $HubRoot "AGENTS.md") (Join-Path $TargetRepoPath "CLAUDE.md") -Force
Copy-Item (Join-Path $HubRoot "AGENTS.md") (Join-Path $TargetRepoPath ".cursorrules") -Force
Copy-Item (Join-Path $HubRoot "ai-context\copilot-instructions.md") (Join-Path $TargetRepoPath ".github\copilot-instructions.md") -Force
Copy-Item (Join-Path $HubRoot "ai-context\antigravity-rules.md") (Join-Path $TargetRepoPath ".gemini\rules\Plant-A-Virtual-CTO.md") -Force

# 3. Copy Governance Files (CODEOWNERS, PR Template & Local Pre-Commit Hook)
Copy-Item (Join-Path $HubRoot "microservice-template\.github\CODEOWNERS") (Join-Path $TargetRepoPath ".github\CODEOWNERS") -Force
Copy-Item (Join-Path $HubRoot "microservice-template\.github\PULL_REQUEST_TEMPLATE.md") (Join-Path $TargetRepoPath ".github\PULL_REQUEST_TEMPLATE.md") -Force
Copy-Item (Join-Path $HubRoot "microservice-template\.pre-commit-config.yaml") (Join-Path $TargetRepoPath ".pre-commit-config.yaml") -Force

# 4. Copy Self-Contained CI Gate Workflow (Supports feature/* -> UAT -> MAIN & Personal/Org Repos)
$CiSource = Get-Content (Join-Path $HubRoot ".github\workflows\reusable-sdge-gates.yml") -Raw
$CiConfigured = $CiSource -replace "STACK_TYPE: \$\{\{ inputs\.stack \|\| 'node' \}\}", "STACK_TYPE: \$\{\{ inputs.stack || '$Stack' \}\}"
Set-Content -Path (Join-Path $TargetRepoPath ".github\workflows\ci-gates.yml") -Value $CiConfigured -Encoding UTF8

Write-Host "✅ Successfully synced all AI context, Pre-Commit hooks, and UAT->MAIN CI gates to $TargetRepoPath!" -ForegroundColor Green

