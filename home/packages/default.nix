{ pkgs, ... }:
{

  myEmacs = pkgs.callPackage ./emacs {
    emacs = if pkgs.stdenv.isDarwin
              then emacsMacport
              else emacs;
  };

}
