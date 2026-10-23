#!/usr/bin/env bash
# =============================================================================
# Stage 2 Contract-First SDK & Type Generator
# Generates strict types & clients for Node.js/TS, Angular, Python, and Mobile
# from a single OpenAPI 3.1 contract so AI tools never hallucinate DTOs.
# =============================================================================
set -euo pipefail

SPEC_FILE="${1:-contracts/openapi/service-template.openapi.yaml}"
SERVICE_NAME="${2:-resource-service}"
OUT_DIR="generated/${SERVICE_NAME}"

echo "==> [Stage 2 Contract Lock] Generating SDKs from: ${SPEC_FILE}"
mkdir -p "${OUT_DIR}/typescript-node" \
         "${OUT_DIR}/angular-client" \
         "${OUT_DIR}/python-pydantic" \
         "${OUT_DIR}/mobile-client"

# 1. Node.js / TypeScript & React Native DTOs (via openapi-typescript)
echo "  -> Generating strict TypeScript interfaces (Node.js / React Native)..."
npx --yes openapi-typescript "${SPEC_FILE}" -o "${OUT_DIR}/typescript-node/schema.d.ts"

# 2. Angular Standalone Injectable Client Services (via @openapitools/openapi-generator-cli)
echo "  -> Generating Angular HTTP Client services & models..."
npx --yes @openapitools/openapi-generator-cli generate \
  -i "${SPEC_FILE}" \
  -g typescript-angular \
  -o "${OUT_DIR}/angular-client" \
  --additional-properties=ngVersion=18.0.0,providedIn=root,useSingleRequestParameter=true,fileNaming=kebab-case

# 3. Python Pydantic v2 Models (via datamodel-code-generator)
echo "  -> Generating Python Pydantic v2 models..."
if command -v uv >/dev/null 2>&1; then
  uv tool run datamodel-code-generator \
    --input "${SPEC_FILE}" \
    --input-file-type openapi \
    --output "${OUT_DIR}/python-pydantic/models.py" \
    --output-model-type pydantic_v2.BaseModel \
    --use-standard-collections \
    --strict-nullable
else
  echo "     [Note] Install 'uv' or 'datamodel-code-generator' to build Python Pydantic models locally."
fi

# 4. Mobile (Dart / Flutter) Client Models
echo "  -> Generating Dart/Flutter models for Mobile..."
npx --yes @openapitools/openapi-generator-cli generate \
  -i "${SPEC_FILE}" \
  -g dart-dio \
  -o "${OUT_DIR}/mobile-client"

echo "==> Done! Generated contracts are in: ${OUT_DIR}"
