{ hvegaSrc } : final: prev: let

  # hvegaSrc = builtins.fetchGit {
  #   url = https://github.com/DougBurke/hvega;
  #   rev = "9f80ed65f127a97f476ecedff9e691337dee1dfc";
  # };

  hvegaDir = hvegaSrc + "/hvega";
  ihaskellvegaDir = hvegaSrc + "/ihaskell-hvega";

  overrides = self: super: {
    hvega          = super.callCabal2nix "hvega" hvegaDir {};
    ihaskell-hvega = super.callCabal2nix "ihaskell-hvega" ihaskellvegaDir {};
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
