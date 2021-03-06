{ runCommand }:

runCommand "restart-xmonad" { buidInputs = [ ]; } ''
  mkdir -p $out/bin
  cp ${./restart-xmonad.sh} $out/bin/restart-xmonad.sh
  patchShebangs $out/bin/restart-xmonad.sh
''
