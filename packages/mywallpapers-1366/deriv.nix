{ runCommand }:

runCommand "mywallpapers-1366" {} ''
  mkdir -p $out
  cp ${./images}/* $out
''
