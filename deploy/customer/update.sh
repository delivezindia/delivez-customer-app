#!/usr/bin/env bash
# Delivez customer app: install → build. nginx serves the new files immediately (no restart needed).
# Runs automatically after every `git pull` (post-merge hook), or by hand: ./deploy/customer/update.sh
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

STEP="start"
trap 'echo "✘ Update stopped at: $STEP. The site still shows the previous build — fix the error above, then run ./deploy/customer/update.sh again." >&2' ERR

if ! grep -q '^VITE_API_URL=.\+' .env 2>/dev/null; then
  echo "✘ Set VITE_API_URL in .env (e.g. VITE_API_URL=https://api.example.com) before building." >&2
  exit 1
fi
if [ "$(node -p 'process.versions.node.split(".")[0]')" -lt 20 ]; then
  echo "✘ Node.js 20 or newer is needed (this server has $(node -v))." >&2
  exit 1
fi

echo "▶ Delivez customer app: updating to $(git rev-parse --short HEAD) (node $(node -v), pnpm $(pnpm -v))"
STEP="install (pnpm install)"
pnpm install --frozen-lockfile
STEP="build (pnpm build)"
pnpm build
# The live site should now load this file (view-source on the site and compare).
MAIN=$(grep -oE 'assets/index-[A-Za-z0-9_-]+\.js' apps/local-web/dist/index.html | head -1)
echo "✔ Customer app built: apps/local-web/dist (main file $MAIN)"
