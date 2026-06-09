#!/usr/bin/env bash
# macOS bootstrap: install Homebrew and packages, then symlink configs.
#
# Config linking (_link.sh) already works on macOS; this adds the package side.
# Packages are installed from a Brewfile via `brew bundle` if one is present, so
# this script invents no package list of its own.
set -euo pipefail

# Self-locating: derive the bootstrap dir so the repo can live anywhere.
BOOT="$(cd "$(dirname "$0")" && pwd)"

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Put brew on PATH for this shell (Apple Silicon location).
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Packages: install from a Brewfile if one exists next to this script.
if [ -f "$BOOT/Brewfile" ]; then
  echo "Installing packages from Brewfile..."
  brew bundle --file="$BOOT/Brewfile"
else
  echo "No Brewfile at $BOOT/Brewfile; skipping package install."
  echo "Generate one from this machine with: brew bundle dump --file=\"$BOOT/Brewfile\""
fi

# Symlink configs into ~/.config and ~ (idempotent; backs up replaced files).
bash "$BOOT/_link.sh" "$@"

# fish login shell hint (no automatic chsh).
if command -v fish >/dev/null 2>&1 && [ "$SHELL" != "$(command -v fish)" ]; then
  echo "To use fish as your login shell: chsh -s $(command -v fish)"
fi
