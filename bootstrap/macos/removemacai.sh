#!/usr/bin/env bash
# Applies the RemoveMacAI recommended preset plus a few window and Dock tweaks
# without asking. dock-apple-apps is left out: what it removes depends on the
# Mac's usage. The locked settings
# go into a configuration profile, so macOS shows a dialog to approve it in
# System Settings. Undo with `removemacai revert`.
set -uo pipefail

if ! command -v removemacai >/dev/null 2>&1; then
  echo "removemacai not installed" >&2
  exit 1
fi

removemacai apply --preset recommended --yes \
  click-to-desktop dock-recents minimize-to-app tile-margins desktop-widgets </dev/null
