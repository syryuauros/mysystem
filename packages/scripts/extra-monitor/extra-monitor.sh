#!/bin/sh

idis="${2:-eDP}"         # LVDS-1 for x230; eDP for l14
ires="${3:-1920x1080}"   # 1336x768 for x230; 1920x1080 for l14
edis="${4:-HDMI-A-0}"     # HDMI-1 for x230; HDMI-A-0 for l14
eres="${5:-2560x1440}"
ipos="${6:-280x1440}"

case "$1" in
  "disconnect") xrandr --output $idis --auto --output $edis --off ;;
  "extra") xrandr --output $idis --mode $ires --pos $ipos --rotate normal --output $edis --primary --mode $eres --pos 0x0 --rotate normal;;
  "duplicate") xrandr --output $idis --mode $ires --output $edis --mode $ires --same-as $idis ;;
  *) echo "Unknown Operations" ;;
esac
