#!/usr/bin/env bash

echo "remove vim config"
rm -rf ~/_vimrc
rm -rf ~/.vimrc
rm -rf ~/.config/vim

echo "remove alacritty config"
rm -rf ~/.config/alacritty

echo "config kitty"
rm -rf ~/.config/kitty
cp -f -r ../.config/kitty ~/.config/
