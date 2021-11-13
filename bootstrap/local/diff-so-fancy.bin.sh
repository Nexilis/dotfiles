#!/usr/bin/env bash

echo "diff-so-fancy"

wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O $HOME/Downloads/diff-so-fancy
chmod +x $HOME/Downloads/diff-so-fancy
rm -f $HOME/.local/bin/diff-so-fancy
mv $HOME/Downloads/diff-so-fancy $HOME/.local/bin
