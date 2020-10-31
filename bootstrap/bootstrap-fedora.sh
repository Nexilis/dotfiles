#!/usr/bin/env bash

sudo dnf install zsh util-linux-user bat fd ripgrep neovim mc htop micro -y

echo "zsh antigen"
mkdir ~/.zsh
wget git.io/antigen -O $HOME/.zsh/antigen.zsh

echo "zsh rc"
cp -f -r ../home/.zshrc ~/

echo "chsh zsh"
chsh -s $(which zsh)

sh fzf.sh
sh broot.sh
sh joplin.sh
sh jetbrains-mono.sh
sh diff-so-fancy.sh

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
sudo dnf copr enable vondruch/doublecmd
sudo dnf install doublecmd-gtk
cp -f -r ../.config/doublecmd ~/.config/

# todo:
# sh jdk-programming.sh
# sh dotnet-programming.sh
# sh js-programming.sh
# sh rust-programming.sh
# insomnia
# python & pip
# fonts-firacode