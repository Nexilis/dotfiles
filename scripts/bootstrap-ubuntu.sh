#!/usr/bin/env bash

sudo apt install zsh xclip bat fd-find vim-gtk3 fonts-firacode -y

echo "ripgrep"
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.0.1/ripgrep_12.0.1_amd64.deb
sudo dpkg -i ripgrep_12.0.1_amd64.deb

echo "config"
cp -f -r ../home/. ~/
cp -f -r ../.config/mc ~/.config/mc
cp -f -r ../.config/.vim ~/.config/.vim
chsh -s `which zsh`

echo "broot"
wget https://dystroy.org/broot/download/x86_64-linux/broot -P $HOME/Downloads
sudo mv ~/Downloads/broot /usr/local/bin/broot
sudo chmod +x /usr/local/bin/broot

echo "micro"
cd /usr/local/bin; curl https://getmic.ro | sudo bash

echo "diff-so-fancy"
wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -P $HOME/Downloads
sudo mv ~/Downloads/diff-so-fancy /usr/local/bin
sudo chmod +x /usr/local/bin/diff-so-fancy

echo "exa"
wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip -P $HOME/Downloads
unzip exa-linux-x86_64-0.9.0.zip
sudo mv ~/Downloads/exa-linux-x86_64 /usr/local/bin/exa
sudo chmod +x /usr/local/bin/exa

echo "fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "dotnet"
wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/packages-microsoft-prod.deb
sudo apt update & sudo apt install apt-transport-https dotnet-sdk-3.1 fsharp -y

echo "https://ohmyz.sh/"
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

