#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: ./scripts/run_flavor.sh <dev|staging|prod> [extra flutter run args...]"
  exit 1
fi

FLAVOR="$1"
shift

case "$FLAVOR" in
  dev|staging|prod)
    ;;
  *)
    echo "Invalid flavor: $FLAVOR"
    echo "Allowed values: dev, staging, prod"
    exit 1
    ;;
esac

DEFINE_FILE=".vscode/dart_define.${FLAVOR}.local.json"
ENTRYPOINT="lib/main_${FLAVOR}.dart"
EXAMPLE_FILE=".vscode/dart_define.${FLAVOR}.example.json"

if [[ ! -f "$DEFINE_FILE" ]]; then
  echo "Missing define file: $DEFINE_FILE"
  echo "Create it first, for example:"
  echo "  cp $EXAMPLE_FILE $DEFINE_FILE"
  exit 1
fi

exec fvm flutter run \
  --flavor "$FLAVOR" \
  -t "$ENTRYPOINT" \
  --dart-define-from-file="$DEFINE_FILE" \
  "$@"
