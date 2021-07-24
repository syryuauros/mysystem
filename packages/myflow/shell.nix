{ pkgs ? import ./nixpkgs.nix }: with pkgs;

mkShell {
  buildInputs = with haskellPackages; [
                  (ghcWithPackages (p: with p; [
                    myflow
                  ]))
                  cabal-install
                ];
}
