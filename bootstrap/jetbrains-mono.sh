#!/usr/bin/env bash

echo "JetBrains Mono"
wget https://download.jetbrains.com/fonts/JetBrainsMono-1.0.3.zip -O $HOME/Downloads/JetBrainsMono.zip
unzip -o $HOME/Downloads/JetBrainsMono.zip -d $HOME/Downloads
sudo mv -f ~/Downloads/JetBrainsMono-1.0.3/ttf "/usr/share/fonts/truetype/JetBrains Mono"
rm -rf $HOME/Downloads/JetBrainsMono.zip
rm -rf $HOME/Downloads/JetBrainsMono-1.0.3
fc-cache -f -v
