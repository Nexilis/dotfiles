#!/usr/bin/env bash

echo "config zsh"
mkdir -vp $HOME/.zsh
wget git.io/antigen -O $HOME/.zsh/antigen.zsh
cp -vf $HOME/proj/dotfiles/home/.zshrc $HOME/
chsh -s $(which zsh)

echo "config kitty"
rm -vrf $HOME/.config/kitty
cp -vfr $HOME/proj/dotfiles/config/kitty $HOME/.config/kitty

echo "config neovim"
rm -vrf $HOME/.config/nvim
cp -vfr $HOME/proj/dotfiles/config/nvim $HOME/.config/
echo "neovim python support"
pip3 install --user pynvim

echo "config git"
cp -vf $HOME/proj/dotfiles/home/.gitconfig $HOME/
cp -vf $HOME/proj/dotfiles/home/.gitconfig-github $HOME/
cp -vf $HOME/proj/dotfiles/home/.gitconfig-work $HOME/
