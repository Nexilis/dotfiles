#!/usr/bin/env bash

echo "fish"
sudo apt install fish -y

echo "fish config"
cp -f -r ../.config/fish ~/.config

echo "chsh fish"
chsh -s $(which fish)
