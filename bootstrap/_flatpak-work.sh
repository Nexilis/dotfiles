#!/usr/bin/env bash

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub rest.insomnia.Insomnia -y
flatpak install flathub com.slack.Slack -y
flatpak install flathub us.zoom.Zoom -y
flatpak install flathub org.gaphor.Gaphor -y
flatpak install flathub org.wireshark.Wireshark -y
flatpak install flathub com.uploadedlobster.peek -y
