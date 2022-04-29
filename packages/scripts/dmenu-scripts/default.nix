{ runCommand }: runCommand "dmenu-scripts" { buidInputs = [ ]; } ''
  mkdir -p $out/bin
  cp ${./.}/*.sh $out/bin
  for f in $out/bin/*.sh;
  do
    patchShebangs $f
  done
''
