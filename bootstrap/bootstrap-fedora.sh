#!/usr/bin/env bash

# rlwrap is clojure dep
sudo dnf install fish util-linux-user kitty ImageMagick rlwrap -y

sh ~/proj/dotfiles/bootstrap/_local.sh
sh ~/proj/dotfiles/bootstrap/_config.sh
sh ~/proj/dotfiles/bootstrap/_fonts.sh
chsh -s $(which fish)

echo "brave"
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser -y

echo "python3"
sudo dnf install python3 python3-pip -y

echo "nodejs"
sudo dnf install nodejs -y

echo "lua"
sudo dnf install lua lua-devel readline-devel luarocks -y
luarocks install --local fennel
luarocks install --local readline
