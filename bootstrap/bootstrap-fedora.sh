#!/usr/bin/env bash

sudo dnf install zsh util-linux-user bat fd ripgrep neovim mc htop micro tilix fira-code-fonts -y

echo "config zsh"
mkdir ~/.zsh
wget git.io/antigen -O $HOME/.zsh/antigen.zsh
cp -f -r ../home/.zshrc ~/
chsh -s $(which zsh)

sh starship.sh
sh fzf.sh
sh broot.sh
sh joplin.sh
sh jetbrains-mono.sh
sh diff-so-fancy.sh
sh rust-programming.sh

echo "config mc"
cp -f -r ../.config/mc ~/.config/

echo "config neovim"
cp -f -r ../.config/nvim ~/.config/
rm -f ~/.config/nvim/init.vim
ln -s ~/proj/dotfiles/.config/nvim/init.vim ~/.config/nvim/init.vim

echo "config git"
cp -f -r ../home/.gitconfig ~/
cp -f -r ../home/.gitconfig-github ~/
cp -f -r ../home/.gitconfig-work ~/

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
cp -f -r ../.config/doublecmd ~/.config/

echo "dotnet"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo wget -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/33/prod.repo
sudo dnf install dotnet-sdk-5.0

# todo:
# sh js-programming.sh
# insomnia
# python & pip

echo "latest java"
sudo dnf install java-latest-openjdk-devel rlwrap -y
sh jdk-programming.sh
