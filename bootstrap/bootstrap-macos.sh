#!/usr/bin/env bash
# macOS bootstrap. Two jobs only:
#   1. get Homebrew and `just` onto the machine (stage 0),
#   2. hand over to bootstrap/justfile, which drives the package groups.
#
# What to install is NOT decided here. The list lives in macos-packages.txt and
# the groups are picked at run time, so a fresh Mac needs nothing memorised:
#
#   sh bootstrap/bootstrap-macos.sh          # y/n per group, then link configs
#   sh bootstrap/bootstrap-macos.sh --all    # every group, no questions
#   sh bootstrap/bootstrap-macos.sh --skip-packages   # only link configs
#
# Everything is idempotent, so re-running is safe. Later, single groups can be
# run straight from the justfile: `cd bootstrap && just groups`, `just apps`.
set -uo pipefail

# Self-locating: derive the bootstrap dir so the repo can live anywhere.
BOOT="$(cd "$(dirname "$0")" && pwd)"

MODE=pick
DRY=()
LINK_ARGS=()
for a in "$@"; do
  case "$a" in
    --all)            MODE=all ;;
    --skip-packages)  MODE=none ;;
    # --dry-run means dry-run for BOTH halves: no package is installed and no
    # symlink is touched, so it has to reach the install step as well.
    --dry-run)        DRY=(--dry-run); LINK_ARGS+=("$a") ;;
    *)                LINK_ARGS+=("$a") ;;   # passed through to _link.sh
  esac
done

# --- Stage 0: Homebrew ------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Put brew on PATH for this shell (Apple Silicon location).
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# --- Stage 0: trusted third-party taps --------------------------------------
# Only consulted when HOMEBREW_REQUIRE_TAP_TRUST is set; needed to load formulae
# or casks from these non-official taps. Harmless otherwise.
for tap in lucaspickering/tap wedow/tools can1357/tap; do
  brew trust "$tap" 2>/dev/null || true
done

# --- Stage 0: just, the entry point for everything below --------------------
command -v just >/dev/null 2>&1 || brew install just

# --- Packages: groups picked at run time ------------------------------------
JUST=(just --justfile "$BOOT/justfile" --working-directory "$BOOT")
case "$MODE" in
  pick) "${JUST[@]}" pick ${DRY[@]+"${DRY[@]}"} ;;
  all)  "${JUST[@]}" all ${DRY[@]+"${DRY[@]}"} ;;
  none) echo "skipping packages" ;;
esac

# --- Symlink configs --------------------------------------------------------
bash "$BOOT/_link.sh" "${LINK_ARGS[@]+"${LINK_ARGS[@]}"}"

# --- Post-install hints (manual, not automated) -----------------------------
if command -v fish >/dev/null 2>&1 && [ "$SHELL" != "$(command -v fish)" ]; then
  echo "fish: chsh -s $(command -v fish)   # set login shell"
  echo "fish: set -U fish_user_paths /opt/homebrew/bin/ \$fish_user_paths"
fi
command -v rtk >/dev/null 2>&1 && echo "rtk: run once -> rtk init -g"
echo "Done. See the private apple-macbook.md notes for licenses, keys, and one-off app tweaks."
