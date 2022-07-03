final: prev: with final;
let

  # In case needed
  noCheck = p: final.haskell.lib.dontCheck p;
  noHaddock = p: final.haskell.lib.dontHaddock p;
  fast = p: noHaddock (noCheck p);

in {

  myhaskellPackageSelectFrom = rec {

    default = p: with p; [
      base
      classy-prelude
      rio
      tuple
      groups
      formatting
      singletons
      template-haskell
      bytestring
      base16-bytestring
      stringable
      turtle
      hspec
      QuickCheck
      optparse-applicative
      megaparsec
      hmatrix
      # myhmatrix
      foldl
      cryptohash-sha256
      mtl
      safe-exceptions
      pcre-heavy
    ];

    random = p: with p; [
      random
      splitmix
      MonadRandom
    ];

    json = p: with p; [
      aeson
      aeson-qq
      aeson-pretty
      raw-strings-qq
      lens-aeson
    ];

    lens = p: with p; [
      lens
      microlens
      microlens-th
    ];

    web = p: with p; [
      servant
      servant-server
      wai
      warp
      http-client
      http-media
    ];

    develop = p: with p; [
      hlint
      haskell-language-server
      cabal-install
      stack
      shake
      hpack
    ];

    xmonad-siblings = p: with p; [
      xmonad
      xmonad-contrib
      xmonad-extras
    ];

    ihaskell-siblings = p: with p; [
      hvega
      ihaskell
      ihaskell-hvega
      ihaskell-charts
      ihaskell-plot
      ihaskell-aeson
    ];

    common = p:
      (  (default p)
      ++ (random p)
      ++ (json p)
      ++ (lens p)
      ++ (web p)
      ++ (develop p)
      );

    linux-only = p:
      (  (ihaskell-siblings p)
      ++ (xmonad-siblings p)
      );

    full = p:
      (  (common p)
      ++ (linux-only p)
      );

  };


  myhaskell-common = haskellPackages.ghcWithPackages (p:
    with myhaskellPackageSelectFrom;
    (common p)
  );

  myhaskell-full = haskellPackages.ghcWithPackages (p:
    myhaskellPackageSelectFrom.full p
  );

  myhaskell-xmonad = haskellPackages.ghcWithPackages (p:
    with myhaskellPackageSelectFrom;
    (xmonad-siblings p) ++
    [ p.haskell-language-server ]
  );

  myhaskell = if stdenv.isLinux
                then myhaskell-full
                else myhaskell-common;

}
