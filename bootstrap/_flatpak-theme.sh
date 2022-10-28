#!/usr/bin/env bash

flatpak install org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark
flatpak install flathub com.github.GradienceTeam.Gradience
sudo flatpak override --filesystem=xdg-config/gtk-3.0
sudo flatpak override --filesystem=xdg-config/gtk-4.0

echo "lassekongo83/adw-gtk3"
wget https://github.com/lassekongo83/adw-gtk3/releases/download/v4.0/adw-gtk3v4-0.tar.xz -O $HOME/Downloads/adw-gtk.tar.xz
unxz -vf $HOME/Downloads/adw-gtk.tar.xz
tar -xvf $HOME/Downloads/adw-gtk.tar -C $HOME/Downloads
mkdir -vp $HOME/.local/share/themes
rm -vrf $HOME/.local/share/themes/adw-gtk*
mv -vf $HOME/Downloads/adw-gtk3 $HOME/.local/share/themes
mv -vf $HOME/Downloads/adw-gtk3-dark $HOME/.local/share/themes
rm -vf $HOME/Downloads/adw-gtk.*

