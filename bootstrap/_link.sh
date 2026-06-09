#!/usr/bin/env bash
# Symlink dotfiles into place. Idempotent and cross-platform (macOS + Linux).
#
# The repo is the source of truth. Live config points at the repo via symlinks,
# so editing a live file edits the repo file and changes are tracked directly.
#
# Maps:
#   config/<name>  ->  ~/.config/<name>
#   home/<name>    ->  ~/<name>
#
# Usage: _link.sh [--dry-run] [--force]
#   --dry-run  print what would happen, change nothing
#   --force    replace live dirs/files that differ from the repo
#
# Default is safe. It links targets that are absent or already identical to the
# repo and repoints stale symlinks. It SKIPS real dirs/files whose content
# differs from the repo, so machine-local state (fish_variables, plugins, app
# caches) and diverged config are never clobbered without --force. Replaced
# targets are backed up to <target>.bak.<timestamp>.

set -euo pipefail
shopt -s dotglob nullglob

DRY=0
FORCE=0
for a in "$@"; do
  case "$a" in
    --dry-run) DRY=1 ;;
    --force)   FORCE=1 ;;
    *) echo "unknown arg: $a" >&2; exit 2 ;;
  esac
done

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$SCRIPT_DIR/.." && pwd)
STAMP=$(date +%Y%m%d-%H%M%S)

# same_content SRC DST -> 0 if identical content (dir tree or file), else 1.
same_content() {
  local src=$1 dst=$2
  if [ -d "$src" ] && [ -d "$dst" ]; then
    diff -rq "$src" "$dst" >/dev/null 2>&1
  elif [ -f "$src" ] && [ -f "$dst" ]; then
    cmp -s "$src" "$dst"
  else
    return 1
  fi
}

# link_one SRC DST: create DST as a symlink to SRC, per the safety rules above.
link_one() {
  local src=$1 dst=$2

  if [ -L "$dst" ]; then
    if [ "$(readlink "$dst")" = "$src" ]; then
      echo "ok    $dst -> repo"
      return
    fi
    echo "fix   $dst (stale symlink -> $(readlink "$dst"))"
    [ "$DRY" = 1 ] || { rm "$dst"; ln -s "$src" "$dst"; }
    return
  fi

  if [ -e "$dst" ]; then
    if same_content "$src" "$dst"; then
      echo "link  $dst (identical to repo; backup + symlink)"
    elif [ "$FORCE" = 1 ]; then
      echo "force $dst (differs from repo; backup + symlink)"
    else
      echo "SKIP  $dst (differs from repo; reconcile then rerun, or --force)"
      return
    fi
    [ "$DRY" = 1 ] || { mv "$dst" "$dst.bak.$STAMP"; ln -s "$src" "$dst"; }
    return
  fi

  echo "link  $dst (absent; symlink)"
  [ "$DRY" = 1 ] || ln -s "$src" "$dst"
}

[ "$DRY" = 1 ] && echo "(dry-run; no changes)"
echo "repo: $REPO"

mkdir -p "$HOME/.config"
for src in "$REPO"/config/*/; do
  src=${src%/}
  link_one "$src" "$HOME/.config/$(basename "$src")"
done

for src in "$REPO"/home/*; do
  link_one "$src" "$HOME/$(basename "$src")"
done
