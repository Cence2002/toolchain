#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/config.sh"

echo "[setup-host] Installing base packages"
sudo apt-get update -qq
sudo apt-get install -y -qq git curl apt-transport-https ca-certificates gnupg

echo "[setup-host] Installing Docker"
if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sudo sh /tmp/get-docker.sh
  rm -f /tmp/get-docker.sh
fi

if ! command -v gcloud &> /dev/null; then
  echo "[setup-host] Installing Google Cloud"
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  sudo apt-get update -qq
  sudo apt-get install -y -qq google-cloud-cli
  echo "[setup-host] Setting up gcloud"
  gcloud auth login --no-launch-browser || true
  gcloud config set project "$GCP_PROJECT" || true
fi

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

SSH_KEY_PRIVATE="${SSH_KEY_PATH%.pub}"
if [ ! -f "$SSH_KEY_PRIVATE" ]; then
  echo "[setup-host] Setting up SSH key"
  ssh-keygen -t ed25519 -f "$SSH_KEY_PRIVATE" -N "" -C "$USER@$(hostname)"
fi

echo "[setup-host] Setting up git"
if ! git config --global user.name &> /dev/null; then
  git config --global user.name "$USER"
fi
if ! git config --global user.email &> /dev/null; then
  git config --global user.email "$EMAIL"
fi

echo "[setup-host] Done"
