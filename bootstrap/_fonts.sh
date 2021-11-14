#!/usr/bin/env bash

echo "JetBrains Mono"
wget https://github.com/JetBrains/JetBrainsMono/releases/download/v2.225/JetBrainsMono-2.225.zip -O $HOME/Downloads/JetBrainsMono.zip
unzip -vo $HOME/Downloads/JetBrainsMono.zip -d $HOME/Downloads/JetBrainsMono
mkdir -vp $HOME/.local/share/fonts/jetbrains-mono
cp -vfur ~/Downloads/JetBrainsMono/fonts/ttf/*.ttf $HOMW/.local/share/fonts/jetbrains-mono
rm -vrf $HOME/Downloads/JetBrainsMono*

echo "Cascadia Code PL"
wget https://github.com/microsoft/cascadia-code/releases/download/v2110.31/CascadiaCode-2110.31.zip -O $HOME/Downloads/CascadiaCode.zip
unzip -vo $HOME/Downloads/CascadiaCode.zip -d $HOME/Downloads/CascadiaCode
mkdir -vp $HOME/.local/share/fonts/cascadia-code
cp -vfur ~/Downloads/CascadiaCode/fonts/ttf/*.ttf $HOMW/.local/share/fonts/cascadia-code
rm -vrf $HOME/Downloads/CascadiaCode*

fc-cache -vf
