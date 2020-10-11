#!/usr/bin/env bash

sudo apt install software-properties-common curl apt-transport-https xclip fd-find mc htop fonts-firacode -y

sh zsh.sh
sh ripgrep.sh
sh bat.sh
sh broot.sh
sh nvim.sh
sh micro.sh
sh jdk-programming.sh
sh dotnet-programming.sh
sh js-programming.sh
sh rust-programming.sh

echo "fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

echo "config mc"
cp -f -r ../.config/mc ~/.config/mc

echo "config vim"
cp -f -r ../.config/.vim ~/.config/.vim
cp -f -r ../home/.vimrc ~/

echo "config git"
cp -f -r ../home/.gitconfig ~/
cp -f -r ../home/.gitconfig-github ~/
cp -f -r ../home/.gitconfig-work ~/

echo "diff-so-fancy"
wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -P $HOME/Downloads
sudo mv ~/Downloads/diff-so-fancy /usr/local/bin
sudo chmod +x /usr/local/bin/diff-so-fancy

echo "lazygit"
sudo add-apt-repository ppa:lazygit-team/release
sudo apt update
sudo apt install lazygit

echo "joplin"
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash

echo "insomnia"
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
    | sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
    | sudo apt-key add -
sudo apt update
sudo apt install insomnia

echo "sublime text & merge"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install sublime-text sublime-merge -y

echo "brave"
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser -y

echo "JetBrains Mono"
wget https://download.jetbrains.com/fonts/JetBrainsMono-1.0.3.zip -O $HOME/Downloads/JetBrainsMono.zip
unzip -o $HOME/Downloads/JetBrainsMono.zip -d $HOME/Downloads
sudo mv -f ~/Downloads/JetBrainsMono-1.0.3/ttf "/usr/share/fonts/truetype/JetBrains Mono"
rm -rf $HOME/Downloads/JetBrainsMono.zip
rm -rf $HOME/Downloads/JetBrainsMono-1.0.3
fc-cache -f -v
