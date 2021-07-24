{
  description = "My haskell with batteries";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils/master";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };

    ihaskellSrc = { url = "github:gibiansky/IHaskell"; flake = false; };
    hvegaSrc = { url = "github:DougBurke/hvega"; flake = false; };

    myflow.url = "git+ssh://git@gitlab.com/jjdosa/myflow.git";
    myplot.url = "git+ssh://git@gitlab.com/jjdosa/myplot.git";
    myhmatrix.url = "git+ssh://git@gitlab.com/jjdosa/myhmatrix.git";

  };

  outputs =
    inputs@{ self, nixpkgs, flake-compat, flake-utils
           , ihaskellSrc, hvegaSrc
           , myflow, myplot, myhmatrix, ... }:
    {

      overlays = [
        myflow.overlay
        myplot.overlay
        myhmatrix.overlay
        (import ./ihaskell-overlay.nix { inherit ihaskellSrc; })
        (import ./hvega-overlay.nix { inherit hvegaSrc; })
        (import ./overlay.nix)
      ];

      overlay = nixpkgs.lib.composeManyExtensions self.overlays;

    }
    //

    flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = self.overlays;
        };

      in
      {

        defaultPackage = pkgs.myhaskell;

        defaultApp = {
          type = "app";
          program = "${pkgs.myhaskell}/bin/ghci";
        };

      }
    );

}
