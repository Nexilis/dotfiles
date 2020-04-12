#!/usr/bin/env bash

sudo apt install fish

echo "fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --bin

curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

fisher add jethrokuan/z jethrokuan/fzf rafaelrinaldi/pure edc/bass

chsh -s $(which fish)