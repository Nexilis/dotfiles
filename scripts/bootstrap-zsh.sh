#!/usr/bin/env bash

sudo apt install zsh

echo "fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --bin

echo "https://ohmyz.sh/"
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -P $HOME/Downloads
sh $HOME/Downloads/install.sh --keep-zshrc --skip-chsh --unattended
rm -rf ~/Downloads/install.sh

# Installs plugins
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
chmod +x ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

chsh -s $(which zsh)