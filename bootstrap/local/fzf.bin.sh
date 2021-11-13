#!/usr/bin/env bash

echo "fzf"
rm -rf $HOME/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
(cd $HOME/.fzf && install --all)