#!/usr/bin/env bash

echo "rust"
wget https://sh.rustup.rs -O $HOME/Downloads/rustup-init.sh
chmod +x $HOME/Downloads/rustup-init.sh
~/Downloads/rustup-init.sh -q -y
rm -rf $HOME/Downloads/rustup-init.sh

echo "rust-analyzer - LSP for rust used in neovim"
wget https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz -O $HOME/Downloads/rust-analyzer.gz
gunzip $HOME/Downloads/rust-analyzer.gz
chmod +x $HOME/Downloads/rust-analyzer
sudo rm -rf /usr/local/bin/rust-analyzer
sudo mv $HOME/Downloads/rust-analyzer /usr/local/bin/rust-analyzer

