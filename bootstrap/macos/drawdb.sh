#!/usr/bin/env bash
# drawDB (database diagram editor) as a macOS app. A tagged release is patched
# to hash routing (Pake serves local files without a history-mode fallback),
# built with node and packed by Pake into /Applications/drawDB.app.
# VERSION is a release at least 7 days old; EXPECTED is the commit its tag
# pointed to when it was picked, so a moved tag is refused. PAKE_BEFORE keeps
# npm on releases older than the cooldown when it resolves Pake's dependencies.
set -euo pipefail

VERSION=v1.9.0
EXPECTED=a249c7fb730c2de9b5c2ce6e863f2ea7344ac372
PAKE_VERSION=3.18.0
PAKE_BEFORE=2026-11-11
DIR="${XDG_DATA_HOME:-$HOME/.local/share}/drawdb"
APP=/Applications/drawDB.app
PATCH="$(cd "$(dirname "$0")" && pwd)/drawdb-hash-router.patch"
STAMP="$VERSION pake $PAKE_VERSION $(shasum -a 256 "$PATCH" | cut -d' ' -f1)"

if [ $# -ne 0 ]; then
  echo "usage: drawdb.sh (no arguments)" >&2
  exit 2
fi

for tool in git npm cargo; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "$tool not on PATH; node, rustup and git are in the langs and git groups" >&2
    exit 1
  fi
done

if [ -d "$APP" ] && [ "$(cat "$DIR/.installed" 2>/dev/null)" = "$STAMP" ]; then
  echo "drawDB $VERSION already installed in $APP"
  exit 0
fi

if [ -d "$DIR/.git" ]; then
  git -C "$DIR" fetch --depth 1 origin tag "$VERSION"
  git -C "$DIR" checkout --quiet --force "$VERSION"
else
  git clone --quiet --depth 1 --branch "$VERSION" https://github.com/drawdb-io/drawdb.git "$DIR"
fi

if [ "$(git -C "$DIR" rev-parse HEAD)" != "$EXPECTED" ]; then
  echo "tag $VERSION does not point to $EXPECTED; not building" >&2
  exit 1
fi

git -C "$DIR" apply "$PATCH"

# HUSKY=0 stops the project's prepare script from setting git hooks in the clone.
cd "$DIR"
HUSKY=0 npm ci --no-audit --no-fund
npm run build
npx --yes --before="$PAKE_BEFORE" "pake-cli@$PAKE_VERSION" ./dist --name drawDB \
  --icon src/assets/icon-dark.png --width 1440 --height 900 --targets app --install
echo "$STAMP" > "$DIR/.installed"
echo "drawDB $VERSION installed in $APP"
