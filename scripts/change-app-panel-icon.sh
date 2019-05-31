#!/bin/bash

change-app-panel-icon() {
  echo "waiting for window"
  for i in {1..10}; do
    echo "second $i"
    sleep 1
    WINDOW_ID=$(wmctrl -l | grep -i " $APP" | cut -f1 -d " ")
    if [[ "$WINDOW_ID" != "" ]]; then
      echo "setting icon for $WINDOW_ID"
      wmctrl -i -r $WINDOW_ID
      xseticon -id "$WINDOW_ID" "$ICON"
    fi
  done
  echo "done"
}
