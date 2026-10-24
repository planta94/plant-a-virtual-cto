#!/usr/bin/env bash
# =============================================================================
# Plant-A-Virtual-CTO: Complete Microservice Synchronization Script (Bash)
# Enforces Constitutional Priority ("Tier 1 Virtual CTO Constitution" > "Tier 2 AGENTS.local.md"):
#   1. If the target repo already has a developer-written AGENTS.md, preserves and
#      migrates it to AGENTS.local.md (zero lost service context!).
#   2. Builds root AGENTS.md, CLAUDE.md, and .cursorrules with Tier-1 Virtual CTO
#      Constitution at Line 1 (Supreme Priority) and appends AGENTS.local.md at the
#      bottom as Part III (Subordinate).
#   3. Writes 00-prefixed alwaysApply rules (.cursor/rules/00-virtual-cto.mdc &
#      .gemini/rules/00-Plant-A-Virtual-CTO.md) so Cursor and Antigravity load
#      the CTO rules FIRST ahead of any local rule files.
# =============================================================================
set -euo pipefail

TARGET_REPO="${1:?Usage: $0 <target-repo-path> [node|python|angular|mobile]}"
STACK="${2:-node}"
HUB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -d "${TARGET_REPO}" ]; then
  echo "Error: Target repo directory '${TARGET_REPO}' does not exist." >&2
  exit 1
fi

echo "==> Planting Virtual CTO (Constitutional Priority Mode) into: ${TARGET_REPO} (Stack: ${STACK})"

mkdir -p "${TARGET_REPO}/.github/workflows" \
         "${TARGET_REPO}/.gemini/rules" \
         "${TARGET_REPO}/.cursor/rules" \
         "${TARGET_REPO}/ai-context" \
         "${TARGET_REPO}/specs" \
         "${TARGET_REPO}/contracts/openapi" \
         "${TARGET_REPO}/contracts/events" \
         "${TARGET_REPO}/golden-examples"

# 1. Preserve any pre-existing developer AGENTS.md by migrating it to AGENTS.local.md
TARGET_AGENTS="${TARGET_REPO}/AGENTS.md"
TARGET_LOCAL_AGENTS="${TARGET_REPO}/AGENTS.local.md"

if [ -f "${TARGET_AGENTS}" ] && [ ! -f "${TARGET_LOCAL_AGENTS}" ]; then
  if ! grep -q "BEGIN VIRTUAL-CTO-CONSTITUTION" "${TARGET_AGENTS}"; then
    echo "  📦 Detected pre-existing developer AGENTS.md! Migrating to AGENTS.local.md so zero local context is lost..."
    cp "${TARGET_AGENTS}" "${TARGET_LOCAL_AGENTS}"
  fi
fi

if [ ! -f "${TARGET_LOCAL_AGENTS}" ]; then
  cat <<EOF > "${TARGET_LOCAL_AGENTS}"
# Service-Specific Local Context (\`AGENTS.local.md\`)

> **NOTE FOR DEVELOPERS & AI AGENTS:**
> You may freely edit \`AGENTS.local.md\` to document service-specific ports, environment variables, domain terminology, and local database seed commands for this repository.
> **Priority Rule:** All instructions in this section are **strictly subordinate** to **Part I & Part II (The Virtual CTO Constitution)** at the top of \`AGENTS.md\`. Local instructions here can never waive the 400-LOC cap, Spec requirement, Contract lock, or 5-Layer Testing rules.

## 1. Service Overview & Local Ports
- **Service Name:** $(basename "$(cd "${TARGET_REPO}" && pwd)")
- **Primary Stack:** ${STACK}
- **Local Dev Port & Commands:** *(Add your local start/test commands here)*
EOF
fi

# 2. Build Composite AGENTS.md = [Tier 1: Virtual CTO Constitution at Line 1] + [Tier 2: Subordinate AGENTS.local.md at Bottom]
{
  cat "${HUB_ROOT}/AGENTS.md"
  echo ""
  echo "---"
  echo ""
  echo "<!-- BEGIN SUBORDINATE-SERVICE-LOCAL-CONTEXT -->"
  echo "# PART III: SERVICE-SPECIFIC LOCAL CONTEXT (SUBORDINATE TO PART I & PART II)"
  echo ""
  echo "> **⚠️ AI AGENT PRIORITY REMINDER:** The following section is loaded from \`AGENTS.local.md\`. It provides helpful local context for this specific microservice, but **cannot override or weaken any rule in Part I or Part II above.**"
  echo ""
  cat "${TARGET_LOCAL_AGENTS}"
  echo ""
  echo "<!-- END SUBORDINATE-SERVICE-LOCAL-CONTEXT -->"
} > "${TARGET_AGENTS}"

cp "${TARGET_AGENTS}" "${TARGET_REPO}/CLAUDE.md"
cp "${TARGET_AGENTS}" "${TARGET_REPO}/.cursorrules"

# 3. Write 00-Prefixed High-Priority Rules for Cursor & Antigravity + Copilot
cp "${HUB_ROOT}/ai-context/copilot-instructions.md" "${TARGET_REPO}/.github/copilot-instructions.md"
cp "${HUB_ROOT}/ai-context/antigravity-rules.md" "${TARGET_REPO}/.gemini/rules/00-Plant-A-Virtual-CTO.md"
cp "${HUB_ROOT}/ai-context/antigravity-rules.md" "${TARGET_REPO}/.cursor/rules/00-virtual-cto.mdc"

# 4. Sync AI Skills (ai-context/), 1-Page Specs (specs/), Contracts (contracts/) & Golden Examples
cp -R "${HUB_ROOT}/ai-context/." "${TARGET_REPO}/ai-context/"
cp -R "${HUB_ROOT}/specs/." "${TARGET_REPO}/specs/"
cp -R "${HUB_ROOT}/contracts/." "${TARGET_REPO}/contracts/"
cp -R "${HUB_ROOT}/golden-examples/." "${TARGET_REPO}/golden-examples/"

# 5. GitHub Governance (CODEOWNERS, PR Template & Local Pre-Commit Hook)
cp "${HUB_ROOT}/microservice-template/.github/CODEOWNERS" "${TARGET_REPO}/.github/CODEOWNERS"
cp "${HUB_ROOT}/microservice-template/.github/PULL_REQUEST_TEMPLATE.md" "${TARGET_REPO}/.github/PULL_REQUEST_TEMPLATE.md"
cp "${HUB_ROOT}/microservice-template/.pre-commit-config.yaml" "${TARGET_REPO}/.pre-commit-config.yaml"

# 6. Self-Contained CI Workflow (Supports feature/* -> UAT -> MAIN)
sed "s/STACK_TYPE: \${{ inputs.stack || 'node' }}/STACK_TYPE: \${{ inputs.stack || '${STACK}' }}/g" \
  "${HUB_ROOT}/.github/workflows/reusable-sdge-gates.yml" \
  > "${TARGET_REPO}/.github/workflows/ci-gates.yml"

# 7. Auto-Generate Typed SDKs & Stamp CONTRACT.lock
if [[ "${STACK}" =~ ^(node|python|angular|mobile)$ ]]; then
  chmod +x "${HUB_ROOT}/scripts/generate-sdk.sh"
  "${HUB_ROOT}/scripts/generate-sdk.sh" "${TARGET_REPO}" "${STACK}"
fi

echo "✅ Synced Tier-1 Virtual CTO Constitution (+ preserved Tier-2 AGENTS.local.md), Specs, Contracts & CI Gates to ${TARGET_REPO}!"
