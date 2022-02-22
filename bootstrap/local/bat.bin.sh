#!/usr/bin/env bash

echo "bat"
wget https://github.com/sharkdp/bat/releases/download/v0.19.0/bat-v0.19.0-x86_64-unknown-linux-gnu.tar.gz -O $HOME/Downloads/bat.tar.gz
tar -vxzf $HOME/Downloads/bat.tar.gz -C $HOME/Downloads
mv -vf $HOME/Downloads/bat-v0.19.0-x86_64-unknown-linux-gnu/bat $HOME/.local/bin/bat
chmod u+x $HOME/.local/bin/bat
rm -vf $HOME/Downloads/bat.tar.gz
rm -vrf $HOME/Downloads/bat-v0.19.0-x86_64-unknown-linux-gnu
