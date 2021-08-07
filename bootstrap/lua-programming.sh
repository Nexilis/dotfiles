#!/usr/bin/env bash

echo "lua 5.3 - latest compatible with Ubuntu 20.04"
sudo apt update
sudo apt install lua5.3 -y

echo "fennel"
wget https://fennel-lang.org/downloads/fennel-0.9.2-x86_64 -O $HOME/Downloads/fennel
chmod +x $HOME/Downloads/fennel
sudo rm -rf /usr/local/bin/fennel
sudo mv $HOME/Downloads/fennel /usr/local/bin/fennel
