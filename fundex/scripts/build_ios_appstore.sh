#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$DIR/.." && pwd)"

DEFINE_FILE="${DART_DEFINE_FILE:-$ROOT/.vscode/dart_define.prod.local.json}"
BUILD_NAME="${BUILD_NAME:-}"
BUILD_NUMBER="${BUILD_NUMBER:-}"
IPA_OUTPUT_NAME="${IPA_OUTPUT_NAME:-}"
KEY_ID="${APP_STORE_CONNECT_API_KEY_ID:-}"
ISSUER_ID="${APP_STORE_CONNECT_ISSUER_ID:-}"
KEY_PATH="${APP_STORE_CONNECT_API_KEY_PATH:-}"
SKIP_UPLOAD="${SKIP_UPLOAD:-0}"
IOS_TEAM_ID="${IOS_TEAM_ID:-PGU4LJ2SPF}"
IOS_BUNDLE_ID="${IOS_BUNDLE_ID:-com.fund.stellavia}"
IOS_PROVISIONING_PROFILE_NAME="${IOS_PROVISIONING_PROFILE_NAME:-Stellavia_release_Profile}"

cleanup() {
  if [[ -n "${TEMP_KEY_DIR:-}" && -d "${TEMP_KEY_DIR:-}" ]]; then
    rm -rf "$TEMP_KEY_DIR"
  fi
  if [[ -n "${TEMP_EXPORT_DIR:-}" && -d "${TEMP_EXPORT_DIR:-}" ]]; then
    rm -rf "$TEMP_EXPORT_DIR"
  fi
}
trap cleanup EXIT

if [[ -n "${FLUTTER_ROOT:-}" && -x "${FLUTTER_ROOT}/bin/flutter" ]]; then
  FLUTTER_CMD=("${FLUTTER_ROOT}/bin/flutter")
elif command -v fvm >/dev/null 2>&1; then
  FLUTTER_CMD=(fvm flutter)
else
  FLUTTER_CMD=(flutter)
fi

if [[ ! -f "$DEFINE_FILE" ]]; then
  echo "Missing define file: $DEFINE_FILE"
  echo "Set DART_DEFINE_FILE or create .vscode/dart_define.prod.local.json first."
  exit 1
fi

TEMP_EXPORT_DIR="$(mktemp -d)"
EXPORT_OPTIONS_PLIST="$TEMP_EXPORT_DIR/ExportOptions.plist"
cat > "$EXPORT_OPTIONS_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>app-store</string>
  <key>signingStyle</key>
  <string>manual</string>
  <key>teamID</key>
  <string>${IOS_TEAM_ID}</string>
  <key>signingCertificate</key>
  <string>Apple Distribution</string>
  <key>provisioningProfiles</key>
  <dict>
    <key>${IOS_BUNDLE_ID}</key>
    <string>${IOS_PROVISIONING_PROFILE_NAME}</string>
  </dict>
</dict>
</plist>
EOF

BUILD_ARGS=(
  ipa
  --flavor prod
  -t lib/main_prod.dart
  --dart-define-from-file="$DEFINE_FILE"
  --export-options-plist="$EXPORT_OPTIONS_PLIST"
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
  "${FLUTTER_CMD[@]}" build "${BUILD_ARGS[@]}"
)

IPA_PATH="$(find "$ROOT/build/ios/ipa" -maxdepth 1 -name '*.ipa' | head -n 1)"
if [[ -z "$IPA_PATH" ]]; then
  echo "IPA not found under $ROOT/build/ios/ipa"
  exit 1
fi

if [[ -n "$IPA_OUTPUT_NAME" ]]; then
  RENAMED_IPA_PATH="$ROOT/build/ios/ipa/$IPA_OUTPUT_NAME"
  if [[ "$IPA_PATH" != "$RENAMED_IPA_PATH" ]]; then
    mv "$IPA_PATH" "$RENAMED_IPA_PATH"
    IPA_PATH="$RENAMED_IPA_PATH"
  fi
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

if [[ -n "$KEY_PATH" ]]; then
  if [[ ! -f "$KEY_PATH" ]]; then
    echo "App Store Connect API key file not found: $KEY_PATH"
    exit 1
  fi
  TEMP_KEY_DIR="$(mktemp -d)"
  cp "$KEY_PATH" "$TEMP_KEY_DIR/AuthKey_${KEY_ID}.p8"
  export API_PRIVATE_KEYS_DIR="$TEMP_KEY_DIR"
fi

upload_with_altool() {
  xcrun altool \
    --upload-app \
    --type ios \
    --file "$IPA_PATH" \
    --apiKey "$KEY_ID" \
    --apiIssuer "$ISSUER_ID" \
    --verbose
}

find_transporter_path() {
  local developer_dir xcode_app
  developer_dir="$(xcode-select -p 2>/dev/null || true)"
  xcode_app="${developer_dir%/Contents/Developer}"

  local candidates=(
    "$xcode_app/Contents/SharedFrameworks/ContentDeliveryServices.framework/itms/bin/iTMSTransporter"
    "$xcode_app/Contents/SharedFrameworks/ContentDeliveryServices.framework/Frameworks/AppStoreService.framework/itms/bin/iTMSTransporter"
    "/Applications/Transporter.app/Contents/itms/bin/iTMSTransporter"
    "/usr/local/itms/bin/iTMSTransporter"
  )

  local path
  for path in "${candidates[@]}"; do
    if [[ -x "$path" ]]; then
      printf '%s\n' "$path"
      return 0
    fi
  done

  return 1
}

echo "==> Uploading IPA to App Store Connect"
if [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
  echo "Running on GitHub Actions. Using altool upload path."
  upload_with_altool
  exit 0
fi

TRANSPORTER_PATH="$(find_transporter_path || true)"
if [[ -n "${TRANSPORTER_PATH:-}" ]]; then
  if "$TRANSPORTER_PATH" -m upload \
    -assetFile "$IPA_PATH" \
    -apiKey "$KEY_ID" \
    -apiIssuer "$ISSUER_ID" \
    -v informational; then
    echo "Upload completed."
    exit 0
  fi

  echo "iTMSTransporter upload failed. Trying altool fallback..."
else
  echo "iTMSTransporter not found. Using altool upload path."
fi

upload_with_altool
