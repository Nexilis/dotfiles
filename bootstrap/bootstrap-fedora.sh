#!/usr/bin/env bash

sudo dnf install zsh util-linux-user kitty imagemagick rlwrap -y

sh _local.sh
sh _config.sh
sh _fonts.sh

echo "Brave"
sudo dnf install dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser

echo "doublecmd"
sudo dnf copr enable vondruch/doublecmd -y
sudo dnf install doublecmd-gtk -y

# todo: python & pip, lua, js
