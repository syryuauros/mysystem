#!/bin/sh
edp="${1:eDP-1}"
hdmi="${2:HDMI-1}"
xrandr --output $edp --mode 1920x1200 --pos 320x1440 --rotate normal --output $hdmi --primary --mode 2560x1440 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-2 --off --output DP-2 --off --output HDMI-3 --off --output DP-3 --off --output DP-4 --off
