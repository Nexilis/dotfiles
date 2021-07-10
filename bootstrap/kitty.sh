#!/usr/bin/env bash

echo "kitty"
sudo apt install kitty -y
rm -rf ~/.config/kitty
cp -f -r ../.config/kitty ~/.config/kitty

