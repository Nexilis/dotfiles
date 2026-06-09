#!/usr/bin/env bash
# Deploy configs as symlinks into this repo (replaces the old rm -rf + cp -r).
# All linking logic and safety rules live in _link.sh; this just calls it and
# keeps the one provisioning step the old copy-based version carried.
set -e

DIR=$(cd "$(dirname "$0")" && pwd)
bash "$DIR/_link.sh" "$@"

# nvim python support (kept from the old copy-based _config.sh)
command -v pip3 >/dev/null 2>&1 && pip3 install --user pynvim || true
