{ runCommand
, makeWrapper
, nitrogen
, mywallpapers-1366
}:

let

  bin = "${nitrogen}/bin/nitrogen";
  out = "$out/bin/nitrogen";

in runCommand "mynitrogen"  { buildInputs = [ makeWrapper ]; } ''
  makeWrapper ${bin} ${out}
  makeWrapper ${bin} ${out}-choose --add-flags "${mywallpapers-1366}"
  makeWrapper ${bin} ${out}-restore --add-flags "--restore"
  makeWrapper ${bin} ${out}-random --add-flags "--set-zoom-fill --random ${mywallpapers-1366} --save"
''
