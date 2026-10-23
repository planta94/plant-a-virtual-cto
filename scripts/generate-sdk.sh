#!/usr/bin/env bash
# ==============================================================================
# Plant-A-Virtual-CTO: Cross-Repo Contract SDK Generator & Lockfile Stamper
# ==============================================================================
# Generates strict TypeScript (Node.js/Angular), Python (Pydantic v2), or Mobile
# DTOs from contracts/openapi/ & contracts/events/.
# Supports both local hub checkouts AND remote GitHub repository fetching, and
# stamps a cryptographic CONTRACT.lock file so CI Gate 1 blocks hand-edited DTOs.
#
# Usage (Local Hub):
#   ./scripts/generate-sdk.sh ../service-a node
# Usage (Remote Hub from inside a microservice repo):
#   ./scripts/generate-sdk.sh . python https://github.com/your-org/Plant-A-Virtual-CTO.git main
# ==============================================================================
set -euo pipefail

TARGET_REPO="${1:-}"
STACK="${2:-}"
REMOTE_HUB_URL="${3:-}"
CONTRACT_REF="${4:-main}"

if [ -z "$TARGET_REPO" ] || [ -z "$STACK" ]; then
  echo "Usage: ./scripts/generate-sdk.sh <target-repo-path> <node|python|angular|mobile> [remote-hub-git-url] [branch-or-tag]"
  exit 1
fi

TARGET_FULL_PATH="$(cd "$TARGET_REPO" && pwd)"
TMP_HUB_DIR=""

cleanup() {
  if [ -n "$TMP_HUB_DIR" ] && [ -d "$TMP_HUB_DIR" ]; then
    rm -rf "$TMP_HUB_DIR"
  fi
}
trap cleanup EXIT

if [ -n "$REMOTE_HUB_URL" ]; then
  echo "🌐 Fetching contracts from remote Hub ($REMOTE_HUB_URL @ $CONTRACT_REF)..."
  TMP_HUB_DIR="$(mktemp -d)"
  git clone --depth 1 --branch "$CONTRACT_REF" "$REMOTE_HUB_URL" "$TMP_HUB_DIR" >/dev/null 2>&1
  HUB_ROOT="$TMP_HUB_DIR"
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  HUB_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

CONTRACTS_DIR="$HUB_ROOT/contracts"
if [ ! -d "$CONTRACTS_DIR" ]; then
  echo "❌ Error: contracts directory not found at $CONTRACTS_DIR"
  exit 1
fi

HUB_COMMIT_SHA="$(cd "$HUB_ROOT" && git rev-parse HEAD 2>/dev/null || echo 'local-uncommitted')"
CONTRACTS_SHA256="$(find "$CONTRACTS_DIR" -type f | sort | xargs sha256sum | sha256sum | awk '{print $1}')"

OUT_DIR="$TARGET_FULL_PATH/src/generated/contracts"
mkdir -p "$OUT_DIR"

echo "⚙️ Generating $STACK SDK & DTO contracts into $OUT_DIR..."

for spec in "$CONTRACTS_DIR"/openapi/*.yaml; do
  [ -e "$spec" ] || continue
  base_name="$(basename "$spec" .yaml)"
  base_name="${base_name%.openapi}"

  case "$STACK" in
    node)
      out_file="$OUT_DIR/${base_name}.types.ts"
      echo "  -> Generating Node.js TypeScript interfaces: $out_file"
      if command -v npx >/dev/null 2>&1; then
        npx --yes openapi-typescript "$spec" -o "$out_file"
      fi
      ;;
    angular)
      out_file="$OUT_DIR/${base_name}.client.ts"
      echo "  -> Generating Angular TypeScript SDK types: $out_file"
      if command -v npx >/dev/null 2>&1; then
        npx --yes openapi-typescript "$spec" -o "$out_file"
      fi
      ;;
    python)
      py_name="${base_name//-/_}"
      out_file="$OUT_DIR/${py_name}_models.py"
      echo "  -> Generating Python Pydantic v2 models: $out_file"
      if command -v datamodel-codegen >/dev/null 2>&1; then
        datamodel-codegen --input "$spec" --input-file-type openapi --output "$out_file" --output-model-type pydantic_v2.BaseModel
      fi
      ;;
    mobile)
      out_file="$OUT_DIR/${base_name}.mobile.ts"
      echo "  -> Generating Mobile contract types: $out_file"
      if command -v npx >/dev/null 2>&1; then
        npx --yes openapi-typescript "$spec" -o "$out_file"
      fi
      ;;
    *)
      echo "❌ Unknown stack: $STACK (expected node, python, angular, or mobile)"
      exit 1
      ;;
  esac
done

cat <<EOF > "$OUT_DIR/manifest.json"
{
  "generator": "Plant-A-Virtual-CTO",
  "stack": "$STACK",
  "hub_commit_sha": "$HUB_COMMIT_SHA",
  "contracts_sha256": "$CONTRACTS_SHA256"
}
EOF

SDK_OUTPUT_SHA256="$(find "$OUT_DIR" -type f | sort | xargs sha256sum | sha256sum | awk '{print $1}')"
GENERATED_AT_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

cat <<EOF > "$TARGET_FULL_PATH/CONTRACT.lock"
{
  "schema_version": "1.0",
  "managed_by": "Plant-A-Virtual-CTO",
  "stack": "$STACK",
  "hub_commit_sha": "$HUB_COMMIT_SHA",
  "contracts_sha256": "$CONTRACTS_SHA256",
  "sdk_output_sha256": "$SDK_OUTPUT_SHA256",
  "generated_at_utc": "$GENERATED_AT_UTC"
}
EOF

echo "✅ SDK generated & CONTRACT.lock stamped ($TARGET_FULL_PATH/CONTRACT.lock)"
echo "   Contracts SHA256 : $CONTRACTS_SHA256"
echo "   SDK Output SHA256: $SDK_OUTPUT_SHA256"
