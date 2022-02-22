#!/usr/bin/env bash

wget https://github.com/sharkdp/fd/releases/download/v8.3.2/fd-v8.3.2-x86_64-unknown-linux-musl.tar.gz -O $HOME/Downloads/fd-find.tar.gz
tar -vxzf $HOME/Downloads/fd-find.tar.gz -C $HOME/Downloads
mv -vf $HOME/Downloads/fd-v8.3.2-x86_64-unknown-linux-musl/fd $HOME/.local/bin/fd
chmod u+x $HOME/.local/bin/fd
rm -vrf $HOME/Downloads/fd-*
