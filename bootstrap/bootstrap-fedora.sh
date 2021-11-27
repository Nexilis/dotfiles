#!/usr/bin/env bash

sudo dnf install zsh util-linux-user kitty imagemagick rlwrap -y

sh _local.sh
sh _config.sh
sh _fonts.sh

echo "brave"
sudo dnf install dnf-plugins-core -y
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser -y

echo "python3 (pre-installed on Fedora)"
sudo dnf install python3-pip -y

echo "nodejs"
sudo dnf install nodejs -y

echo "lua (pre-installed on Fedora)"
luarocks install --local fennel
luarocks install --local readline
