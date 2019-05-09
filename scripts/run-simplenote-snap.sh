#!/bin/bash

# Exec="/opt/Simplenote/simplenote" %U

APP="simplenote"
ICON="/snap/simplenote/94/usr/share/icons/hicolor/256x256/apps/simplenote.png"
APP_LOAD_TIME_IN_SECONDS=2

change-app-panel-icon() {
    sleep $APP_LOAD_TIME_IN_SECONDS
    WINDOW_ID=$(wmctrl -l | grep -i " $APP" | cut -f1 -d " ")
    wmctrl -i -r $WINDOW_ID
    xseticon -id "$WINDOW_ID" "$ICON"
}

$APP 2> /dev/null :1 & change-app-panel-icon