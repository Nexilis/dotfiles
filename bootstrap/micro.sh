#!/usr/bin/env bash

echo "micro"
rm -rf micro
curl https://getmic.ro | bash
sudo rm -rf /usr/local/bin/micro
sudo mv micro /usr/local/bin/micro
rm -rf micro
