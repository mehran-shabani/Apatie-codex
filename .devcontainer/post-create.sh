#!/usr/bin/env bash
set -euo pipefail

APT_PACKAGES=(curl git unzip xz-utils zip libglu1-mesa)

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y --no-install-recommends "${APT_PACKAGES[@]}"
sudo rm -rf /var/lib/apt/lists/*

sudo install -d -m 0755 -o "$(id -u)" -g "$(id -g)" /opt/flutter
if [ ! -d "/opt/flutter/.git" ]; then
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git /opt/flutter
else
  git -C /opt/flutter fetch origin stable --depth 1
  git -C /opt/flutter reset --hard FETCH_HEAD
fi

sudo mkdir -p /etc/profile.d
sudo tee /etc/profile.d/flutter.sh > /dev/null <<'PATH_EOF'
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
popd

cat <<'INFO'
The dev container bootstrap finished successfully.

Run frontend and backend test suites manually once you are ready:
  pushd frontend/flutter_app && flutter test && popd
  pytest
INFO
