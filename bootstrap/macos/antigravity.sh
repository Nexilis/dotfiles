#!/usr/bin/env bash
# Antigravity CLI (Google) — tryout. Extracted verbatim from the old inline step
# in bootstrap-macos.sh. Installs the `agy` binary into ~/.local/bin, which
# config/fish/config.fish already puts on PATH, so no extra setup is needed.
set -uo pipefail

if command -v agy >/dev/null 2>&1; then
  echo "agy already installed"
  exit 0
fi

INSTALLER_URL="https://antigravity.google/cli/install.sh"
curl -fsSL "$INSTALLER_URL" | bash
