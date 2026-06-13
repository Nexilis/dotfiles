#!/usr/bin/env bash
# Give the macOS Neovide app an inset squircle icon.
#
# WHY THIS EXISTS
# ---------------
# Neovide ships its own app icon upstream: a cog that fills the canvas
# edge-to-edge on a transparent background. Next to native macOS apps (which use
# an inset rounded-rectangle "squircle" that fills only ~80% of the canvas with a
# margin and a plate) that icon looks oversized and plate-less in the Dock,
# Launchpad and Spotlight. Homebrew does not touch the icon, so neither the cask
# nor a formula install fixes this; it is purely neovide's upstream design. This
# script swaps in our own inset squircle icon (neovide.icns, next to this file).
#
# HISTORY: this started life linking the homebrew-core *formula* build of
# neovide into /Applications (the formula is CLI-only and buries Neovide.app in
# the Cellar). We have since moved to the homebrew-cask `neovide-app`, which
# installs the signed app to /Applications itself, so the linking is gone and
# only the icon override remains.
#
# WHY A "CUSTOM ICON" AND NOT OVERWRITING THE .icns
# -------------------------------------------------
# The cask app is signed with a hardened runtime. Overwriting
# Contents/Resources/Neovide.icns would break its code signature. Instead we set
# a macOS *custom icon* (an Icon resource + the FinderInfo bit, stored on the
# bundle as extended attributes) via NSWorkspace -setIcon:forFile:. That leaves
# the signed bundle contents untouched (`codesign --verify` still passes) and is
# the OS-blessed way to give any file a custom icon.
#
# RE-RUN after `brew upgrade --cask neovide-app`: the upgrade replaces the whole
# .app bundle, dropping the custom-icon attributes, so the icon must be re-set.
#
# Regenerating neovide.icns (only if the upstream logo changes). Source is the
# official colored logo, vendored here as neovide-256x256.png:
#   magick \( neovide-256x256.png -resize 760x760 -background white \
#       -gravity center -extent 1024x1024 \) \
#     \( -size 1024x1024 xc:black -fill white \
#        -draw "roundrectangle 100,100,924,924,185,185" -alpha off \) \
#     -compose CopyOpacity -composite -colorspace sRGB master_1024.png
#   mkdir neovide.iconset
#   for s in "16 16x16" "32 16x16@2x" "32 32x32" "64 32x32@2x" "128 128x128" \
#            "256 128x128@2x" "256 256x256" "512 256x256@2x" "512 512x512" \
#            "1024 512x512@2x"; do read px name <<<"$s"; \
#     magick master_1024.png -resize ${px}x${px} -colorspace sRGB \
#       "neovide.iconset/icon_${name}.png"; done
#   iconutil -c icns neovide.iconset -o neovide.icns
set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ICNS_SRC="$HERE/neovide.icns"
APP_PATH="/Applications/Neovide.app"

if [ ! -d "$APP_PATH" ]; then
  echo "Error: $APP_PATH not found (run 'brew install --cask neovide-app' first)" >&2
  exit 1
fi
if [ ! -f "$ICNS_SRC" ]; then
  echo "Error: $ICNS_SRC missing" >&2
  exit 1
fi

# Set the custom icon (signature-safe; does not modify the signed bundle).
result="$(osascript -l JavaScript - "$ICNS_SRC" "$APP_PATH" <<'JXA'
function run(argv) {
  ObjC.import('AppKit');
  var img = $.NSImage.alloc.initWithContentsOfFile(argv[0]);
  var ok = $.NSWorkspace.sharedWorkspace.setIconForFileOptions(img, argv[1], 0);
  return ok ? 'ok' : 'failed';
}
JXA
)"
if [ "$result" != "ok" ]; then
  echo "Error: failed to set custom icon on $APP_PATH" >&2
  exit 1
fi
echo "Set inset squircle icon on $APP_PATH"

# Nudge macOS to drop the cached icon.
touch "$APP_PATH"
killall Dock 2>/dev/null || true
echo "Done. If the Dock still shows the old icon, log out/in (the icon-services cache is stubborn)."
