#!/usr/bin/env bash
# claude-powerline, the Claude Code statusline, as a global npm package pinned
# to a release at least 7 days old. Global, not npx: npx would resolve the
# package on every statusline refresh. Its config and the wrapper that
# settings.json calls live in config/claude-powerline.
set -uo pipefail

VERSION=1.32.1
PKG=@owloops/claude-powerline

if ! command -v npm >/dev/null 2>&1; then
  echo "npm not on PATH; node is in the langs group" >&2
  exit 1
fi

current="$(npm ls -g "$PKG" --json 2>/dev/null | jq -r --arg p "$PKG" '.dependencies[$p].version // empty')"
if [ "$current" = "$VERSION" ]; then
  echo "$PKG $VERSION already installed"
  exit 0
fi

npm install -g "$PKG@$VERSION"
