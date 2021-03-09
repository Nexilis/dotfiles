#!/usr/bin/env bash

echo "dotnet, fsharp"
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/packages-microsoft-prod.deb
rm -rf ~/Downloads/packages-microsoft-prod.deb

sudo apt update
sudo apt install dotnet-sdk-5.0 fsharp -y
