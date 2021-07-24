# As of Feb 22 2021, the upstream ihaskell stuffs are broken. This overlay
# patches up the brokage. I used to fetch the content through 'jupyterWith' as
# below. But in order to take an advantage of flake, I embed it direclty so that
# the external dependency is controlled by flake.
#
#   jupyterWithPath = builtins.fetchGit {
#     url = https://github.com/tweag/jupyterWith;
#     rev = "35eb565c6d00f3c61ef5e74e7e41870cfa3926f7";
#   };
#
#   jupyterHaskellOverlay
#     = import (jupyterWithPath + "/nix/haskell-overlay.nix");

{ ihaskellSrc }: final: prev:

let
  # ihaskellSrc = prev.fetchFromGitHub {
  #   owner = "gibiansky";
  #   repo = "IHaskell";
  #   rev = "ef698157f44960566687a308e3455b5ba031eb43";
  #   sha256 = "1y054m6fndsjiypsjgmipmhbpp3spj3fw1x53z4qrixkl43mz3mi";
  # };
  overrides = self: hspkgs:
    let
      callDisplayPackage = name:
        hspkgs.callCabal2nix
          "ihaskell-${name}"
          "${ihaskellSrc}/ihaskell-display/ihaskell-${name}"
          {};
      dontCheck = prev.haskell.lib.dontCheck;
      dontHaddock = prev.haskell.lib.dontHaddock;
    in
    {
      ihaskell = prev.haskell.lib.overrideCabal
        (hspkgs.callCabal2nix "ihaskell" ihaskellSrc {})
        (_drv: {
          preCheck = ''
            export HOME=$(${final.coreutils}/bin/mktemp -d)
            export PATH=$PWD/dist/build/ihaskell:$PATH
            export GHC_PACKAGE_PATH=$PWD/dist/package.conf.inplace/:$GHC_PACKAGE_PATH
          '';
          configureFlags = (_drv.configureFlags or []) ++ [
            # otherwise the tests are agonisingly slow and the kernel times out
            "--enable-executable-dynamic"
          ];
          doHaddock = false;
         });
      ghc-parser = hspkgs.callCabal2nix "ghc-parser" "${ihaskellSrc}/ghc-parser" {};
      ipython-kernel = hspkgs.callCabal2nix "ipython-kernel" "${ihaskellSrc}/ipython-kernel" {};
      ihaskell-aeson = callDisplayPackage "aeson";
      ihaskell-blaze = callDisplayPackage "blaze";
      ihaskell-charts = callDisplayPackage "charts";
      ihaskell-diagrams = callDisplayPackage "diagrams";
      ihaskell-gnuplot = callDisplayPackage "gnuplot";
      ihaskell-graphviz = callDisplayPackage "graphviz";
      ihaskell-hatex = callDisplayPackage "hatex";
      ihaskell-juicypixels = callDisplayPackage "juicypixels";
      ihaskell-magic = callDisplayPackage "magic";
      ihaskell-plot = callDisplayPackage "plot";
      ihaskell-rlangqq = callDisplayPackage "rlangqq";
      ihaskell-static-canvas = callDisplayPackage "static-canvas";
      ihaskell-widgets = callDisplayPackage "widgets";

      # Marked as broken in this version of Nixpkgs.
      #chell = hspkgs.callHackage "chell" "0.4.0.2" {};
      #patience = hspkgs.callHackage "patience" "0.1.1" {};

      # Tests not passing.
      #Diff = dontCheck hspkgs.Diff;
      #zeromq4-haskell = dontCheck hspkgs.zeromq4-haskell;

    };
in

{
  haskellPackages = prev.haskellPackages.override (old: {
    overrides =
      prev.lib.composeExtensions
        (old.overrides or (_: _: {}))
        overrides;
  });
}
