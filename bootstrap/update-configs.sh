#!/usr/bin/env bash

echo "zsh omz -> antigen"
rm -rf ~/.oh-my-zsh
mkdir ~/.zsh
wget git.io/antigen -O $HOME/.zsh/antigen.zsh
echo "zsh rc"
cp -f -r ../home/.zshrc ~/
echo "config mc"
rm -rf ~/.config/mc
cp -f -r ../.config/mc ~/.config/mc
echo "config vim"
cp -f -r ../.config/.vim ~/.config/.vim
cp -f -r ../home/.vimrc ~/
rm -rf ~/_vimrc
echo "config git"
cp -f -r ../home/.gitconfig ~/
#cp -f -r ../home/.gitconfig-github ~/
#cp -f -r ../home/.gitconfig-work ~/
