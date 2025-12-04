#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/config.sh"

echo "[setup-host] Installing base packages"
sudo apt-get update -qq
sudo apt-get install -y -qq git docker.io

echo "[setup-host] Setting up docker, projects root, and SSH config"
sudo usermod -aG docker "$USER" || true

mkdir -p "$PROJECTS_ROOT"

mkdir -p "$HOME/.ssh/vms"
SSH_CONFIG="$HOME/.ssh/config"
if [ ! -f "$SSH_CONFIG" ]; then
  printf "Include vms/*\n" > "$SSH_CONFIG"
elif ! grep -qE '^\s*Include\s+vms/\*' "$SSH_CONFIG"; then
  temp_file="$(mktemp)"
  printf "Include vms/*\n" > "$temp_file"
  cat "$SSH_CONFIG" >> "$temp_file"
  mv "$temp_file" "$SSH_CONFIG"
fi

echo "[setup-host] Done"
