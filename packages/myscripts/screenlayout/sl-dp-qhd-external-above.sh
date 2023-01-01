#!/usr/bin/env bash
read -r dp1 dp2 < <(xrandr | awk '/connected/&&!/disconnected/{print $1}' | tr '\n' ' ')

xrandr --output $dp1 --mode 1920x1200 --pos 320x1440 --rotate normal --output $dp2 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-2 --off --output DP-2 --off --output HDMI-3 --off --output DP-3 --off --output DP-4 --off
