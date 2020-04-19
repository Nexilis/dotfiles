echo "exa"
wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip -P $HOME/Downloads
unzip ~/Downloads/exa-linux-x86_64-0.9.0.zip -d ~/Downloads
sudo mv ~/Downloads/exa-linux-x86_64 /usr/local/bin/exa
sudo chmod +x /usr/local/bin/exa
rm -rf ~/Downloads/exa-linux-x86_64-0.9.0.zip

