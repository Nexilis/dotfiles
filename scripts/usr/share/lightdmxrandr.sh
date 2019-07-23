#!/usr/bin/env bash

# Docking station:
# - DP-1-3-1
# - DP-1-3-2
#
# Laptop monitor:
# - eDP-1-1, eg. xrandr --output eDP-1-1 --primary --mode 1600x900
#
# Remaining connections:
# - DP-1-1
# - DP-1-2
# - DP-1-3
# - HDMI-1-1 <-- normal cable
# - HDMI-1-2
# - HDMI-1-3


dp132=$(xrandr -q | grep 'DP-1-3-2 connected')   # left docking station monitor
dp131=$(xrandr -q | grep 'DP-1-3-1 connected')   # right docking station monitor
hdmi11=$(xrandr -q | grep 'HDMI-1-1 connected')  # hdmi connection

if [[ -n "$dp132" ]] && [[ -n "$dp131" ]]; then       # if DP-1-3-1 and DP-1-3-2
  echo "Enabling docking station monitors and disabling laptop monitor"
  echo $(xrandr --output DP-1-3-2 --primary --auto --output DP-1-3-1 --auto --right-of DP-1-3-2 --output eDP-1-1 --off)
elif [[ -n "$hdmi11" ]]; then
  echo "Enabling hdmi monitor as primary and laptop monitor"
  echo $(xrandr --output HDMI-1-1 --primary --auto --output eDP-1-1 --mode 1600x900 --left-of HDMI-1-1)
else
  echo "Enabling laptop only in 1600x900 resolution"
  echo $(xrandr --output eDP-1-1 --primary --mode 1600x900)
fi
