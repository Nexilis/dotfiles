#!/usr/bin/env bash
# Links the synced Claude folder (~/Documents/sync/.claude, carried by
# Syncthing) into ~/.claude. Only named entries are linked: ~/.claude itself
# holds per-machine session state. Safe to rerun; never replaces a real file.
#
# Usage: claude-sync-links.sh [--dry-run]
set -uo pipefail

DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

SRC="$HOME/Documents/sync/.claude"
DST="$HOME/.claude"
ENTRIES="CLAUDE.md claudette.md codette.md claudette-hook.md RTK.md settings.json vale agents commands mods"

if [ ! -d "$SRC" ]; then
  echo "$SRC not found; wait for Syncthing to finish, then rerun" >&2
  exit 1
fi

mkdir -p "$DST"
status=0
for name in $ENTRIES; do
  src="$SRC/$name" dst="$DST/$name"
  if [ ! -e "$src" ]; then
    echo "MISS  $src (not synced yet)"; status=1; continue
  fi
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok    $dst"; continue
  fi
  if [ -L "$dst" ]; then
    echo "fix   $dst (stale symlink -> $(readlink "$dst"))"
    [ "$DRY" = 1 ] || { rm "$dst"; ln -s "$src" "$dst"; }
    continue
  fi
  if [ -e "$dst" ]; then
    echo "SKIP  $dst (real file or dir; move it aside, then rerun)"; status=1; continue
  fi
  echo "link  $dst"
  [ "$DRY" = 1 ] || ln -s "$src" "$dst"
done
exit $status
