{ runCommand }: runCommand "dmenu-scripts" { buidInputs = [ ]; } ''
  mkdir -p $out/bin
  cp ${./.}/*.sh $out/bin
  for f in $out/bin/*.sh;
  do
    patchShebangs $f
  done
''

# { runCommand }: let

#   name = "mysetxkbmap";

# in runCommand name { buidInputs = [ ]; } ''
#   outdir=$out/bin
#   mkdir -p $outdir
#   cp ${./.}/* $outdir
#   for i in $outdir/*.sh;
#   do
#     patchShebangs $i
#   done
