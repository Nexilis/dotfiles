#!/usr/bin/env bash

sudo apt install software-properties-common curl apt-transport-https xclip fd-find mc htop fonts-firacode imagemagick -y

sh zsh.sh
sh starship.sh
sh fzf.sh
sh ripgrep.sh
sh bat.sh
sh broot.sh
sh nvim.sh
sh micro.sh
sh kitty.sh
sh diff-so-fancy.sh
sh dotnet-programming.sh
sh js-programming.sh
sh rust-programming.sh
sh lua-programming.sh
sh jetbrains-mono.sh
sh exa.sh

echo "config mc"
cp -f -r ../.config/mc ~/.config/

echo "config git"
cp -f -r ../home/.gitconfig ~/
cp -f -r ../home/.gitconfig-github ~/
cp -f -r ../home/.gitconfig-work ~/

echo "lazygit"
sudo add-apt-repository ppa:lazygit-team/release
sudo apt update
sudo apt install lazygit -y

echo "insomnia"
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
    | sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
    | sudo apt-key add -
sudo apt update
sudo apt install insomnia -y

echo "python & pip"
sudo apt update
sudo apt install python3 python3-pip -y

echo "brave"
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

echo "adoptopenjdk java"
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt update
sudo apt install adoptopenjdk-15-hotspot rlwrap -y
sh jdk-programming.sh

echo "ripgrep"
wget https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/ripgrep_12.1.1_amd64.deb
rm -rf $HOME/Downloads/ripgrep_12.1.1_amd64.deb

echo "libreoffice"
sudo add-apt-repository ppa:libreoffice/ppa
sudo apt update
sudo apt install libreoffice -y
