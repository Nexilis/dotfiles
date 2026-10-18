#!/usr/bin/env bash
# Copilot comes with the work account, so Neovim loads copilot.lua only where
# this marker exists, and only the work group creates it.
set -uo pipefail

MARKER="$HOME/.local/share/nvim/copilot"

mkdir -p "$(dirname "$MARKER")"
touch "$MARKER"
echo "Copilot enabled in Neovim ($MARKER)"
