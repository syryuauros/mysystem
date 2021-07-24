final: prev: with final; {

  myemacs = callPackage ./default.nix {
    emacs = if stdenv.isDarwin
              then emacsMacport
              # else emacsGcc;
              else emacs;
  };

  # this version changes the executable names
  # emacs -> myemacs; emacsclient -> myemacsclient
  mymyemacs = runCommand "mymyemacs" { buildInputs = [ makeWrapper ]; } ''
    mkdir -p $out/bin
    ln -s ${myemacs}/bin/emacs $out/bin/myemacs
    ln -s ${myemacs}/bin/emacsclient $out/bin/myemacsclient
    ln -s ${myemacs}/bin/emacs $out/bin/me
    ln -s ${myemacs}/bin/emacsclient $out/bin/mec
  '';

}
