#!/usr/bin/env bash

sudo dnf install zsh util-linux-user fd neovim kitty imagemagick rlwrap -y

sh _local.sh
sh _config.sh
sh _fonts.sh

echo "Brave"
sudo dnf install dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser

echo "lazygit"
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit -y

echo "doublecmd"
sudo dnf copr enable vondruch/doublecmd -y
sudo dnf install doublecmd-gtk -y

echo "dotnet"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo wget -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/33/prod.repo
sudo dnf install dotnet-sdk-5.0

# todo:
# python & pip
# lua
