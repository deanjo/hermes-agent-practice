#!/usr/bin/env bash
set -euo pipefail

REMOTE="${HERMES1_REMOTE:-cicada@192.168.88.33}"
DEPLOY_DIR="${HERMES1_DEPLOY_DIR:-/Users/cicada/hermes-docker/hermes-1}"
CONTAINER="${HERMES1_CONTAINER:-hermes-1}"

ssh -o BatchMode=yes -o ConnectTimeout=8 "$REMOTE" \
  "DEPLOY_DIR='$DEPLOY_DIR' CONTAINER='$CONTAINER' zsh -s" <<'REMOTE_SH'
set -euo pipefail
export PATH="/Applications/Docker.app/Contents/Resources/bin:/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

docker inspect "$CONTAINER" --format 'name={{.Name}} status={{.State.Status}} image={{.Config.Image}} image_id={{.Image}} started={{.State.StartedAt}} restart_count={{.RestartCount}}'
docker port "$CONTAINER" || true

if [ -d "$DEPLOY_DIR" ]; then
  printf 'deploy_dir=present path=%s\n' "$DEPLOY_DIR"
else
  printf 'deploy_dir=missing path=%s\n' "$DEPLOY_DIR"
fi
REMOTE_SH
