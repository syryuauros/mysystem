{ runCommand }:

runCommand "myfonts" {} ''
  install -m444 -Dt $out/share/fonts/myfonts ${./fonts}/*/*.ttf
  install -m444 -Dt $out/share/fonts/myfonts ${./fonts}/*/*.otf

''
