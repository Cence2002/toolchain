#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/config.sh"

ROOT="${1:-$PROJECTS_ROOT}"

if [ ! -d "$ROOT" ]; then
  echo "[sync-projects] $ROOT not found" >&2
  exit 0
fi

echo "[sync-projects] Syncing projects in $ROOT"

for d in "$ROOT"/*; do
  if [ -d "$d/.git" ]; then
    echo "[sync] Updating $(basename "$d")/"
    git -C "$d" pull --ff-only || echo "[sync-projects] Sync failed"
  fi
done

echo "[sync-projects] Done"
