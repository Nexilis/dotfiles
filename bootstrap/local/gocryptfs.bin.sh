#!/usr/bin/env bash

wget https://github.com/rfjakob/gocryptfs/releases/download/v2.2.1/gocryptfs_v2.2.1_linux-static_amd64.tar.gz -O $HOME/Downloads/gocryptfs.tar.gz
tar -vxzf $HOME/Downloads/gocryptfs.tar.gz -C $HOME/Downloads
mv -vf $HOME/Downloads/gocryptfs $HOME/.local/bin/gocryptfs
chmod u+x $HOME/.local/bin/gocryptfs
rm -vf $HOME/Downloads/gocryptfs*
