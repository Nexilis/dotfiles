#!/usr/bin/env bash

echo "JetBrains Toolbox"
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.22.10970.tar.gz -O $HOME/Downloads/jetbrains-toolbox.tar.gz
tar -vxzf $HOME/Downloads/jetbrains-toolbox.gz -C $HOME/Downloads
mv -vf $HOME/Downloads/jetbrains-toolbox-1.22.10970/jetbrains-toolbox $HOME/.local/bin/jetbrains-toolbox
chmod u+x $HOME/.local/bin/jetbrains-toolbox
rm -vf $HOME/Downloads/jetbrains-toolbox.tar.gz
rm -vrf $HOME/Downloads/jetbrains-toolbox-1.22.10970
