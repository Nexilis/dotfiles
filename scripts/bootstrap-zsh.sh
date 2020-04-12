#!/usr/bin/env bash

echo "zsh"
sudo apt install zsh

echo "https://ohmyz.sh/"
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -P $HOME/Downloads
sh $HOME/Downloads/install.sh --keep-zshrc --skip-chsh --unattended
rm -rf ~/Downloads/install.sh

echo "zsh plugins"
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
chmod +x ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo "chsh zsh"
chsh -s $(which zsh)