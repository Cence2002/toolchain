#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "[delete-vm] Usage: $0 <vm>" >&2
  exit 1
fi

NAME="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/config.sh"

echo "[delete-vm] Deleting '$NAME'"
gcloud compute instances delete "$NAME" \
  --project="$GCP_PROJECT" \
  --zone="$GCP_ZONE" \
  --quiet

CONFIG_FILE="$HOME/.ssh/vms/$NAME"
if [ -f "$CONFIG_FILE" ]; then
  echo "[delete-vm] Removing $CONFIG_FILE"
  rm -f "$CONFIG_FILE"
fi

echo "[delete-vm] Done"
