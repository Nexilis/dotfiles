#!/usr/bin/env bash
# Loop (window manager) settings: keybinds, trigger key, radial menu, look.
#
# Loop keeps them in the com.MrKai77.Loop defaults domain. That plist is owned
# by cfprefsd, which rewrites it in place, so it cannot be symlinked like the
# config/* dirs. The repo holds a filtered copy instead, loop.plist, moved in
# and out with `defaults export` / `defaults import`.
#
# Usage: loop.sh [import|export] [--force]
#   import  (default) load loop.plist into the domain. Skips a machine that
#           already has Loop settings, so a rerun of the package group never
#           overwrites local changes; --force imports anyway.
#   export  write the live settings to loop.plist, minus volatile keys.
#
# Loop holds its settings in memory and writes them back at quit, so import
# quits it first and starts it after.
set -uo pipefail

DOMAIN=com.MrKai77.Loop
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
FILE="$SCRIPT_DIR/loop.plist"

# Per-machine state, not settings: a usage counter, the last accent colours
# (archived NSColor blobs), and the sync timestamps the Defaults library keeps
# next to every key.
VOLATILE_KEYS="timesLooped lastUsedAccentColor1 lastUsedAccentColor2"

export_settings() {
  local tmp
  tmp=$(mktemp)
  trap 'rm -f "$tmp"' RETURN
  if ! defaults export "$DOMAIN" "$tmp" 2>/dev/null; then
    echo "no $DOMAIN settings on this machine" >&2
    return 1
  fi
  plutil -convert xml1 "$tmp"
  local key
  for key in $VOLATILE_KEYS \
    $(grep -o '<key>[^<]*__DEFAULTS__synchronizeTimestamp</key>' "$tmp" | sed 's/<[^>]*>//g'); do
    plutil -remove "$key" "$tmp" 2>/dev/null || true
  done
  cp "$tmp" "$FILE"
  echo "exported $DOMAIN to $FILE"
}

import_settings() {
  local force=$1
  if [ ! -f "$FILE" ]; then
    echo "missing $FILE" >&2
    return 1
  fi
  if [ "$force" != 1 ] && defaults read "$DOMAIN" keybinds >/dev/null 2>&1; then
    echo "$DOMAIN already has settings; skipping (--force to import anyway)"
    return 0
  fi
  if pgrep -xq Loop; then
    osascript -e 'quit app "Loop"'
    while pgrep -xq Loop; do sleep 0.2; done
  fi
  defaults import "$DOMAIN" "$FILE"
  echo "imported $FILE into $DOMAIN"
  open -a Loop
}

MODE=import
FORCE=0
for a in "$@"; do
  case "$a" in
    import|export) MODE=$a ;;
    --force) FORCE=1 ;;
    *) echo "usage: loop.sh [import|export] [--force]" >&2; exit 2 ;;
  esac
done

if [ "$(uname -s)" != Darwin ]; then
  echo "loop.sh is macOS only" >&2
  exit 1
fi

case "$MODE" in
  export) export_settings ;;
  import) import_settings "$FORCE" ;;
esac
