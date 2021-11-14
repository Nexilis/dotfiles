#!/usr/bin/env bash

sudo apt install zsh software-properties-common curl apt-transport-https xclip kitty imagemagick -y

sh _local.sh
sh _config.sh
sh _fonts.sh

sh js-programming.sh
sh lua-programming.sh

echo "python & pip"
sudo apt update
sudo apt install python3 python3-pip -y

echo "nodejs"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt update && sudo apt install nodejs tidy -y
sudo npm -g install js-beautify

echo "lua 5.3 - latest compatible with Ubuntu 20.04 + luarocks - package manager"
sudo apt update
sudo apt install lua5.3 liblua5.3-dev libreadline-dev luarocks -y

echo "fennel - Lisp on lua"
sudo rm -rf /usr/local/bin/fennel
luarocks install --local fennel
luarocks install --local readline

echo "brave" # todo: flatpak
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

echo "libreoffice" # todo: flatpak
sudo add-apt-repository ppa:libreoffice/ppa
sudo apt update
sudo apt install libreoffice -y
