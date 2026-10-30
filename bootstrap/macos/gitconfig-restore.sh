#!/usr/bin/env bash
# The Git Credential Manager installer runs `git-credential-manager configure`,
# which moves the generic [credential] block below the github.com ones, so git
# uses GCM instead of gh for GitHub. When ~/.gitconfig differs from the repo only
# by line order, put the repo version back. Any other change is left alone.
set -uo pipefail

REPO=$(cd "$(dirname "$0")/../.." && pwd)
FILE=home/.gitconfig

git -C "$REPO" diff --quiet -- "$FILE" && exit 0

normalized() { sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | sort; }

if [ "$(git -C "$REPO" show "HEAD:$FILE" | normalized)" = "$(normalized <"$REPO/$FILE")" ]; then
  git -C "$REPO" checkout -- "$FILE"
  echo "~/.gitconfig: section order restored (GCM had moved its block)"
else
  echo "~/.gitconfig differs from dotfiles beyond order; see: git -C $REPO diff $FILE" >&2
fi
