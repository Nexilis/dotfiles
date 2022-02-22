#!/usr/bin/env bash

# flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub com.valvesoftware.Steam -y
flatpak install flathub com.mojang.Minecraft -y
flatpak install flathub org.wesnoth.Wesnoth -y
flatpak install flathub org.openttd.OpenTTD -y
flatpak install flathub org.develz.Crawl -y
flatpak install flathub org.gnome.Mines -y

flatpak install flathub io.github.antimicrox.antimicrox -y
