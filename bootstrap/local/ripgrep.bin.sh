#!/usr/bin/env bash

wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz -O $HOME/Downloads/ripgrep.tar.gz
tar xvzf $HOME/Downloads/ripgrep.tar.gz -C $HOME/Downloads
rm -f $HOME/.local/bin/rg
mv $HOME/Downloads/ripgrep-13.0.0-x86_64-unknown-linux-musl/rg $HOME/.local/bin/rg
chmod +x $HOME/.local/bin/rg
rm -rf $HOME/Downloads/ripgrep*
