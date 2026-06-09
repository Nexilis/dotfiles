#!/usr/bin/env bash
# macOS bootstrap: install Homebrew + packages, then symlink configs.
#
# This is the source of truth for what to install on a fresh Mac (migrated from
# the private apple-macbook.md notes). Config linking lives in _link.sh.
# brew is idempotent, so this is safe to re-run.
set -uo pipefail

# Self-locating: derive the bootstrap dir so the repo can live anywhere.
BOOT="$(cd "$(dirname "$0")" && pwd)"

# --- Homebrew ---------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Put brew on PATH for this shell (Apple Silicon location).
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# --- Homebrew packages ------------------------------------------------------
# Core CLI
brew install wget curl fish fzf fd ripgrep btop lazygit starship eza bat gh

# yazi file manager + previewers
brew install yazi ffmpeg sevenzip jq poppler zoxide resvg imagemagick font-symbols-only-nerd-font

# slumber REST client (tap)
brew install LucasPickering/homebrew-tap/slumber

# GUI utilities
brew install alt-tab linearmouse karabiner-elements kitty telegram gimp libreoffice shottr skim qview syncthing

# Programming
brew install zed nvim neovide lua luarocks stylua lua-language-server node git-credential-manager cmake just
# Optional: Java, Clojure, Go
brew install temurin leiningen go

# Browsers / media
brew install brave-browser spotify

# Nerd fonts
brew install font-hack-nerd-font font-fira-code-nerd-font font-jetbrains-mono-nerd-font

# Extras / tryout
brew install cmus mole obs shotcut freetube qpdf vienna googleworkspace-cli rtk
brew install --cask shortcat hammerspoon
# FreeTube is unsigned; clear the quarantine flag so it opens.
[ -d /Applications/FreeTube.app ] && xattr -d com.apple.quarantine /Applications/FreeTube.app 2>/dev/null

# --- Non-Homebrew installs --------------------------------------------------
# Rust (rustup)
command -v rustup >/dev/null 2>&1 || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# GitHub Copilot CLI
command -v copilot >/dev/null 2>&1 || npm install -g @github/copilot

# gocryptfs is not in Homebrew on macOS; install via MacPorts if available.
if command -v port >/dev/null 2>&1; then
  sudo port install gocryptfs
else
  echo "MacPorts not found. Install it (https://guide.macports.org), then: sudo port install gocryptfs"
fi

# --- Symlink configs --------------------------------------------------------
bash "$BOOT/_link.sh" "$@"

# --- Post-install hints (manual, not automated) -----------------------------
if command -v fish >/dev/null 2>&1 && [ "$SHELL" != "$(command -v fish)" ]; then
  echo "fish: chsh -s $(command -v fish)   # set login shell"
  echo "fish: set -U fish_user_paths /opt/homebrew/bin/ \$fish_user_paths"
fi
echo "rtk: run once -> rtk init -g"
echo "Done. See the private apple-macbook.md notes for licenses, keys, and one-off app tweaks."
