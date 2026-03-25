#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"

DEFINE_FILE="${DART_DEFINE_FILE:-$ROOT/.vscode/dart_define.prod.local.json}"
BUILD_NAME="${BUILD_NAME:-}"
BUILD_NUMBER="${BUILD_NUMBER:-}"
KEY_ID="${APP_STORE_CONNECT_API_KEY_ID:-}"
ISSUER_ID="${APP_STORE_CONNECT_ISSUER_ID:-}"
KEY_PATH="${APP_STORE_CONNECT_API_KEY_PATH:-}"
SKIP_UPLOAD="${SKIP_UPLOAD:-0}"

if [[ ! -f "$DEFINE_FILE" ]]; then
  echo "Missing define file: $DEFINE_FILE"
  echo "Set DART_DEFINE_FILE or create .vscode/dart_define.prod.local.json first."
  exit 1
fi

BUILD_ARGS=(
  ipa
  --flavor prod
  -t lib/main_prod.dart
  --dart-define-from-file="$DEFINE_FILE"
  --export-method app-store
)

if [[ -n "$BUILD_NAME" ]]; then
  BUILD_ARGS+=(--build-name "$BUILD_NAME")
fi

if [[ -n "$BUILD_NUMBER" ]]; then
  BUILD_ARGS+=(--build-number "$BUILD_NUMBER")
fi

echo "==> Building App Store IPA"
(
  cd "$ROOT"
  fvm flutter build "${BUILD_ARGS[@]}"
)

IPA_PATH="$(find "$ROOT/build/ios/ipa" -maxdepth 1 -name '*.ipa' | head -n 1)"
if [[ -z "$IPA_PATH" ]]; then
  echo "IPA not found under $ROOT/build/ios/ipa"
  exit 1
fi

echo "==> IPA generated: $IPA_PATH"

if [[ "$SKIP_UPLOAD" == "1" ]]; then
  echo "SKIP_UPLOAD=1 set. Archive/export finished."
  exit 0
fi

if [[ -z "$KEY_ID" || -z "$ISSUER_ID" ]]; then
  echo "Upload requires APP_STORE_CONNECT_API_KEY_ID and APP_STORE_CONNECT_ISSUER_ID."
  echo "You can also set APP_STORE_CONNECT_API_KEY_PATH to the .p8 file."
  exit 1
fi

cleanup() {
  if [[ -n "${TEMP_KEY_DIR:-}" && -d "${TEMP_KEY_DIR:-}" ]]; then
    rm -rf "$TEMP_KEY_DIR"
  fi
}
trap cleanup EXIT

if [[ -n "$KEY_PATH" ]]; then
  if [[ ! -f "$KEY_PATH" ]]; then
    echo "App Store Connect API key file not found: $KEY_PATH"
    exit 1
  fi
  TEMP_KEY_DIR="$(mktemp -d)"
  cp "$KEY_PATH" "$TEMP_KEY_DIR/AuthKey_${KEY_ID}.p8"
  export API_PRIVATE_KEYS_DIR="$TEMP_KEY_DIR"
fi

echo "==> Uploading IPA to App Store Connect"
if xcrun iTMSTransporter -m upload \
  -assetFile "$IPA_PATH" \
  -apiKey "$KEY_ID" \
  -apiIssuer "$ISSUER_ID" \
  -v informational; then
  echo "Upload completed."
  exit 0
fi

echo "iTMSTransporter upload failed. Trying altool fallback..."
xcrun altool \
  --upload-app \
  --type ios \
  --file "$IPA_PATH" \
  --apiKey "$KEY_ID" \
  --apiIssuer "$ISSUER_ID" \
  --verbose
