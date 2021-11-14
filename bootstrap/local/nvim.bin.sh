#!/usr/bin/env bash

wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz -O $HOME/Downloads/nvim.tar.gz
tar -vxzf $HOME/Downloads/nvim.tar.gz -C $HOME/Downloads
cp -vfr $HOME/Downloads/nvim-linux64/* $HOME/.local
chmod u+x $HOME/.local/bin/nvim
rm -vrf $HOME/Downloads/nvim*
