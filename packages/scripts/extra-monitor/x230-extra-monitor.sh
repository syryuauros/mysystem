#!/usr/bin/env bash

intern="LVDS-1"
extern="HDMI-1"

case "$1" in
  "disconnect") xrandr --output $extern --off --output $intern --auto ;;
  "extra") xrandr --output $intern --mode 1366x768 --output $extern --primary --mode 1920x1080 --left-of $intern && nitrogen-random ;;
  "duplicate") xrandr --output $intern --mode 1280x720 --output $extern --mode 1280x720 --same-as $intern && nitrogen-random ;;
  *) echo "Unknown Operation" ;;
esac
