{ runCommand }: let

  name = "extra-monitor";

in runCommand name { buidInputs = [ ]; } ''
  outdir=$out/bin
  mkdir -p $outdir
  # outfile=$out/bin/${name}.sh
  # cp ${./. + "/${name}.sh"} $outfile
  cp ${./.}/* $outdir
  for i in $outdir/*.sh;
  do
    patchShebangs $i
  done
''
