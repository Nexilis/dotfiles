#!/usr/bin/env bash

echo "diff-so-fancy"
sudo rm -f /usr/local/bin/diff-so-fancy
rm -f $HOME/.local/bin/diff-so-fancy
wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O $HOME/Downloads/diff-so-fancy
chmod +x ~/Downloads/diff-so-fancy
mv ~/Downloads/diff-so-fancy ~/.local/bin

