{ pkgs ? import ./nixpkgs.nix }: with pkgs;

mkShell {
  buildInputs =  haskellPackages.myflow.env.nativeBuildInputs ++ (with haskellPackages; [
    (ghcWithPackages (p: with p; [
      haskell-language-server ]))
    cabal-install
  ]);
}
