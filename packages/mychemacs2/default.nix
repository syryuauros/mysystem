{ inputs, runCommand }: let

  name = "mychemacs2";

in runCommand name { } ''
  mkdir -p $out
  cp ${inputs.chemacs2}/* $out
  cp ${./emacs-profiles.el} $out/emacs-profiles.el
''
