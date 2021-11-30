#!/usr/bin/env bash

# echo "config zsh"
# rm -vrf $HOME/.zsh*
# mkdir -vp $HOME/.zsh
# wget git.io/antigen -O $HOME/.zsh/antigen.zsh
# cp -vf $HOME/proj/dotfiles/home/.zshrc $HOME/

echo "config fish"
rm -vrf $HOME/.config/fish
mkdir -vp $HOME/.config/fish
cp -vfr $HOME/proj/dotfiles/config/fish $HOME/.config

echo "config kitty"
rm -vrf $HOME/.config/kitty
mkdir -vp $HOME/.config/kitty
cp -vfr $HOME/proj/dotfiles/config/kitty $HOME/.config

echo "config neovim"
rm -vrf $HOME/.config/nvim
mkdir -vp $HOME/.config/nvim
cp -vfr $HOME/proj/dotfiles/config/nvim $HOME/.config
echo "neovim python support"
pip3 install --user pynvim

echo "config git"
cp -vf $HOME/proj/dotfiles/home/.gitconfig $HOME/
cp -vf $HOME/proj/dotfiles/home/.gitconfig-github $HOME/
cp -vf $HOME/proj/dotfiles/home/.gitconfig-work $HOME/

echo "doublecmd"
rm -vf $HOME/.local/share/doublecmd/doublecmd.inf
rm -vrf $HOME/.config/doublecmd
mkdir -vp $HOME/.config/doublecmd
cp -vfr $HOME/proj/dotfiles/config/doublecmd $HOME/.config
