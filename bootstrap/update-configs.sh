#!/usr/bin/env bash

echo "zsh omz -> antigen"
rm -rf ~/.oh-my-zsh
mkdir -p ~/.zsh
wget git.io/antigen -O $HOME/.zsh/antigen.zsh

echo "zsh rc"
cp -f -r ../home/.zshrc ~/

echo "config mc"
rm -rf ~/.config/mc
cp -f -r ../.config/mc ~/.config/mc

echo "config vim"
rm -rf ~/_vimrc
rm -rf ~/.vimrc
cp -f -r ../.config/.vim ~/.config/.vim
ln -s ~/proj/dotfiles/home/.vimrc ~/.vimrc

echo "config neovim"
cp -f -r ../.config/nvim ~/.config/nvim
rm -f ~/.config/nvim/init.vim
ln -s ~/proj/dotfiles/.config/nvim/init.vim ~/.config/nvim/init.vim

echo "config git"
cp -f -r ../home/.gitconfig ~/
#cp -f -r ../home/.gitconfig-github ~/
#cp -f -r ../home/.gitconfig-work ~/

echo "config alacritty"
rm -rf ~/.config/alacritty
cp -f -r ../.config/alacritty ~/.config/alacritty

echo "config conky"
cp -f -r ../home/.conkyrc ~/
