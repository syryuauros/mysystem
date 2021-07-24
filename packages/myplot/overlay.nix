final: prev:
let
  # In case needed
  noCheck = p: final.haskell.lib.dontCheck p;
  noHaddock = p: final.haskell.lib.dontHaddock p;
  fast = p: noHaddock (noCheck p);
in
with final; {


  haskellPackages = prev.haskellPackages.override (old: {
    overrides = lib.composeExtensions
      (old.overrides or (_: _: {}))
      (self: super: {
        myplot = self.callPackage ./default.nix {};
      });
  });


  ghcWithMyplot = selectFrom:
    haskellPackages.ghcWithPackages
      (p : ([ p.myplot ] ++ selectFrom p));

  # uncomment if this is a executable
  # executables = haskell.lib.justStaticExecutables haskellPackages.myflow;

}
