#!/bin/bash

# Exec=env LD_PRELOAD=/usr/lib/libcurl.so.3 /usr/bin/slack %U

APP="slack"
ICON="/usr/share/pixmaps/slack.png"
APP_LOAD_TIME_IN_SECONDS=7

change-app-panel-icon() {
    sleep $APP_LOAD_TIME_IN_SECONDS
    WINDOW_ID=$(wmctrl -l | grep -i " $APP" | cut -f1 -d " ")
    wmctrl -i -r $WINDOW_ID
    xseticon -id "$WINDOW_ID" "$ICON"
}

$APP 2> /dev/null :1 & change-app-panel-icon