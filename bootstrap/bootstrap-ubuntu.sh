#!/usr/bin/env bash

sudo apt update -y

sudo apt install fish software-properties-common apt-transport-https kitty imagemagick mc -y
# curl with sources
sudo apt install curl libssl-dev libcurl4-openssl-dev -y
chsh -s $(which fish)

sh ~/proj/dotfiles/bootstrap/_local.sh
sh ~/proj/dotfiles/bootstrap/_config.sh
sh ~/proj/dotfiles/bootstrap/_fonts.sh

echo "flatpak"
sudo apt install flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo apt install --install-suggests gnome-software
sudo snap remove --purge snap-store

echo "python3"
sudo apt install python3 python3-pip -y

echo "nodejs"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs tidy -y
sudo npm -g install js-beautify

echo "lua"
sudo apt install lua5.4 liblua5.4-dev libreadline-dev luarocks -y
luarocks install --local fennel
luarocks install --local readline

echo "fish - omf"
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install sdk
omf install z
