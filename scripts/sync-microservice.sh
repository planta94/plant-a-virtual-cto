#!/usr/bin/env bash
# =============================================================================
# Synchronizes AGENTS.md, AI tool instruction files (Antigravity, Copilot,
# Codex, Cursor, Claude), CODEOWNERS, PR Templates, Local Pre-Commit Hooks,
# and self-contained SOC2/ISO27001 CI workflows (feature/* -> UAT -> MAIN)
# into any target microservice repository.
#
# Usage: ./scripts/sync-microservice.sh ../my-service-repo [node|python|angular|mobile]
# =============================================================================
set -euo pipefail

TARGET_REPO="${1:?Usage: $0 <target-repo-path> [node|python|angular|mobile]}"
STACK="${2:-node}"
HUB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -d "${TARGET_REPO}" ]; then
  echo "Error: Target repo directory '${TARGET_REPO}' does not exist." >&2
  exit 1
fi

echo "==> Syncing SDGE + SOC2/ISO27001 Standards to: ${TARGET_REPO} (Stack: ${STACK})"

mkdir -p "${TARGET_REPO}/.github/workflows" \
         "${TARGET_REPO}/.gemini/rules"

# 1. Master AGENTS.md & AI Tool Bridges
cp "${HUB_ROOT}/AGENTS.md" "${TARGET_REPO}/AGENTS.md"
cp "${HUB_ROOT}/AGENTS.md" "${TARGET_REPO}/CLAUDE.md"
cp "${HUB_ROOT}/AGENTS.md" "${TARGET_REPO}/.cursorrules"
cp "${HUB_ROOT}/ai-context/copilot-instructions.md" "${TARGET_REPO}/.github/copilot-instructions.md"
cp "${HUB_ROOT}/ai-context/antigravity-rules.md" "${TARGET_REPO}/.gemini/rules/Plant-A-Virtual-CTO.md"

# 2. GitHub Governance (CODEOWNERS, PR Template & Local Pre-Commit Hook)
cp "${HUB_ROOT}/microservice-template/.github/CODEOWNERS" "${TARGET_REPO}/.github/CODEOWNERS"
cp "${HUB_ROOT}/microservice-template/.github/PULL_REQUEST_TEMPLATE.md" "${TARGET_REPO}/.github/PULL_REQUEST_TEMPLATE.md"
cp "${HUB_ROOT}/microservice-template/.pre-commit-config.yaml" "${TARGET_REPO}/.pre-commit-config.yaml"

# 3. Self-Contained CI Workflow (Supports feature/* -> UAT -> MAIN)
sed "s/STACK_TYPE: \${{ inputs.stack || 'node' }}/STACK_TYPE: \${{ inputs.stack || '${STACK}' }}/g" \
  "${HUB_ROOT}/.github/workflows/reusable-sdge-gates.yml" \
  > "${TARGET_REPO}/.github/workflows/ci-gates.yml"

echo "✅ Synced AI context, Pre-Commit hooks, and UAT->MAIN CI gates to ${TARGET_REPO}!"

