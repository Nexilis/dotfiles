#!/usr/bin/env bash

echo "ripgrep"
wget https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/ripgrep_12.1.1_amd64.deb
rm -rf $HOME/Downloads/ripgrep_12.1.1_amd64.deb

