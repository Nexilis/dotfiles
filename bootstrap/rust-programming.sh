#!/usr/bin/env bash

echo "rust"
wget https://sh.rustup.rs -O $HOME/Downloads/rustup-init.sh
chmod +x $HOME/Downloads/rustup-init.sh
~/Downloads/rustup-init.sh -q -y
rm -rf $HOME/Downloads/rustup-init.sh
