{ runCommand
, makeWrapper
, betterlockscreen
, mywallpapers-1366
}:

let

  bls = "${betterlockscreen}/bin/betterlockscreen";
  mls = "$out/bin/mylockscreen";

in runCommand "mylockscreen"  { buildInputs = [ makeWrapper ]; } ''
  makeWrapper ${bls} ${mls}-1366 --add-flags "-u ${mywallpapers-1366} -l dimblur"
''
