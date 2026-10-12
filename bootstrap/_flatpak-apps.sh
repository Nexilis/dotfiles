#!/usr/bin/env bash

# PdfCraft is not on Flathub; its GitHub release ships a flatpak bundle.
PDFCRAFT=0.6.0
wget https://github.com/storytold/pdfcraft/releases/download/v$PDFCRAFT/pdfcraft-$PDFCRAFT-linux-x86_64.flatpak -O $HOME/Downloads/pdfcraft.flatpak
flatpak install --bundle $HOME/Downloads/pdfcraft.flatpak -y
rm -vf $HOME/Downloads/pdfcraft.flatpak
flatpak install flathub org.libreoffice.LibreOffice -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub org.gimp.GIMP -y
flatpak install flathub com.github.PintaProject.Pinta -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub org.gnome.TextEditor -y
flatpak install flathub org.gnome.meld -y
flatpak install flathub io.github.shiftey.Desktop -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub de.haeckerfelix.Fragments -y
flatpak install flathub fr.romainvigier.MetadataCleaner -y
flatpak install flathub org.videolan.VLC -y
flatpak install flathub com.github.liferooter.textpieces -y
flatpak install flathub de.haeckerfelix.Shortwave -y
flatpak install flathub it.mijorus.smile -y
flatpak install flathub com.github.phase1geo.minder -y

flatpak install flathub org.mozilla.firefox -y
flatpak install com.github.Eloston.UngoogledChromium -y
