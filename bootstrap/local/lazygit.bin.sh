#!/usr/bin/env bash

wget https://github.com/jesseduffield/lazygit/releases/download/v0.31.3/lazygit_0.31.3_Linux_x86_64.tar.gz -O $HOME/Downloads/lazygit.tar.gz
mkdir -vp $HOME/Downloads/lazygit
tar -vxzf $HOME/Downloads/lazygit.tar.gz -C $HOME/Downloads/lazygit
mv -vf $HOME/Downloads/lazygit/lazygit $HOME/.local/bin/lg
chmod u+x $HOME/.local/bin/lg
rm -vrf $HOME/Downloads/lazygit*
