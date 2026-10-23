<#
.SYNOPSIS
    Plant-A-Virtual-CTO: Cross-Repo Contract SDK Generator & Lockfile Stamper (Windows PowerShell)
.DESCRIPTION
    Generates strict TypeScript (Node.js/Angular), Python (Pydantic v2), or Dart/Mobile client/server types
    from OpenAPI 3.1 & Event JSON Schemas. Supports both a local Plant-A-Virtual-CTO checkout OR fetching
    contracts directly from a remote GitHub repository URL. Stamps a cryptographic CONTRACT.lock file in the
    target repository so CI Gate 1 can block hand-edited DTO drift.
.EXAMPLE
    .\scripts\generate-sdk.ps1 -TargetRepo "..\service-a" -Stack "node"
.EXAMPLE
    .\scripts\generate-sdk.ps1 -TargetRepo "." -Stack "python" -RemoteHubUrl "https://github.com/your-org/Plant-A-Virtual-CTO.git" -ContractRef "main"
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$TargetRepo,

    [Parameter(Mandatory=$true)]
    [ValidateSet("node", "python", "angular", "mobile")]
    [string]$Stack,

    [Parameter(Mandatory=$false)]
    [string]$RemoteHubUrl = "",

    [Parameter(Mandatory=$false)]
    [string]$ContractRef = "main"
)

$ErrorActionPreference = "Stop"
$TargetFullPath = (Resolve-Path $TargetRepo).Path
$TempHubDir = ""

try {
    if ($RemoteHubUrl -ne "") {
        Write-Host "🌐 Fetching contracts from remote Hub ($RemoteHubUrl @ $ContractRef)..." -ForegroundColor Cyan
        $TempHubDir = Join-Path ([System.IO.Path]::GetTempPath()) ("virtual-cto-contracts-" + [Guid]::NewGuid().ToString("N"))
        git clone --depth 1 --branch $ContractRef $RemoteHubUrl $TempHubDir | Out-Null
        $HubRoot = $TempHubDir
    } else {
        $HubRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
    }

    $ContractsDir = Join-Path $HubRoot "contracts"
    if (-not (Test-Path $ContractsDir)) {
        throw "Contracts directory not found at $ContractsDir"
    }

    # Get Hub Commit SHA
    Push-Location $HubRoot
    $HubCommitSha = (git rev-parse HEAD 2>$null)
    if (-not $HubCommitSha) { $HubCommitSha = "local-uncommitted" }
    Pop-Location

    # Compute SHA-256 across all source contract files
    $ContractFiles = Get-ChildItem -Path $ContractsDir -Recurse -File | Sort-Object FullName
    $ConcatenatedHashes = ""
    foreach ($f in $ContractFiles) {
        $ConcatenatedHashes += (Get-FileHash -Path $f.FullName -Algorithm SHA256).Hash
    }
    $Sha256Algo = [System.Security.Cryptography.SHA256]::Create()
    $ContractsSha256 = [BitConverter]::ToString($Sha256Algo.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ConcatenatedHashes))).Replace("-", "").ToLower()

    # Prepare output directory inside target microservice
    $OutDir = Join-Path $TargetFullPath "src\generated\contracts"
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

    Write-Host "⚙️ Generating $Stack SDK & DTO contracts into $OutDir..." -ForegroundColor Cyan

    $OpenApiFiles = Get-ChildItem -Path (Join-Path $ContractsDir "openapi") -Filter "*.yaml" -ErrorAction SilentlyContinue
    foreach ($spec in $OpenApiFiles) {
        $BaseName = $spec.BaseName -replace "\.openapi$", ""
        switch ($Stack) {
            "node" {
                $OutFile = Join-Path $OutDir "$BaseName.types.ts"
                Write-Host "  -> Generating Node.js TypeScript interfaces: $OutFile"
                if (Get-Command npx -ErrorAction SilentlyContinue) {
                    npx --yes openapi-typescript $spec.FullName -o $OutFile
                }
            }
            "angular" {
                $OutFile = Join-Path $OutDir "$BaseName.client.ts"
                Write-Host "  -> Generating Angular TypeScript SDK types: $OutFile"
                if (Get-Command npx -ErrorAction SilentlyContinue) {
                    npx --yes openapi-typescript $spec.FullName -o $OutFile
                }
            }
            "python" {
                $OutFile = Join-Path $OutDir ($BaseName.Replace("-", "_") + "_models.py")
                Write-Host "  -> Generating Python Pydantic v2 models: $OutFile"
                if (Get-Command datamodel-codegen -ErrorAction SilentlyContinue) {
                    datamodel-codegen --input $spec.FullName --input-file-type openapi --output $OutFile --output-model-type pydantic_v2.BaseModel
                }
            }
            "mobile" {
                $OutFile = Join-Path $OutDir "$BaseName.mobile.ts"
                Write-Host "  -> Generating Mobile contract types: $OutFile"
                if (Get-Command npx -ErrorAction SilentlyContinue) {
                    npx --yes openapi-typescript $spec.FullName -o $OutFile
                }
            }
        }
    }

    # Write deterministic manifest inside src/generated/contracts/manifest.json
    $ManifestPath = Join-Path $OutDir "manifest.json"
    $ManifestJson = @{
        generator = "Plant-A-Virtual-CTO"
        stack = $Stack
        hub_commit_sha = $HubCommitSha.Trim()
        contracts_sha256 = $ContractsSha256
    } | ConvertTo-Json -Depth 4
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ManifestPath, $ManifestJson, $Utf8NoBom)

    # Compute SHA-256 of all generated SDK files to lock against manual developer/AI edits
    $GeneratedFiles = Get-ChildItem -Path $OutDir -Recurse -File | Sort-Object FullName
    $SdkHashes = ""
    foreach ($gf in $GeneratedFiles) {
        $SdkHashes += (Get-FileHash -Path $gf.FullName -Algorithm SHA256).Hash
    }
    $SdkOutputSha256 = [BitConverter]::ToString($Sha256Algo.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($SdkHashes))).Replace("-", "").ToLower()

    # Stamp CONTRACT.lock at the root of the target microservice repository
    $LockFilePath = Join-Path $TargetFullPath "CONTRACT.lock"
    $LockContent = @{
        schema_version = "1.0"
        managed_by = "Plant-A-Virtual-CTO"
        stack = $Stack
        hub_commit_sha = $HubCommitSha.Trim()
        contracts_sha256 = $ContractsSha256
        sdk_output_sha256 = $SdkOutputSha256
        generated_at_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    } | ConvertTo-Json -Depth 4
    [System.IO.File]::WriteAllText($LockFilePath, $LockContent, $Utf8NoBom)

    Write-Host "✅ SDK generated & CONTRACT.lock stamped ($LockFilePath)" -ForegroundColor Green
    Write-Host "   Contracts SHA256 : $ContractsSha256"
    Write-Host "   SDK Output SHA256: $SdkOutputSha256"
} finally {
    if ($TempHubDir -ne "" -and (Test-Path $TempHubDir)) {
        Remove-Item -Path $TempHubDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
