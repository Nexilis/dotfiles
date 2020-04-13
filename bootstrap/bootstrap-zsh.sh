#!/usr/bin/env bash

echo "zsh"
sudo apt install zsh -y

echo "zsh antigen"
mkdir ~/.zsh
wget git.io/antigen -O $HOME/.zsh/antigen.zsh

echo "zsh rc"
cp -f -r ../home/.zshrc ~/

echo "chsh zsh"
chsh -s $(which zsh)