#!/usr/bin/env bash

echo "diff-so-fancy"

wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O $HOME/Downloads/diff-so-fancy
chmod u+x $HOME/Downloads/diff-so-fancy
mv -f $HOME/Downloads/diff-so-fancy $HOME/.local/bin
