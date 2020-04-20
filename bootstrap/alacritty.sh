#!/usr/bin/env bash

echo "alacritty"
sudo add-apt-repository ppa:mmstick76/alacritty
sudo apt update
sudo apt install alacritty -y
rm -rf ~/.config/alacritty
cp -f -r ../.config/alacritty ~/.config/alacritty

