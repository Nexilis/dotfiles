#!/bin/sh
# Switch Ghostty between the dark base theme and the light override, then reload.
# The config loads theme-override optionally; its presence means light.
set -eu

override="$HOME/.config/ghostty/theme-override"

if [ -f "$override" ]; then
    rm "$override"
    echo "ghostty: dark"
else
    echo 'theme = Modus Operandi' > "$override"
    echo "ghostty: light"
fi

osascript -e 'tell application "Ghostty"
    if (count of windows) > 0 then perform action "reload_config" on focused terminal of selected tab of front window
end tell' >/dev/null
