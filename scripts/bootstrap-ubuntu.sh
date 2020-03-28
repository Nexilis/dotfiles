#!/usr/bin/env bash

# 1. Install

sudo apt update & sudo apt install zsh xclip bat ripgrep fd-find -y

## https://ohmyz.sh/
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

## Broot
wget https://dystroy.org/broot/download/x86_64-linux/broot -P $HOME/Downloads
sudo mv ~/Downloads/broot /usr/local/bin/broot
sudo chmod +x /usr/local/bin/broot

## Micro
cd /usr/local/bin; curl https://getmic.ro | sudo bash

## diff-so-fancy
wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -P $HOME/Downloads
sudo mv ~/Downloads/diff-so-fancy /usr/local/bin
sudo chmod +x /usr/local/bin/diff-so-fancy

## exa
wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip -P $HOME/Downloads
unzip exa-linux-x86_64-0.9.0.zip
sudo mv ~/Downloads/exa-linux-x86_64 /usr/local/bin/exa
sudo chmod +x /usr/local/bin/exa

## fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# 2. Configure

cp -f -r -s ../home/. ~/
cp -f -r -s ../.config/mc ~/.config/mc
cp -f -r -s ../.config/.vim ~/.config/.vim
chsh -s `which zsh`
