#!/usr/bin/env bash

echo "openfortigui"
sudo dnf install qt5-qtbase-devel openssl-devel qtkeychain-qt5-devel -y

# create a symlink to /usr/bin/qmake, if needed
sudo ln -vfs /usr/lib64/qt5/bin/qmake /usr/bin/qmake

git clone --depth 1 https://github.com/theinvisible/openfortigui.git ~/Downloads/openfortigui
cd ~/Downloads/openfortigui && git submodule init && git submodule update
qmake && make -j4
cd ~/

# install it as an application
mkdir -vp $HOME/.local/share/pixmaps
mv -vf $HOME/Downloads/openfortigui/openfortigui/app-entry/openfortigui.png $HOME/.local/share/pixmaps
mv -vf $HOME/Downloads/openfortigui/openfortigui/openfortigui $HOME/.local/bin
rm -vrf $HOME/Downloads/openfortigui

rm -vf $HOME/.local/share/applications/openfortigui.desktop
touch $HOME/.local/share/applications/openfortigui.desktop
echo "[Desktop Entry]
Type=Application
Name=openFortiGUI
Comment=GUI for openfortivpn
Icon=$HOME/.local/share/pixmaps/openfortigui.png
Exec=$HOME/.local/bin/openfortigui
Terminal=false
Categories=Network;Application;" >> $HOME/.local/share/applications/openfortigui.desktop
