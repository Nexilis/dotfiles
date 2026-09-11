#!/usr/bin/env bash
# ImageGlass, the image viewer. Not in Homebrew as of September 2026: the macOS
# build is new (10.0.4, August 2026), so install from the GitHub release dmg.
# The dmg is notarized (Developer ID), which is the reason it won over qView
# (cask disabled 2026-09-01, fails Gatekeeper) and nomacs (ad-hoc signature,
# Gatekeeper rejects it on macOS 26).
#
# Idempotent: skips when /Applications/ImageGlass.app already exists. Pass
# --force to reinstall the latest release over it.
set -uo pipefail

APP=/Applications/ImageGlass.app
REPO=d2phap/ImageGlass

if [ -d "$APP" ] && [ "${1:-}" != "--force" ]; then
  echo "ImageGlass already installed: $APP"
  exit 0
fi

URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
  | grep -o 'https://[^"]*_mac-arm64\.dmg' | head -1)
if [ -z "$URL" ]; then
  echo "no mac-arm64 dmg in the latest $REPO release" >&2
  exit 1
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
if ! curl -fsSL --retry 3 -o "$TMP/ImageGlass.dmg" "$URL"; then
  echo "download failed: $URL" >&2
  exit 1
fi
MOUNT=$(hdiutil attach -nobrowse -readonly "$TMP/ImageGlass.dmg" | awk -F'\t' '/\/Volumes\//{print $NF}')
if [ -z "$MOUNT" ]; then
  echo "could not mount $TMP/ImageGlass.dmg" >&2
  exit 1
fi

if ! spctl -a "$MOUNT/ImageGlass.app" 2>/dev/null; then
  echo "Gatekeeper rejects $URL; not installing" >&2
  hdiutil detach "$MOUNT" -quiet
  exit 1
fi

rm -rf "$APP"
cp -R "$MOUNT/ImageGlass.app" /Applications/
hdiutil detach "$MOUNT" -quiet
echo "installed ImageGlass from $URL"
