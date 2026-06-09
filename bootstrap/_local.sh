#!/usr/bin/env bash

# Self-locating: derive the bootstrap dir from this script's path so the repo
# can live anywhere (no hardcoded clone path).
BOOT="$(cd "$(dirname "$0")" && pwd)"

mkdir -vp $HOME/.local/bin
sh "$BOOT/local/bat.bin.sh"
sh "$BOOT/local/btop.bin.sh"
sh "$BOOT/local/diff-so-fancy.bin.sh"
sh "$BOOT/local/doublecmd.bin.sh"
sh "$BOOT/local/exa.bin.sh"
sh "$BOOT/local/fd-find.bin.sh"
sh "$BOOT/local/fzf.bin.sh"
sh "$BOOT/local/gocryptfs.bin.sh"
sh "$BOOT/local/jetbrains-toolbox.bin.sh"
sh "$BOOT/local/jdk.bin.sh"
sh "$BOOT/local/lazygit.bin.sh"
sh "$BOOT/local/neovide.bin.sh"
sh "$BOOT/local/nvim.bin.sh"
sh "$BOOT/local/ripgrep.bin.sh"
sh "$BOOT/local/rust.bin.sh"
sh "$BOOT/local/starship.bin.sh"
cargo install exa
