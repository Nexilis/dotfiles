#!/usr/bin/env bash

rm -vfr $HOME/Downloads/nvui*

wget https://github.com/rohit-px2/nvui/releases/download/v0.2.1/nvui-linux-x64.zip -O $HOME/Downloads/nvui.zip

unzip $HOME/Downloads/nvui.zip -d $HOME/Downloads/nvui
cp -vfr $HOME/Downloads/nvui/* $HOME/.local
chmod u+x $HOME/.local/bin/nvui
rm -vrf $HOME/Downloads/nvui*

rm -vf $HOME/.local/share/applications/nvui.desktop
touch $HOME/.local/share/applications/nvui.desktop
echo "[Desktop Entry]
Name=NVUI
Comment=Neovim UI
Terminal=false
Exec=$HOME/.local/bin/nvui --ext_multigrid
Icon=nvim
Categories=Utility;TextEditor;
MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
Type=Application" >> $HOME/.local/share/applications/nvui.desktop
