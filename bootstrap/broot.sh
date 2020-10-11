#!/usr/bin/env bash

echo "broot"
rm -rf $HOME/Downloads/broot
wget https://dystroy.org/broot/download/x86_64-linux/broot -P $HOME/Downloads
sudo rm -rf /usr/local/bin/broot
sudo mv ~/Downloads/broot /usr/local/bin/broot
sudo chmod +x /usr/local/bin/broot
/usr/local/bin/broot --install
