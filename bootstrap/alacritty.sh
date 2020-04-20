#!/usr/bin/env bash

echo "alacritty"
sudo add-apt-repository ppa:mmstick76/alacritty
sudo apt install alacritty
rm -rf ~/.config/alacritty
cp -f -r ../.config/alacritty ~/.config/alacritty

