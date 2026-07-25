#!/usr/bin/env bash
# gocryptfs for the work-secrets vault (`dec` / `unmount` fish aliases).
#
# Not in Homebrew on macOS (the formula is Linux-only) and we no longer use
# MacPorts, so build it from source with Go. The pure-Go without_openssl build
# needs no C headers. Installs into ~/.local/bin, which sits ahead of the rest
# on PATH.
#
# Needs FUSE, i.e. the macfuse cask, which is a kernel extension and requires
# one-time reduced security on Apple Silicon. See AGENTS.md "Work secrets".
set -uo pipefail

VERSION=v2.6.1

if command -v gocryptfs >/dev/null 2>&1; then
  echo "gocryptfs already installed: $(command -v gocryptfs)"
  exit 0
fi

if ! command -v go >/dev/null 2>&1; then
  echo "go not on PATH; install the 'langs' group first" >&2
  exit 1
fi

GOBIN="$HOME/.local/bin" go install -tags without_openssl \
  "github.com/rfjakob/gocryptfs/v2@$VERSION"
