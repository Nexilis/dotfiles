#!/usr/bin/env bash

echo "starship.rs"
wget https://starship.rs/install.sh -O $HOME/Downloads/install.sh
rm -vf $HOME/.local/bin/starship
sh $HOME/Downloads/install.sh --force -b $HOME/.local/bin
rm -vf $HOME/Downloads/install.sh

