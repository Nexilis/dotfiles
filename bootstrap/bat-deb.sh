#!/usr/bin/env bash

echo "bat"
wget https://github.com/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb -O $HOME/Downloads/bat.deb
sudo dpkg -i $HOME/Downloads/bat.deb
rm -rf $HOME/Downloads/bat.deb
