#!/usr/bin/env bash

echo "JetBrains Mono"
wget https://github.com/JetBrains/JetBrainsMono/releases/download/v2.242/JetBrainsMono-2.242.zip -O $HOME/Downloads/JetBrainsMono.zip
unzip $HOME/Downloads/JetBrainsMono.zip -d $HOME/Downloads/JetBrainsMono
mkdir -vp $HOME/.local/share/fonts/jetbrains-mono
find $HOME/Downloads/JetBrainsMono/fonts/variable -maxdepth 1 -iname '*.ttf' -exec cp -vfu {} $HOME/.local/share/fonts/jetbrains-mono \;
rm -vrf $HOME/Downloads/JetBrainsMono*

echo "Cascadia Code PL"
wget https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip -O $HOME/Downloads/CascadiaCode.zip
unzip $HOME/Downloads/CascadiaCode.zip -d $HOME/Downloads/CascadiaCode
mkdir -vp $HOME/.local/share/fonts/cascadia-code
find $HOME/Downloads/CascadiaCode/ttf -maxdepth 1 -iname '*.ttf' -exec cp -vfu {} $HOME/.local/share/fonts/cascadia-code \;
rm -vrf $HOME/Downloads/CascadiaCode*

echo "FiraCode Nerd"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip -O $HOME/Downloads/FiraCode.zip
unzip $HOME/Downloads/FiraCode.zip -d $HOME/Downloads/FiraCode
mkdir -vp $HOME/.local/share/fonts/fira-code
find $HOME/Downloads/FiraCode -maxdepth 1 -iname '*.ttf' -exec cp -vfu {} $HOME/.local/share/fonts/fira-code \;
rm -vrf $HOME/Downloads/FiraCode*

echo "Hack Nerd"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip -O $HOME/Downloads/Hack.zip
unzip $HOME/Downloads/Hack.zip -d $HOME/Downloads/Hack
mkdir -vp $HOME/.local/share/fonts/hack
find $HOME/Downloads/Hack -maxdepth 1 -iname '*.ttf' -exec cp -vfu {} $HOME/.local/share/fonts/hack \;
rm -vrf $HOME/Downloads/Hack*

fc-cache -vf
