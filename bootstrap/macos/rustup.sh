#!/usr/bin/env bash
# Rust toolchain via rustup, not Homebrew: rustup owns toolchain switching and
# component installs, which the brew formula cannot do.
set -uo pipefail

if command -v rustup >/dev/null 2>&1; then
  echo "rustup already installed"
  exit 0
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
