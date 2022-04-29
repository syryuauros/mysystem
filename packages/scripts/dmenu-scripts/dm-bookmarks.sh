#!/usr/bin/env bash

DMENU="dmenu -i -l 20 -p"
DMBROWSER="qutebrowser"

declare -a bookmarks=(
 "https://daum.net"
 "https://gitlab.com/haedosa"
 "https://gitlab.com/haedosa/fmmdosa"
 "https://gitlab.com/haedosa/mldosa"
 "https://gitlab.com/haedosa/emaster"
 "https://gitlab.com/haedosa/fitdosa"
)



main() {

  url=$(printf '%s\n' "${bookmarks[@]}" | sort | ${DMENU} 'Choose a url:' "$@") || exit 1
  ${DMBROWSER} "${url}"

}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
