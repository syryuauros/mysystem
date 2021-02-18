external: self: super: with self;
{

  haskellForXmonad = pkgs.haskellPackages.ghcWithPackages (p: with P; [
    xmonad
    xmonad-contrib
    xmonad-extras
    dbus
    monad-logger
    haskell-language-server
  ]);


}
