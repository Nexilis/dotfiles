#!/usr/bin/env bash

echo "btop"
wget https://github.com/aristocratos/btop/releases/download/v1.0.24/btop-1.0.24-x86_64-linux-musl.tbz -O $HOME/Downloads/btop.tbz
mkdir -vp $HOME/Downloads/btop
tar -vxjf $HOME/Downloads/btop.tbz -C $HOME/Downloads/btop
(cd $HOME/Downloads/btop && make install PREFIX=$HOME/.local)
rm -vrf $HOME/Downloads/btop
rm -vf $HOME/Downloads/btop.tbz
