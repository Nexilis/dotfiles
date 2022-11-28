#!/usr/bin/env bash

rm -vfr $HOME/Downloads/doublecmd*

wget https://github.com/doublecmd/doublecmd/releases/download/v1.0.8/doublecmd-1.0.8.gtk2.x86_64.tar.xz -O $HOME/Downloads/doublecmd.tar.xz
unxz -vf $HOME/Downloads/doublecmd.tar.xz
tar -xvf $HOME/Downloads/doublecmd.tar -C $HOME/Downloads
rm -vfr $HOME/.local/share/doublecmd
mv -vf $HOME/Downloads/doublecmd $HOME/.local/share
rm -vf $HOME/.local/bin/doublecmd
rm -vfr $HOME/Downloads/doublecmd*

rm -vf $HOME/.local/share/icons/hicolor/512x512/apps/doublecmd.png
mkdir -vp $HOME/.local/share/icons/hicolor/512x512/apps/
wget https://icons.iconarchive.com/icons/papirus-team/papirus-apps/512/doublecmd-icon.png -O $HOME/.local/share/icons/hicolor/512x512/apps/doublecmd.png

rm -vf $HOME/.local/share/icons/hicolor/256x256/apps/doublecmd.png
mkdir -vp $HOME/.local/share/icons/hicolor/256x256/apps/
wget https://icons.iconarchive.com/icons/papirus-team/papirus-apps/256/doublecmd-icon.png -O $HOME/.local/share/icons/hicolor/256x256/apps/doublecmd.png

rm -vf $HOME/.local/share/icons/hicolor/128x128/apps/doublecmd.png
mkdir -vp $HOME/.local/share/icons/hicolor/128x128/apps/
wget https://icons.iconarchive.com/icons/papirus-team/papirus-apps/128/doublecmd-icon.png -O $HOME/.local/share/icons/hicolor/128x128/apps/doublecmd.png

rm -vf $HOME/.local/share/icons/hicolor/96x96/apps/doublecmd.png
mkdir -vp $HOME/.local/share/icons/hicolor/96x96/apps/
wget https://icons.iconarchive.com/icons/papirus-team/papirus-apps/96/doublecmd-icon.png -O $HOME/.local/share/icons/hicolor/96x96/apps/doublecmd.png

rm -vf $HOME/.local/share/icons/hicolor/64x64/apps/doublecmd.png
mkdir -vp $HOME/.local/share/icons/hicolor/64x64/apps/
wget https://icons.iconarchive.com/icons/papirus-team/papirus-apps/64/doublecmd-icon.png -O $HOME/.local/share/icons/hicolor/64x64/apps/doublecmd.png

rm -vf $HOME/.local/share/icons/hicolor/48x48/apps/doublecmd.png
mkdir -vp $HOME/.local/share/icons/hicolor/48x48/apps/
wget https://icons.iconarchive.com/icons/papirus-team/papirus-apps/48/doublecmd-icon.png -O $HOME/.local/share/icons/hicolor/48x48/apps/doublecmd.png

rm -vf $HOME/.local/share/icons/hicolor/32x32/apps/doublecmd.png
mkdir -vp $HOME/.local/share/icons/hicolor/32x32/apps/
wget https://icons.iconarchive.com/icons/papirus-team/papirus-apps/32/doublecmd-icon.png -O $HOME/.local/share/icons/hicolor/32x32/apps/doublecmd.png

rm -vf $HOME/.local/share/icons/hicolor/24x24/apps/doublecmd.png
mkdir -vp $HOME/.local/share/icons/hicolor/24x24/apps/
wget https://icons.iconarchive.com/icons/papirus-team/papirus-apps/24/doublecmd-icon.png -O $HOME/.local/share/icons/hicolor/24x24/apps/doublecmd.png

rm -vf $HOME/.local/share/icons/hicolor/16x16/apps/doublecmd.png
mkdir -vp $HOME/.local/share/icons/hicolor/16x16/apps/
wget https://icons.iconarchive.com/icons/papirus-team/papirus-apps/16/doublecmd-icon.png -O $HOME/.local/share/icons/hicolor/16x16/apps/doublecmd.png

rm -vf $HOME/.local/share/applications/doublecmd.desktop
touch $HOME/.local/share/applications/doublecmd.desktop
echo "[Desktop Entry]
Name=Double Commander
Comment=Double Commander is a cross platform open source file manager with two panels side by side.
Terminal=false
Icon=doublecmd
Exec=$HOME/.local/share/doublecmd/doublecmd.sh
Type=Application
MimeType=inode/directory;
Categories=Utility;FileTools;FileManager;
Keywords=folder;manager;explore;disk;filesystem;orthodox;copy;queue;queuing;operations;" >> $HOME/.local/share/applications/doublecmd.desktop

echo "doublecmd"
rm -vf $HOME/.local/share/doublecmd/doublecmd.inf
rm -vrf $HOME/.config/doublecmd
mkdir -vp $HOME/.config/doublecmd
cp -vfr $HOME/github/nexilis/dotfiles/config/doublecmd $HOME/.config
