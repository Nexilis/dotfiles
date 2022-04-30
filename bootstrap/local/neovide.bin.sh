#!/usr/bin/env bash

rm -vfr $HOME/Downloads/neovide*

wget https://github.com/neovide/neovide/releases/download/0.8.0/neovide-linux.tar.gz.zip -O $HOME/Downloads/neovide.tar.gz.zip
unzip $HOME/Downloads/neovide.tar.gz.zip -d $HOME/Downloads
mkdir -v $HOME/Downloads/neovide
tar -vxzf $HOME/Downloads/neovide.tar.gz -C $HOME/Downloads/neovide
mv -vf $HOME/Downloads/neovide/target/release/neovide $HOME/.local/bin/neovide
rm -vrf $HOME/Downloads/neovide*

rm -vf $HOME/.local/share/icons/hicolor/256x256/apps/neovide.png
mkdir -vp $HOME/.local/share/icons/hicolor/256x256/apps/
wget https://github.com/neovide/neovide/raw/main/assets/neovide-256x256.png -O $HOME/.local/share/icons/hicolor/256x256/apps/neovide.png

rm -vf $HOME/.local/share/icons/hicolor/48x48/apps/neovide.png
mkdir -vp $HOME/.local/share/icons/hicolor/48x48/apps/
wget https://github.com/neovide/neovide/raw/main/assets/neovide-48x48.png -O $HOME/.local/share/icons/hicolor/48x48/apps/neovide.png

rm -vf $HOME/.local/share/icons/hicolor/32x32/apps/neovide.png
mkdir -vp $HOME/.local/share/icons/hicolor/32x32/apps/
wget https://github.com/neovide/neovide/raw/main/assets/neovide-32x32.png -O $HOME/.local/share/icons/hicolor/32x32/apps/neovide.png

rm -vf $HOME/.local/share/icons/hicolor/16x16/apps/neovide.png
mkdir -vp $HOME/.local/share/icons/hicolor/16x16/apps/
wget https://github.com/neovide/neovide/raw/main/assets/neovide-16x16.png -O $HOME/.local/share/icons/hicolor/16x16/apps/neovide.png

rm -vf $HOME/.local/share/applications/neovide.desktop
touch $HOME/.local/share/applications/neovide.desktop
echo "[Desktop Entry]
Name=Neovide (nvim)
Comment=No Nonsense Neovim Client in Rust
Keywords=Text;Editor;
Terminal=false
Exec=env WINIT_UNIX_BACKEND=x11 $HOME/.local/bin/neovide
Icon=neovide
Categories=Utility;TextEditor;
MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
Type=Application" >> $HOME/.local/share/applications/neovide.desktop
