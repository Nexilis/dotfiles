#!/usr/bin/env bash

echo "neovim"
sudo apt remove neovim -y
sudo add-apt-repository --remove ppa:neovim-ppa/stable
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim -y

echo "neovim python support"
pip3 install --user pynvim

echo "config neovim"
cp -f -r ../.config/nvim ~/.config/
rm -f ~/.config/nvim/init.vim
ln -s ~/proj/dotfiles/.config/nvim/init.vim ~/.config/nvim/init.vim
