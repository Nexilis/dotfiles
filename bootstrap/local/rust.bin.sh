#!/usr/bin/env bash

echo "rust"
wget https://sh.rustup.rs -O $HOME/Downloads/rustup-init.sh
sh $HOME/Downloads/rustup-init.sh -q -y
rm -vf $HOME/Downloads/rustup-init.sh

echo "rust-analyzer - LSP for rust used in neovim"
wget https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz -O $HOME/Downloads/rust-analyzer.gz
gunzip -vfr $HOME/Downloads/rust-analyzer.gz
chmod u+x $HOME/Downloads/rust-analyzer
mv -vf $HOME/Downloads/rust-analyzer $HOME/.local/bin/rust-analyzer
