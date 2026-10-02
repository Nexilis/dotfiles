#!/usr/bin/env bash
# Wires the Claudette Vale style into Vale and Claude Code on this Mac.
#
# The style is not in this repo: it lives in the synced Claude folder next to
# claudette.md, and ~/.claude/claudette.md links there. This script finds the
# folder through that link and runs its install.sh, which links the Vale config
# and adds the Claude Code hook. Safe to rerun.
set -uo pipefail

for tool in vale jq; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "$tool not on PATH; run the brew steps of the work and cli-core groups first" >&2
    exit 1
  fi
done

if [ ! -L "$HOME/.claude/claudette.md" ]; then
  echo "~/.claude/claudette.md is not linked yet; link the synced Claude folder, then rerun" >&2
  exit 1
fi

src="$(cd "$(dirname "$(readlink "$HOME/.claude/claudette.md")")" && pwd -P)/vale"
if [ ! -x "$src/install.sh" ]; then
  echo "$src/install.sh not found; wait for Syncthing to finish, then rerun" >&2
  exit 1
fi

bash "$src/install.sh"
