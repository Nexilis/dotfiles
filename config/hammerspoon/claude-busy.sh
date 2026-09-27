#!/bin/sh
# Claude Code hook: marks a session as working so Hammerspoon keeps the Mac
# awake. Must print nothing; UserPromptSubmit output is added to the prompt.
# Usage: claude-busy.sh busy|idle   (hook JSON on stdin)

dir="$HOME/.cache/claude-busy"
sid=$(jq -r '.session_id // empty' 2>/dev/null)

case "$sid" in
    "" | *[!A-Za-z0-9-]*) exit 0 ;;
esac

case "$1" in
    busy) mkdir -p "$dir" && touch "$dir/$sid" ;;
    idle) rm -f "$dir/$sid" ;;
    # exit 2 would block the prompt in UserPromptSubmit
    *) echo "usage: claude-busy.sh busy|idle" >&2; exit 1 ;;
esac
exit 0
