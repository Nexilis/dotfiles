#!/usr/bin/env bash
# Claude Code via the native installer, not Homebrew: the native install
# updates itself, the casks only update with `brew upgrade`.
set -uo pipefail

if command -v claude >/dev/null 2>&1 || [ -x "$HOME/.local/bin/claude" ]; then
  echo "claude already installed"
  exit 0
fi

curl -fsSL https://claude.ai/install.sh | bash
