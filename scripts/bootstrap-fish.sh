#!/usr/bin/env bash

echo "fish"
sudo apt install fish

echo "fish config"
cp -f -r ../.config/fish ~/.config/fish

echo "chsh fish"
chsh -s $(which fish)
