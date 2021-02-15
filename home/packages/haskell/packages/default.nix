self: super: with self; {

  ghc = super.ghc // { withPackages = super.ghc.withHoogle; };
  ghcWithPackages = self.ghc.withPackages;

# *** Persional Packages
  # callPackageGit = repo: args:
  #   callPackage (import "${builtins.fetchGit repo}/src") args;

  # callPackageGitlab = name: args:
  #   callPackageGit { url = gitlabUrl name; } args;

  # power   = callPackageGitlab "power.hlib" {};
  # picture = callPackageGitlab "picture" {};
  # myFlow  = callPackageGitlab "myflow" {};
  # myPlot  = callPackageGitlab "myplot" {};

# *** Customized Packages
  # random' = hsuper.random_1_2_0;
  # MonadRandom' = hsuper.MonadRandom.overrideScope
  #   (self: super: { random = random'; });

# *** hvega and its siblings
  hvegaSource = builtins.fetchGit {
    url = https://github.com/DougBurke/hvega;
  };

  # hvegaDir = hvegaSource + "/hvega";
  # ihaskellvegaDir = hvegaSource + "/ihaskell-hvega";

  # hvega          = callCabal2nix "hvega" hvegaDir {};
  # ihaskell-hvega = callCabal2nix "ihaskell-hvega" ihaskellvegaDir {};

# *** Bypass brokens
  # bypassBroken
  #   = pkg: pkg.overrideAttrs
  #           (attrs: { meta = attrs.meta // { broken = false; }; });

  # hpack-convert  = bypassBroken hsuper.hpack-convert;
    #^ failed to build

  # For ihaksell stuffs to work =jupyterHaskellOverlay= has to
  # be included. Once that is included, these bypasses are
  # unnecessary.
  # ihaskell        = bypassBroken hsuper.ihaskell;
  # ihaskell-charts = bypassBroken hsuper.ihaskell-charts;
  # ihaskell-plot   = bypassBroken hsuper.ihaskell-plot;
  # ihaskell-aeson  = bypassBroken hsuper.ihaskell-aeson;
  # ihaskell-hvega = bypassBroken hsuper.ihaskell-hvega;
  # plot           = bypassBroken hsuper.plot;

};
