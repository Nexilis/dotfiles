#!/usr/bin/env bash
# macOS system settings written with `defaults`. Idempotent: every write sets
# the same value again.
set -uo pipefail

if [ "$(uname -s)" != Darwin ]; then
  echo "defaults.sh is macOS only" >&2
  exit 1
fi

# Hidden files: always visible in Finder and in Open/Save dialogs. Finder picks
# its own key up on restart; other apps read the global key only at launch, so
# they need a logout or restart.
defaults write -g AppleShowAllFiles -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true

# Not running is fine; launchd starts Finder again on its own.
killall Finder 2>/dev/null || true
