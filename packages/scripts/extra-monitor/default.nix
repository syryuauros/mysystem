{ runCommand }: let

  name = "extra-monitor";

in runCommand name { buidInputs = [ ]; } ''
  outdir=$out/bin
  mkdir -p $outdir
  cp ${./.}/*.sh $outdir
  for i in $outdir/*.sh;
  do
    patchShebangs $i
  done
''
