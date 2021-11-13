#!/usr/bin/env bash

echo "bat"
wget https://github.com/sharkdp/bat/releases/download/v0.18.3/bat-v0.18.3-x86_64-unknown-linux-gnu.tar.gz -O $HOME/Downloads/bat.tar.gz
tar xvzf $HOME/Downloads/bat.tar.gz -C $HOME/Downloads
mv -f $HOME/Downloads/bat-v0.18.3-x86_64-unknown-linux-gnu/bat $HOME/.local/bin/bat
chmod u+x $HOME/.local/bin/bat
rm -f $HOME/Downloads/bat.tar.gz
rm -rf $HOME/Downloads/bat-v0.18.3-x86_64-unknown-linux-gnu
