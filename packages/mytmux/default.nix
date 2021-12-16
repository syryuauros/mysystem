{ runCommand, makeWrapper, tmux }
:
let

  name    = "myTmux";
  inBin   = "${tmux}/bin/tmux";
  outBin  = "$out/bin/tmux";
  env = { buildInputs = [ makeWrapper ]; };
  cmdHead = "makeWrapper ${inBin} ${outBin} ";
  cmdTail = ''--add-flags "-f ${./tmux.conf}"'';

in runCommand name env (cmdHead + cmdTail)
