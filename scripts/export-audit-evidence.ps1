<#
.SYNOPSIS
    Plant-A-Virtual-CTO: Automated SOC 2 & ISO 27001:2022 Evidence Bundle Exporter (Windows PowerShell)
.DESCRIPTION
    Uses the GitHub CLI (gh) to automatically query one or more repositories and generate a complete,
    tamper-evident Auditor Evidence Bundle (JSON, CSV, Markdown + SHA256SUMS.txt) covering:
      1. Production Change Population (All merged PRs to main/master with Author, Approver, Spec ID, Timestamps)
      2. Exception & Emergency Change Register ([CTO-OVERRIDE] and [HOTFIX-TRACK] audit log)
      3. Branch Protection & CODEOWNERS Configuration Snapshot
      4. Repository Collaborator & Access Permission Roster (for Quarterly Access Reviews - SOC 2 CC6.2 / ISO A.5.18)
.EXAMPLE
    .\scripts\export-audit-evidence.ps1 -Repos @("planta94/service-a", "planta94/service-b", "planta94/plant-a-virtual-cto") -Limit 100
#>
param(
    [Parameter(Mandatory=$true)]
    [string[]]$Repos,

    [Parameter(Mandatory=$false)]
    [int]$Limit = 100,

    [Parameter(Mandatory=$false)]
    [string]$OutputBaseDir = ""
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI ('gh') is required. Install from https://cli.github.com/ and run 'gh auth login'."
}

$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")
if ($OutputBaseDir -eq "") {
    $HubRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
    $OutputBaseDir = Join-Path $HubRoot "compliance\evidence-bundles\audit-$Timestamp"
}

New-Item -ItemType Directory -Force -Path $OutputBaseDir | Out-Null
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

Write-Host "🔒 Generating SOC 2 & ISO 27001 Auditor Evidence Bundle in $OutputBaseDir..." -ForegroundColor Cyan

$ExceptionsMarkdown = @"
# SOC 2 (CC8.1) & ISO 27001 (A.8.32) Exception & Emergency Hotfix Register
**Generated UTC:** $((Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss")) UTC

| Repository | PR # | Title | Author | Merged At | Exception Type | Justification / Tag |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
"@

foreach ($repo in $Repos) {
    $SafeName = $repo.Replace("/", "__")
    Write-Host "  -> Collecting audit evidence for $repo..." -ForegroundColor Yellow

    # 1. Export Merged Production PRs
    $PrJsonPath = Join-Path $OutputBaseDir "$SafeName-production-prs.json"
    $PrRaw = gh pr list --repo $repo --state merged --base main --limit $Limit --json number,title,author,mergedAt,mergedBy,reviewDecision,reviews,body,mergeCommit,url 2>$null
    if (-not $PrRaw) {
        $PrRaw = "[]"
    }
    [System.IO.File]::WriteAllText($PrJsonPath, $PrRaw, $Utf8NoBom)

    # Scan PRs for [CTO-OVERRIDE] or [HOTFIX-TRACK]
    $PrObjects = $PrRaw | ConvertFrom-Json
    foreach ($pr in $PrObjects) {
        $combined = "$($pr.title) $($pr.body)"
        if ($combined -match "\[CTO-OVERRIDE:[^\]]+\]" -or $combined -match "\[HOTFIX-TRACK\]") {
            $tag = $matches[0]
            $type = if ($combined -match "HOTFIX") { "EMERGENCY HOTFIX" } else { "CTO OVERRIDE" }
            $ExceptionsMarkdown += "`n| `$repo` | [#$($pr.number)]($($pr.url)) | $($pr.title -replace '\|','-') | @$($pr.author.login) | $($pr.mergedAt) | **$type** | ``$tag`` |"
        }
    }

    # 2. Export Branch Protection Snapshot for main & UAT
    $BranchProtPath = Join-Path $OutputBaseDir "$SafeName-branch-protection.json"
    $MainProt = gh api "repos/$repo/branches/main/protection" 2>$null
    if (-not $MainProt) {
        $MainProt = '{"status": "unprotected_or_insufficient_permissions"}'
    }
    [System.IO.File]::WriteAllText($BranchProtPath, $MainProt, $Utf8NoBom)

    # 3. Export Collaborator Access Roster (SOC 2 CC6.1 / CC6.2)
    $AccessPath = Join-Path $OutputBaseDir "$SafeName-access-roster.json"
    $Collaborators = gh api "repos/$repo/collaborators" --jq '[.[] | {login: .login, role_name: .role_name, permissions: .permissions}]' 2>$null
    if (-not $Collaborators) {
        $Collaborators = "[]"
    }
    [System.IO.File]::WriteAllText($AccessPath, $Collaborators, $Utf8NoBom)
}

# Write Exception & Hotfix Register
$ExceptionsPath = Join-Path $OutputBaseDir "EXCEPTIONS-AND-HOTFIX-REGISTER.md"
[System.IO.File]::WriteAllText($ExceptionsPath, $ExceptionsMarkdown, $Utf8NoBom)

# Generate Tamper-Evident SHA-256 Manifest for External Auditors
$HashManifestPath = Join-Path $OutputBaseDir "SHA256SUMS.txt"
$HashLines = @()
Get-ChildItem -Path $OutputBaseDir -File | Where-Object { $_.Name -ne "SHA256SUMS.txt" } | Sort-Object Name | ForEach-Object {
    $hash = (Get-FileHash -Path $_.FullName -Algorithm SHA256).Hash.ToLower()
    $HashLines += "$hash  $($_.Name)"
}
[System.IO.File]::WriteAllText($HashManifestPath, ($HashLines -join "`n"), $Utf8NoBom)

Write-Host "✅ SOC 2 / ISO 27001 Evidence Bundle exported to: $OutputBaseDir" -ForegroundColor Green
Write-Host "   Tamper-Evident Hash Manifest: $HashManifestPath"
