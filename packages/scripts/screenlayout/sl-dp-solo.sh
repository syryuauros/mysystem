#!/usr/bin/env bash
read -r dp1 < <(xrandr | awk '/connected/&&!/disconnected/{print $1}' | head -1)

xrandr --output $dp1 --primary --mode 1920x1200 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output DP-2 --off --output HDMI-3 --off --output DP-3 --off --output DP-4 --off
