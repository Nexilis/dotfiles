#!/bin/bash

. ~/dotfiles/scripts/change-app-panel-icon.sh

APP="slack"
ICON="/usr/share/pixmaps/slack.png"

$APP 2> /dev/null :1 & change-app-panel-icon
