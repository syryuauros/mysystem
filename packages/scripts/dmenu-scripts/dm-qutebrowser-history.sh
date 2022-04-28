#!/usr/bin/env bash

DMBROWSER="qutebrowser"

HISTORY_CACHE_FILE="${HOME}/.cache/qutebrowserhistory"

if [[ ! -f ${HISTORY_CACHE_FILE} ]]; then
  DIR="$(dirname "${HISTORY_CACHE_FILE}")"
  mkdir -p $DIR
fi

SQLITE_SEPARATOR='=%='

# Do query against sqlite3 database expecting two columns (title, url)
function cacheHistory() {
  file=${1}
  query=${2}
  browser=""

  sqlCmd="sqlite3 -separator ${SQLITE_SEPARATOR}"
  printf '%s\n' "$(${sqlCmd} "${file}" "${query}")" | \
  awk -F "${SQLITE_SEPARATOR}" '{print ""$1" - "$NF}' >> "${HISTORY_CACHE_FILE}"
}

# Wrap getting history so we can call it only if the cache is old
generateHistory() {
  # Make sure cache is empty and exists
  echo -n "" > "${HISTORY_CACHE_FILE}"

  QUTEBROWSER_HISTORY="$HOME/.local/share/qutebrowser/history.sqlite"
  if [[ -f ${QUTEBROWSER_HISTORY} ]]; then
    SQL="SELECT title, url FROM history where url like 'http%';"
    cacheHistory "${QUTEBROWSER_HISTORY}" "${SQL}"
  fi

}

generateHistory

histlist=$(cat "${HISTORY_CACHE_FILE}")

choice=$(printf '%s\n' "${histlist}" | dmenu -i -l 20 -p 'Qutebrowser open:' "$@" ) || exit
url=$(echo "${choice}" | awk '{print $NF}') || exit
nohup ${DMBROWSER} "$url" >/dev/null 2>&1 &
