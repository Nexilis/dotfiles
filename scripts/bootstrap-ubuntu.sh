#!/usr/bin/env bash

rm -r -f ~/.oh-my-zsh
cp -f -r -s ~/dotfiles/home/. ~/
cp -f -r -s ~/dotfiles/.config ~/
chsh -s /bin/zsh
