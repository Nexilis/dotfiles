#!/usr/bin/env bash

echo "nnn"
wget https://github.com/jarun/nnn/releases/download/v3.1/nnn-static-3.1.x86-64.tar.gz -O $HOME/Downloads/nnn.tar.gz
tar -xvzf $HOME/Downloads/nnn.tar.gz nnn-static
sudo mv nnn-static /usr/local/bin/nnn
rm -rf ~/Downloads/nnn.tar.gz
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh

