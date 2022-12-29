{ runCommand, makeWrapper, tmux }:

runCommand "mytmux" { buildInputs = [ makeWrapper ]; } ''
  makeWrapper ${tmux}/bin/tmux $out/bin/tmux --add-flags "-f ${./tmux.conf}"
''
