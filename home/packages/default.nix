{ pkgs, ... }: with pkgs;
{

  myEmacs = callPackage ./emacs {
    emacs = if stdenv.isDarwin
              then emacsMacport
              else emacs;
  };


  myHunspell = let
    dicts = with hunspellDicts; [ en_US-large ];
  in hunspellWithDicts dicts;


}
