#!/usr/bin/env bash
# Installs every plugin that ~/.claude/settings.json enables. settings.json is
# synced between Macs; the install state under ~/.claude/plugins is not, because
# it holds per-machine cache paths. Safe to rerun.
set -uo pipefail

SETTINGS="$HOME/.claude/settings.json"
CLAUDE="$(command -v claude || echo "$HOME/.local/bin/claude")"

if [ ! -x "$CLAUDE" ]; then
  echo "claude not found; run claude-code.sh first" >&2
  exit 1
fi
if [ ! -f "$SETTINGS" ]; then
  echo "$SETTINGS not found; run claude-sync-links.sh first" >&2
  exit 1
fi

installed="$("$CLAUDE" plugin list --json | jq -r '.[].id')"
status=0
for id in $(jq -r '.enabledPlugins // {} | to_entries[] | select(.value) | .key' "$SETTINGS"); do
  if grep -qxF "$id" <<<"$installed"; then
    echo "ok    $id"
    continue
  fi
  echo "add   $id"
  "$CLAUDE" plugin install "$id" || status=1
done
exit $status
