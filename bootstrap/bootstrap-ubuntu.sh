#!/usr/bin/env bash

sudo apt install zsh software-properties-common curl apt-transport-https xclip fd-find kitty imagemagick -y

sh _local.sh
sh _config.sh
sh _fonts.sh

sh js-programming.sh
sh lua-programming.sh

echo "neovim" # todo: binify
sudo apt remove neovim -y
sudo add-apt-repository --remove ppa:neovim-ppa/stable
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim -y

echo "lazygit" # todo: binify
sudo add-apt-repository ppa:lazygit-team/release
sudo apt update
sudo apt install lazygit -y

echo "python & pip"
sudo apt update
sudo apt install python3 python3-pip -y

echo "brave" # todo: flatpak
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

echo "libreoffice" # todo: flatpak
sudo add-apt-repository ppa:libreoffice/ppa
sudo apt update
sudo apt install libreoffice -y

echo "dotnet, fsharp"
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/packages-microsoft-prod.deb
rm -rf ~/Downloads/packages-microsoft-prod.deb

sudo apt update
sudo apt install dotnet-sdk-5.0 fsharp -y
