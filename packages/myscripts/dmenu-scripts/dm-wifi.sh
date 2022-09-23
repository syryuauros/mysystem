#!/usr/bin/env bash

DMENU="dmenu -i -l 20 -p"

main() {

  bssid=$(nmcli device wifi list | sed -n '1!p' | cut -b 9- | ${DMENU} "Select Wifi  :" | cut -d' ' -f1)
  pass=$(echo "" | ${DMENU} "Enter Password  :")
  msg=$([ -n "$pass" ] && nmcli device wifi connect "$bssid" password "$pass" || nmcli device wifi connect "$bssid")
  echo $msg
  if [[ "${msg}" =~ "successfully" ]]; then
    dunstify "Your internet is working :)"
  else
    dunstify "Your internet is not working :("
  fi

}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
