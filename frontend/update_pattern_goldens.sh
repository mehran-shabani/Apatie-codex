#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="${SCRIPT_DIR}/flutter_app"
PATTERN_TEST_DIR="test/design_system/patterns"

if [[ ! -d "${APP_DIR}" ]]; then
  echo "Expected Flutter application directory at '${APP_DIR}', but it was not found." >&2
  exit 1
fi

if ! command -v flutter >/dev/null 2>&1; then
  cat >&2 <<'MSG'
Flutter SDK was not detected on PATH.
Install Flutter and ensure 'flutter' is available before running this script.
MSG
  exit 1
fi

pushd "${APP_DIR}" >/dev/null
flutter pub get
flutter test --update-goldens "${PATTERN_TEST_DIR}"
popd >/dev/null

echo "Pattern golden baselines were updated under frontend/flutter_app/${PATTERN_TEST_DIR}/../goldens." 
