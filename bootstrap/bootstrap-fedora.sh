#!/usr/bin/env bash

# rlwrap is clojure dep, xclip is needed to be able to copy from nvim, helix to sys-clipboard
sudo dnf install xclip fish util-linux-user kitty ImageMagick rlwrap mc hunspell-pl -y
chsh -s $(which fish)

# snap with classic mode
# sudo dnf install snapd -y
# sudo ln -s /var/lib/snapd/snap /snap

# curl with sources
sudo dnf install curl libcurl-devel -y

sh ~/proj/dotfiles/bootstrap/_local.sh
sh ~/proj/dotfiles/bootstrap/_config.sh
sh ~/proj/dotfiles/bootstrap/_fonts.sh

echo "python3"
sudo dnf install python3 python3-pip -y

echo "lua"
sudo dnf install lua lua-devel readline-devel luarocks -y
luarocks install --local fennel
luarocks install --local readline

echo "dotnet"
sudo dnf install dotnet-sdk-6.0 -y

echo "visual studio code"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install code -y

echo "azure data studio"
wget https://sqlopsbuilds.azureedge.net/stable/83a4316cf89cbf961a0f09a72c861379cfd01fa9/azuredatastudio-linux-1.34.0.rpm -O $HOME/Downloads/azuredatastudio.rpm
sudo rpm -i $HOME/Downloads/azuredatastudio.rpm
rm -vf $HOME/Downloads/azuredatastudio.rpm

echo "fish - omf"
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install sdk
omf install z
omf install nvm
echo "nodejs"
nvm install --lts
npm install yarn -g

