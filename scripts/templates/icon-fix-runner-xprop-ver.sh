#!/bin/bash

APP="simplenote"
ICON="/usr/share/icons/hicolor/512x512/apps/simplenote.png"
APP_LOAD_TIME_IN_SECONDS=1

change-app-panel-icon() {
    sleep $APP_LOAD_TIME_IN_SECONDS
    WINDOW_ID=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)"| awk 'match($0,/[0-9][a-z][0-9]+/) {print substr($0,RSTART,RLENGTH)}' )
    xseticon -id "$WINDOW_ID" "$ICON"
}

$APP 2> /dev/null :1 & change-app-panel-icon