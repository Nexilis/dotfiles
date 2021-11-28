#!/usr/bin/env bash

rm -vrf $HOME/Downloads/exa*
wget https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip -O $HOME/Downloads/exa.zip
unzip $HOME/Downloads/exa.zip -d $HOME/Downloads/exa
mv -vf $HOME/Downloads/exa/bin/exa $HOME/.local/bin/exa
rm -vrf $HOME/Downloads/exa*
