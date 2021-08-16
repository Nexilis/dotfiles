#!/usr/bin/env bash

echo "lua 5.3 - latest compatible with Ubuntu 20.04 + luarocks - package manager"
sudo apt update
sudo apt install lua5.3 liblua5.3-dev libreadline-dev luarocks -y

echo "fennel - Lisp on lua"
sudo rm -rf /usr/local/bin/fennel
luarocks install --local fennel
luarocks install --local readline
