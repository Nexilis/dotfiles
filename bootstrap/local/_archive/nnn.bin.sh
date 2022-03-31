#!/usr/bin/env bash

wget https://github.com/jarun/nnn/releases/download/v4.4/nnn-static-4.4.x86_64.tar.gz -O $HOME/Downloads/nnn.tar.gz
tar -vxzf $HOME/Downloads/nnn.tar.gz -C $HOME/Downloads
mv -vf $HOME/Downloads/nnn-static $HOME/.local/bin/nnn
chmod u+x $HOME/.local/bin/nnn
rm -vf $HOME/Downloads/nnn.tar.gz
