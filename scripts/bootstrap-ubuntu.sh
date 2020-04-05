#!/usr/bin/env bash

sudo apt install software-properties-common zsh curl apt-transport-https xclip fd-find vim-gtk3 mc fonts-firacode -y

echo "ripgrep"
wget https://github.com/BurntSushi/ripgrep/releases/download/12.0.1/ripgrep_12.0.1_amd64.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/ripgrep_12.0.1_amd64.deb
rm -rf $HOME/Downloads/ripgrep_12.0.1_amd64.deb

echo "bat"
wget https://github.com/sharkdp/bat/releases/download/v0.13.0/bat_0.13.0_amd64.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/bat_0.13.0_amd64.deb
rm -rf bat_0.13.0_amd64.deb

echo "config1"
cp -f -r ../.config/mc ~/.config/mc
cp -f -r ../.config/.vim ~/.config/.vim

echo "broot"
wget https://dystroy.org/broot/download/x86_64-linux/broot -P $HOME/Downloads
sudo mv ~/Downloads/broot /usr/local/bin/broot
sudo chmod +x /usr/local/bin/broot
/usr/local/bin/broot --install

echo "micro"
function githubLatestTag {
    finalUrl=$(curl "https://github.com/$1/releases/latest" -s -L -I -o /dev/null -w '%{url_effective}')
    echo "${finalUrl##*v}"
}
TAG=$(githubLatestTag zyedidia/micro)
wget "https://github.com/zyedidia/micro/releases/download/v$TAG/micro-$TAG-linux64.tar.gz" -O $HOME/Downloads/micro.tar.gz
tar -xvzf $HOME/Downloads/micro.tar.gz "micro-$TAG/micro"
sudo mv "micro-$TAG/micro" /usr/local/bin/micro
rm $HOME/Downloads/micro.tar.gz
rm -rf "micro-$TAG"

echo "diff-so-fancy"
wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -P $HOME/Downloads
sudo mv ~/Downloads/diff-so-fancy /usr/local/bin
sudo chmod +x /usr/local/bin/diff-so-fancy

echo "exa"
wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip -P $HOME/Downloads
unzip ~/Downloads/exa-linux-x86_64-0.9.0.zip -d ~/Downloads
sudo mv ~/Downloads/exa-linux-x86_64 /usr/local/bin/exa
sudo chmod +x /usr/local/bin/exa
rm -rf ~/Downloads/exa-linux-x86_64-0.9.0.zip

echo "joplin"
wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash

echo "dotnet, fsharp, sublime, brave, spotify, codium"
wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/packages-microsoft-prod.deb
rm -rf ~/Downloads/packages-microsoft-prod.deb
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list

sudo apt update
sudo apt install dotnet-sdk-3.1 fsharp -y
sudo apt install sublime-text sublime-merge brave-browser spotify-client codium -y

echo "adoptopenjdk java, leiningen, clojure"
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt-get update
sudo apt-get install adoptopenjdk-11-hotspot rlwrap -y
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -O $HOME/Downloads/lein
sudo mv ~/Downloads/lein /usr/local/bin/lein
sudo chmod a+x /usr/local/bin/lein
wget https://download.clojure.org/install/linux-install-1.10.1.536.sh -O $HOME/Downloads/clj-install.sh
chmod +x $HOME/Downloads/clj-install.sh
sudo $HOME/Downloads/clj-install.sh
rm -rf $HOME/Downloads/clj-install.sh
java -version
lein version
clj -h

echo "rust"
wget https://sh.rustup.rs -O $HOME/Downloads/rustup-init.sh
chmod +x $HOME/Downloads/rustup-init.sh
~/Downloads/rustup-init.sh -q -y
rm -rf $HOME/Downloads/rustup-init.sh
rustup -V

echo "fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

echo "https://ohmyz.sh/"
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -P $HOME/Downloads
sh $HOME/Downloads/install.sh --keep-zshrc --skip-chsh --unattended
rm -rf ~/Downloads/install.sh

echo "config2"
cp -f -r ../home/. ~/

chsh -s $(which zsh)
