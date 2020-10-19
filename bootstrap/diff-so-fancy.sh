#!/usr/bin/env bash

echo "diff-so-fancy"
sudo rm -rf /usr/local/bin/diff-so-fancy
wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -P $HOME/Downloads
sudo mv ~/Downloads/diff-so-fancy /usr/local/bin
sudo chmod +x /usr/local/bin/diff-so-fancy

