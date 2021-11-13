#!/usr/bin/env bash

wget https://github.com/jesseduffield/lazygit/releases/download/v0.31.3/lazygit_0.31.3_Linux_x86_64.tar.gz -O $HOME/Downloads/lazygit.tar.gz
mkdir $HOME/Downloads/lazygit
tar xvzf $HOME/Downloads/lazygit.tar.gz -C $HOME/Downloads/lazygit
rm -f $HOME/.local/bin/lg
mv $HOME/Downloads/lazygit/lazygit $HOME/.local/bin/lg
chmod +x $HOME/.local/bin/lg
rm -rf $HOME/Downloads/lazygit*
