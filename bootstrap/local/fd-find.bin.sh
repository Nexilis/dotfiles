#!/usr/bin/env bash

wget https://github.com/sharkdp/fd/releases/download/v8.2.1/fd-v8.2.1-x86_64-unknown-linux-musl.tar.gz -O $HOME/Downloads/fd-find.tar.gz
tar xvzf $HOME/Downloads/fd-find.tar.gz -C $HOME/Downloads
rm -f $HOME/.local/bin/fd
mv $HOME/Downloads/fd-v8.2.1-x86_64-unknown-linux-musl/fd $HOME/.local/bin/fd
chmod +x $HOME/.local/bin/fd
rm -rf $HOME/Downloads/fd-*
