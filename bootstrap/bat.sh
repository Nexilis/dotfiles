#!/usr/bin/env bash

echo "bat"
wget https://github.com/sharkdp/bat/releases/download/v0.16.0/bat_0.16.0_amd64.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/bat_0.16.0_amd64.deb
rm -rf $HOME/Downloads/bat_0.16.0_amd64.deb
