#!/usr/bin/env bash
set -euo pipefail

APT_PACKAGES=(curl git unzip xz-utils zip libglu1-mesa)

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends "${APT_PACKAGES[@]}"
rm -rf /var/lib/apt/lists/*

if [ ! -d "/opt/flutter/.git" ]; then
  git clone https://github.com/flutter/flutter.git /opt/flutter
else
  git -C /opt/flutter fetch --tags
  git -C /opt/flutter pull --ff-only
fi

cat <<'PATH_EOF' > /etc/profile.d/flutter.sh
export PATH="/opt/flutter/bin:$PATH"
PATH_EOF

export PATH="/opt/flutter/bin:$PATH"

flutter --version
flutter config --no-analytics
flutter precache --no-android --no-ios

pip install --upgrade pip
pip install -r requirements.txt

pushd frontend/flutter_app
flutter pub get
flutter test
popd

pytest
