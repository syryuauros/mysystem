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
        myflow = self.callPackage ./deriv.nix {};
      });
  });


  ghcWithMyflow = selectFrom:
    haskellPackages.ghcWithPackages
      (p : ([ p.myflow ] ++ selectFrom p));

}
