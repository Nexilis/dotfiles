#!/usr/bin/env bash
# Keeps one marker file per running sub-agent in
# ~/.cache/claude-subagents/<session>, which statusline.sh counts. Wired as
# Claude Code hooks: SubagentStart runs `start`, SubagentStop `stop`,
# SessionEnd `end`.
set -uo pipefail

input="$(cat)"
session="$(jq -r '.session_id // empty' <<<"$input")"
agent="$(jq -r '.agent_id // empty' <<<"$input")"

# The ids become path parts.
valid='^[A-Za-z0-9_-]+$'
[[ $session =~ $valid ]] || exit 0
dir="$HOME/.cache/claude-subagents/$session"

case "${1:-}" in
  start) [[ $agent =~ $valid ]] && mkdir -p "$dir" && touch "$dir/$agent" ;;
  stop)  [[ $agent =~ $valid ]] && rm -f "$dir/$agent" ;;
  end)   rm -rf "$dir" ;;
esac
exit 0
