#!/usr/bin/env bash
# Claude Code statusline: claude-powerline with the rate limit countdowns
# swapped for clock times, 14:53 for the 5-hour window and Fri 14:53 for the
# 7-day one. Powerline has no option for this; its countdown format is fixed.
set -uo pipefail

input="$(cat)"

# Running sub-agents, from the markers subagents.sh keeps; the env segment hides
# itself when the value is empty. A sub-agent killed without SubagentStop leaves
# a marker behind, so markers older than 2 hours are ignored.
session="$(jq -r '.session_id // empty' <<<"$input")"
agents=0
if [ -n "$session" ] && [ -d "$HOME/.cache/claude-subagents/$session" ]; then
  agents="$(find "$HOME/.cache/claude-subagents/$session" -type f -mmin -120 | wc -l | tr -d ' ')"
fi
[ "$agents" -gt 0 ] && export CLAUDE_SUBAGENTS="$agents"

line="$(claude-powerline --style=powerline <<<"$input")"

clock() { [ -n "$1" ] && date -r "$1" "$2"; }
five="$(clock "$(jq -r '.rate_limits.five_hour.resets_at // empty' <<<"$input")" +%H:%M)"
week="$(clock "$(jq -r '.rate_limits.seven_day.resets_at // empty' <<<"$input")" '+%a %H:%M')"

# Countdowns appear in segment order, 5-hour first, so each time replaces the
# leftmost one still left.
times=()
[ -n "$five" ] && times+=("$five")
[ -n "$week" ] && times+=("$week")
re='\(([0-9]+[dhm]( [0-9]+[hm])?)\)'
for t in ${times[@]+"${times[@]}"}; do
  [[ $line =~ $re ]] || break
  line="${line/"${BASH_REMATCH[0]}"/($t)}"
done
printf '%s\n' "$line"
