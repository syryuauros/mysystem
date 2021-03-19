{ runCommand }: let

  name = "extra-monitor";

in runCommand name { buidInputs = [ ]; } ''
  mkdir -p $out/bin
  outfile=$out/bin/${name}.sh
  cp ${./. + "/${name}.sh"} $outfile
  patchShebangs $outfile
''
