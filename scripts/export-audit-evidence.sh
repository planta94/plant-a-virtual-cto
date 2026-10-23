#!/usr/bin/env bash
# ==============================================================================
# Plant-A-Virtual-CTO: Automated SOC 2 & ISO 27001 Evidence Bundle Exporter
# ==============================================================================
# Queries GitHub repositories via 'gh' CLI and exports a tamper-evident audit
# evidence bundle (production PR logs, [CTO-OVERRIDE] & [HOTFIX-TRACK] register,
# branch protection configs, and collaborator access rosters + SHA256SUMS.txt).
#
# Usage:
#   ./scripts/export-audit-evidence.sh "owner/service-a owner/service-b owner/Plant-A-Virtual-CTO"
# ==============================================================================
set -euo pipefail

REPOS="${1:-}"
LIMIT="${2:-100}"

if [ -z "$REPOS" ]; then
  echo "Usage: ./scripts/export-audit-evidence.sh \"owner/repo1 owner/repo2\" [limit]"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HUB_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DATE_STR="$(date -u +"%Y-%m-%d")"
OUT_DIR="$HUB_ROOT/compliance/evidence-bundles/audit-$DATE_STR"

mkdir -p "$OUT_DIR"
echo "🔒 Generating SOC 2 & ISO 27001 Auditor Evidence Bundle in $OUT_DIR..."

EXCEPTIONS_FILE="$OUT_DIR/EXCEPTIONS-AND-HOTFIX-REGISTER.md"
cat <<EOF > "$EXCEPTIONS_FILE"
# SOC 2 (CC8.1) & ISO 27001 (A.8.32) Exception & Emergency Hotfix Register
**Generated UTC:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")

| Repository | PR # | Title | Author | Merged At | Exception Type | Justification / Tag |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
EOF

for repo in $REPOS; do
  safe_name="${repo//\//__}"
  echo "  -> Collecting audit evidence for $repo..."

  # 1. Production PRs merged to main
  pr_file="$OUT_DIR/${safe_name}-production-prs.json"
  gh pr list --repo "$repo" --state merged --base main --limit "$LIMIT" \
    --json number,title,author,mergedAt,mergedBy,reviewDecision,reviews,body,mergeCommit,url > "$pr_file" 2>/dev/null || echo "[]" > "$pr_file"

  # Extract [CTO-OVERRIDE] and [HOTFIX-TRACK] entries
  jq -r --arg repo "$repo" '.[] | select((.title + " " + .body) | test("\\[(CTO-OVERRIDE:[^\\]]+|HOTFIX-TRACK)\\]"; "i")) | "| `" + $repo + "` | [#" + (.number|tostring) + "](" + .url + ") | " + (.title | gsub("\\|"; "-")) + " | @" + .author.login + " | " + .mergedAt + " | **EXCEPTION/HOTFIX** | `" + ((.title + " " + .body) | match("\\[(CTO-OVERRIDE:[^\\]]+|HOTFIX-TRACK)\\]"; "i").string) + "` |"' "$pr_file" >> "$EXCEPTIONS_FILE" || true

  # 2. Branch Protection Snapshot
  prot_file="$OUT_DIR/${safe_name}-branch-protection.json"
  gh api "repos/$repo/branches/main/protection" > "$prot_file" 2>/dev/null || echo '{"status":"unprotected_or_no_admin_token"}' > "$prot_file"

  # 3. Collaborator Access Roster (SOC 2 CC6.1 / CC6.2)
  access_file="$OUT_DIR/${safe_name}-access-roster.json"
  gh api "repos/$repo/collaborators" --jq '[.[] | {login: .login, role_name: .role_name, permissions: .permissions}]' > "$access_file" 2>/dev/null || echo "[]" > "$access_file"
done

(cd "$OUT_DIR" && sha256sum *.json *.md > SHA256SUMS.txt)
echo "✅ Evidence bundle complete: $OUT_DIR (with SHA256SUMS.txt)"
