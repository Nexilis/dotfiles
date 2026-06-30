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

# --- Trusted third-party taps -----------------------------------------------
# Only consulted when HOMEBREW_REQUIRE_TAP_TRUST is set; needed to load formulae
# or casks from these non-official taps (e.g. slumber below). Harmless otherwise.
brew trust lucaspickering/tap
brew trust wedow/tools
brew trust jurplel/tap

# --- Homebrew packages ------------------------------------------------------
# Core CLI
brew install wget curl fish fzf fd ripgrep btop lazygit starship eza bat gh

# yazi file manager + previewers
brew install yazi ffmpeg sevenzip jq poppler zoxide resvg imagemagick font-symbols-only-nerd-font

# slumber REST client (tap)
brew install LucasPickering/homebrew-tap/slumber

# GUI utilities
brew install linearmouse karabiner-elements kitty telegram gimp libreoffice shottr skim qview syncthing

# Programming
brew install zed nvim lua luarocks stylua lua-language-server node git-credential-manager cmake just
# Neovide GUI: use the cask (homebrew-cask), not the homebrew-core formula. The
# formula builds a CLI-only bottle and leaves Neovide.app buried in the Cellar
# (never placed in /Applications). The cask installs the official signed app to
# /Applications AND links the `neovide` binary onto PATH, so we get both.
brew install --cask neovide-app
# Neovide ships a full-bleed upstream icon that looks oversized and plate-less
# next to native macOS apps in the Dock/cmd+tab. Swap in our inset squircle
# icon (signature-safe custom-icon attributes, not a bundle overwrite). Cosmetic,
# so never fatal. NOTE: a later `brew upgrade --cask neovide-app` replaces the
# bundle and drops the icon; re-run bootstrap/macos/neovide-app.sh to reapply.
bash "$BOOT/macos/neovide-app.sh" || true
# Optional: Java, Clojure, Go
brew install temurin leiningen go

# Browsers / media
brew install brave-browser spotify

# Nerd fonts
brew install font-hack-nerd-font font-fira-code-nerd-font font-jetbrains-mono-nerd-font

# Extras / tryout
brew install cmus mole obs shotcut freetube qpdf vienna googleworkspace-cli rtk
brew install --cask hammerspoon mouseless@preview
# FreeTube is unsigned; clear the quarantine flag so it opens.
[ -d /Applications/FreeTube.app ] && xattr -d com.apple.quarantine /Applications/FreeTube.app 2>/dev/null

# Rejected (tried, removed; do NOT reinstall):
#   shortcat (cask): does not work with kitty (e.g. terminal apps)
#   aerospace (nikitabobko/tap cask): tiling WM, not used

# --- Non-Homebrew installs --------------------------------------------------
# Rust (rustup)
command -v rustup >/dev/null 2>&1 || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# GitHub Copilot CLI
command -v copilot >/dev/null 2>&1 || npm install -g @github/copilot

# Antigravity CLI (Google) — tryout. Installs the `agy` binary into ~/.local/bin
# (already on PATH via config.fish), so no extra PATH setup is needed.
command -v agy >/dev/null 2>&1 || curl -fsSL https://antigravity.google/cli/install.sh | bash

# Work-secret encryption: gocryptfs (transparent on-demand mount; `dec`/`unmount`
# fish aliases). Needs FUSE -> macFUSE on macOS, a kernel extension that requires
# one-time reduced security on Apple Silicon. See AGENTS.md "Work secrets".
brew install --cask macfuse
# gocryptfs is not in Homebrew on macOS (Linux-only formula) and we no longer use
# MacPorts. Build it from source with Go (the pure-Go without_openssl build needs
# no C headers) into ~/.local/bin, which sits ahead of the rest on PATH.
command -v gocryptfs >/dev/null 2>&1 || \
  GOBIN="$HOME/.local/bin" go install -tags without_openssl github.com/rfjakob/gocryptfs/v2@v2.6.1

# --- Symlink configs --------------------------------------------------------
bash "$BOOT/_link.sh" "$@"

# --- Post-install hints (manual, not automated) -----------------------------
if command -v fish >/dev/null 2>&1 && [ "$SHELL" != "$(command -v fish)" ]; then
  echo "fish: chsh -s $(command -v fish)   # set login shell"
  echo "fish: set -U fish_user_paths /opt/homebrew/bin/ \$fish_user_paths"
fi
echo "rtk: run once -> rtk init -g"
echo "Done. See the private apple-macbook.md notes for licenses, keys, and one-off app tweaks."
