#!/usr/bin/env bash

wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz -O $HOME/Downloads/ripgrep.tar.gz
tar -vxzf $HOME/Downloads/ripgrep.tar.gz -C $HOME/Downloads
mv -vf $HOME/Downloads/ripgrep-13.0.0-x86_64-unknown-linux-musl/rg $HOME/.local/bin/rg
chmod u+x $HOME/.local/bin/rg
rm -vrf $HOME/Downloads/ripgrep*
