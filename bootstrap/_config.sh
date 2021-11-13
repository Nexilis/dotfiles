#!/usr/bin/env bash

echo "config zsh"
mkdir ~/.zsh
wget git.io/antigen -O $HOME/.zsh/antigen.zsh
cp -f -r ~/proj/dotfiles/home/.zshrc ~/
chsh -s $(which zsh)

echo "config kitty"
rm -rf ~/.config/kitty
cp -f -r ~/proj/dotfiles/config/kitty ~/.config/kitty

echo "config neovim"
rm -rf ~/.config/nvim
cp -f -r ~/proj/dotfiles/config/nvim ~/.config/
ln -s ~/proj/dotfiles/config/nvim/init.vim ~/.config/nvim/init.vim
ln -s ~/proj/dotfiles/config/nvim/lua/settings.lua ~/.config/nvim/lua/settings.lua
echo "neovim python support"
pip3 install --user pynvim

echo "config git"
cp -f -r ~/proj/dotfiles/home/.gitconfig ~/
cp -f -r ~/proj/dotfiles/home/.gitconfig-github ~/
cp -f -r ~/proj/dotfiles/home/.gitconfig-work ~/

echo "config doublecmd"
cp -f -r ~/proj/dotfiles/config/doublecmd ~/.config/
