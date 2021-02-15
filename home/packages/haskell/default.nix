{ pkgs
, isLinux ? pkgs.stdenv.isLinux
} :

pkgs.haskellPackages.ghcWithPackages (p: with p; [

    # prelude
    base
    classy-prelude
    rio

    flow
    tuple
    groups
    formatting

    # linter
    hlint

    # dependent / meta
    singletons
    template-haskell

    # string
    bytestring
    base16-bytestring
    stringable

    # shell
    turtle

    # test
    hspec
    QuickCheck

    # json
    aeson
    aeson-qq
    aeson-pretty
    raw-strings-qq

    # lens
    lens
    microlens
    microlens-th
    lens-aeson

    # sever
    servant
    servant-server
    wai
    warp

    # network
    http-client
    http-media

    # parser
    optparse-applicative
    megaparsec

    # random number
    random
    # random'
    splitmix
    MonadRandom
    # MonadRandom'

    # persional
    myFlow
    myPlot
    power
    picture

    # numerical
    hmatrix
    foldl

    # crypto
    cryptohash-sha256

    # visualization
    hvega

    # builder
    cabal-install
    stack
    shake
    hpack
    # hpack-convert # failed to build [2021-01-29 Fri]

    # transformer
    mtl

    # exception
    safe-exceptions

    # regex
    pcre-heavy

    # for lsp
    ghcide
    haskell-language-server
  ] ++ (lib.optionals (isLinux)
  [
    xmonad
    xmonad-contrib
    xmonad-extras
    xmobar

    ihaskell
    ihaskell-hvega
    ihaskell-charts
    ihaskell-plot
    ihaskell-aeson
  ]))
