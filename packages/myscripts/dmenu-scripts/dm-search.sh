#!/usr/bin/env bash

DMENU="dmenu -i -l 20 -p"

declare -A websearch
websearch[bing]="https://www.bing.com/search?q="
websearch[brave]="https://search.brave.com/search?q="
websearch[duckduckgo]="https://duckduckgo.com/?q="
websearch[google]="https://www.google.com/search?q="
websearch[wikipedia]="https://en.wikipedia.org/w/index.php?search="
websearch[wiktionary]="https://en.wiktionary.org/w/index.php?search="
websearch[reddit]="https://www.reddit.com/search/?q="
websearch[youtube]="https://www.youtube.com/results?search_query="
websearch[amazon]="https://www.amazon.com/s?k="
websearch[archwiki]="https://wiki.archlinux.org/index.php?search="
websearch[github]="https://github.com/search?q="
websearch[gitlab]="https://gitlab.com/search?search="
websearch[googleOpenSource]="https://opensource.google/projects/search?q="
websearch[scholar]="https://scholar.google.com/scholar?q="
websearch[sourceforge]="https://sourceforge.net/directory/?q="
websearch[stackoverflow]="https://stackoverflow.com/search?q="
websearch[libgen]="http://libgen.rs/search.php?req="
websearch[nixosPackages]="https://search.nixos.org/packages?channel=unstable&query="
websearch[nixosOptions]="https://search.nixos.org/options?channel=unstable&query="
websearch[hackage]="https://hackage.haskell.org/packages/search?terms="
websearch[hoogle]="https://hoogle.haskell.org/?hoogle="
websearch[haedosaGitlab]="https://gitlab.com/search?group_id=12624055&search="


declare -a browsers=(
  "brave"
  "firefox"
  "qutebrowser"
)

main() {

  browser=$(printf '%s\n' "${browsers[@]}" | ${DMENU} 'Choose a browser:')
  engine=$(printf '%s\n' "${!websearch[@]}" | ${DMENU} 'Choose search engine:')
  url="${websearch["${engine}"]}"
  query=$(echo "$engine" | ${DMENU} 'Enter search query:')
  $browser "${url}${query}"

}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
