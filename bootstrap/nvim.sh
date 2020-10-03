#!/usr/bin/env bash

echo "neovim"
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim

echo "config neovim"
cp -f -r ../.config/nvim ~/.config/nvim
rm -f ~/.config/nvim/init.vim
ln -s ~/proj/dotfiles/.config/nvim/init.vim ~/.config/nvim/init.vim
