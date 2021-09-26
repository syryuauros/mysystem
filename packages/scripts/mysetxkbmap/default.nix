{ runCommand }: let

  name = "mysetxkbmap";

in runCommand name { buidInputs = [ ]; } ''
  outdir=$out/bin
  mkdir -p $outdir
  cp ${./.}/* $outdir
  for i in $outdir/*.sh;
  do
    patchShebangs $i
  done
''
