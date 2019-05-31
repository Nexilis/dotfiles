#!/bin/bash

. ~/dotfiles/scripts/change-app-panel-icon.sh

APP="insomnia"
ICON="/usr/share/icons/hicolor/0x0/apps/insomnia.png"

$APP 2> /dev/null :1 & change-app-panel-icon
