#!/usr/bin/env bash

wget https://github.com/jarun/nnn/releases/download/v4.3/nnn-static-4.3.x86_64.tar.gz -O $HOME/Downloads/nnn.tar.gz
tar xvzf $HOME/Downloads/nnn.tar.gz -C $HOME/Downloads
rm -f $HOME/.local/bin/nnn
mv $HOME/Downloads/nnn-static $HOME/.local/bin/nnn
chmod +x $HOME/.local/bin/nnn
rm -f $HOME/Downloads/nnn.tar.gz
