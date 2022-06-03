#!/usr/bin/env bash

DMENU="dmenu -i -l 20 -p"

declare -a bookmarks=(
 "https://daum.net"
 "https://gitlab.com/haedosa"
 "https://gitlab.com/haedosa/fmmdosa"
 "https://gitlab.com/haedosa/mldosa"
 "https://gitlab.com/haedosa/emaster"
 "https://gitlab.com/haedosa/fitdosa"
)

declare -a browsers=(
  "firefox"
  "qutebrowser"
  "brave"
)

main() {

  browser=$(printf '%s\n' "${browsers[@]}" | ${DMENU} 'Choose a browser:')
  url=$(printf '%s\n' "${bookmarks[@]}" | ${DMENU} 'Choose a url:')
  ${browser} "${url}"

}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
