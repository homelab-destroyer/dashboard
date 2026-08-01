#!/usr/bin/env bash
set -euo pipefail

# El sitio se sirve desde homelab-node1. homelab-node2 es el kiosco táctil,
# por eso Chromium se reinicia al final para cargar la versión recién publicada.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEB_NODE="homelab-node1"
KIOSK_NODE="homelab-node2"
WEB_ROOT="/var/www/dashboard"

node --check "$ROOT_DIR/assets/dashboard.js"

STAGING_DIR="$(ssh "$WEB_NODE" 'mktemp -d /tmp/dashboard-release.XXXXXX')"
cleanup() { ssh "$WEB_NODE" "rm -rf '$STAGING_DIR'" >/dev/null 2>&1 || true; }
trap cleanup EXIT
ssh "$WEB_NODE" "mkdir -p '$STAGING_DIR/assets'"
rsync -az "$ROOT_DIR/index.html" "$WEB_NODE:$STAGING_DIR/"
rsync -az --delete "$ROOT_DIR/assets/" "$WEB_NODE:$STAGING_DIR/assets/"

ssh "$WEB_NODE" "sudo install -d -m 0755 '$WEB_ROOT' && sudo rsync -a --delete '$STAGING_DIR/' '$WEB_ROOT/' && sudo find '$WEB_ROOT' -type d -exec chmod 0755 {} \\; && sudo find '$WEB_ROOT' -type f -exec chmod 0644 {} \\;"
ssh "$KIOSK_NODE" 'pkill -x chromium 2>/dev/null || true'

printf 'Dashboard publicado en %s y kiosco de %s recargado.\n' "$WEB_NODE" "$KIOSK_NODE"
