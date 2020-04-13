#!/usr/bin/env bash

echo "zsh rc"
rm -rf ~/.oh-my-zsh
cp -f -r ../home/.zshrc ~/
echo "config mc"
cp -f -r ../.config/mc ~/.config/mc
echo "config vim"
cp -f -r ../.config/.vim ~/.config/.vim
cp -f -r ../home/_vimrc ~/
echo "config git"
cp -f -r ../home/.gitconfig ~/
#cp -f -r ../home/.gitconfig-github ~/
#cp -f -r ../home/.gitconfig-work ~/