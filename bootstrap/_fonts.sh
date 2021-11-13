#!/usr/bin/env bash


echo "JetBrains Mono"
wget https://github.com/JetBrains/JetBrainsMono/releases/download/v2.225/JetBrainsMono-2.225.zip -O $HOME/Downloads/JetBrainsMono.zip
unzip -o $HOME/Downloads/JetBrainsMono.zip -d $HOME/Downloads/jbm
# todo: localify
sudo mv -f ~/Downloads/jbm/fonts/ttf "/usr/share/fonts/truetype/JetBrains Mono"
rm -rf $HOME/Downloads/JetBrainsMono.zip
rm -rf $HOME/Downloads/jbm


echo "Cascadia Mono"

fc-cache -f -v
