#!/usr/bin/env bash

echo "JetBrains Mono"
wget https://github.com/JetBrains/JetBrainsMono/releases/download/v2.242/JetBrainsMono-2.242.zip -O $HOME/Downloads/JetBrainsMono.zip
unzip $HOME/Downloads/JetBrainsMono.zip -d $HOME/Downloads/JetBrainsMono
mkdir -vp $HOME/.local/share/fonts/jetbrains-mono
find $HOME/Downloads/JetBrainsMono/fonts/variable -maxdepth 1 -iname '*.ttf' -exec cp -vfu {} $HOME/.local/share/fonts/jetbrains-mono \;
rm -vrf $HOME/Downloads/JetBrainsMono*

echo "Cascadia Code PL"
wget https://github.com/microsoft/cascadia-code/releases/download/v2110.31/CascadiaCode-2110.31.zip -O $HOME/Downloads/CascadiaCode.zip
unzip $HOME/Downloads/CascadiaCode.zip -d $HOME/Downloads/CascadiaCode
mkdir -vp $HOME/.local/share/fonts/cascadia-code
find $HOME/Downloads/CascadiaCode/ttf -maxdepth 1 -iname '*.ttf' -exec cp -vfu {} $HOME/.local/share/fonts/cascadia-code \;
rm -vrf $HOME/Downloads/CascadiaCode*

fc-cache -vf
