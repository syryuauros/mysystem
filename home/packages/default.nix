external: self: super: with self;
{

  # myEmacs = callPackage ./emacs {
  #   emacs = if stdenv.isDarwin
  #             then emacsMacport
  #             else emacs;
  # };


  myHunspell = let
    dicts = with hunspellDicts; [ en_US-large ];
  in hunspellWithDicts dicts;


  myVim = calPackage ./neovim {};


  haskellPackages = super.haskellPackages.override (old: {
    overrides =
      lib.composeExtensions
        (old.overrides or (_: _: {}))
        myHaskellOverrides;
  });


  myHaskellOverrides = import ./haskell/packages
    (if external ? haskellPackages then external.haskellPackages else {});


  myHaskell = callPackage ./haskell {};


  haskellForXmonad = pkgs.haskellPackages.ghcWithPackages (p: with P; [
    xmonad
    xmonad-contrib
    xmonad-extras
    dbus
    monad-logger
    haskell-language-server
  ]);


}
