{ runCommand }:

runCommand "extra-xmonad" { buidInputs = [ ]; } ''
  mkdir -p $out/bin
  cp ${./extra-monitor.sh} $out/bin/extra-monitor.sh
  patchShebangs $out/bin/extra-monitor.sh
''
