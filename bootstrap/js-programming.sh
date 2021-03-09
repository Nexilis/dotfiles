#!/usr/bin/env bash

echo "nodejs"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt update && sudo apt install nodejs tidy -y
sudo npm -g install js-beautify

