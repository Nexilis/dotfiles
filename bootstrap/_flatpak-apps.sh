#!/usr/bin/env bash

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub org.libreoffice.LibreOffice -y
flatpak install flathub net.cozic.joplin_desktop -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub com.bitwarden.desktop -y
flatpak install flathub org.gimp.GIMP -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub org.gnome.meld -y
flatpak install flathub org.gnome.gitg -y
flatpak install flathub org.gnome.Extensions -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub com.sindresorhus.Caprine -y
flatpak install flathub de.haeckerfelix.Fragments -y
flatpak install flathub fr.romainvigier.MetadataCleaner -y
