{ runCommand }: let

  name = "trim-generations";

in runCommand name { buidInputs = [ ]; } ''
  mkdir -p $out/bin
  outfile=$out/bin/${name}
  cp ${./. + "/${name}.sh"} $outfile
  patchShebangs $outfile
  chmod +x $outfile
''
