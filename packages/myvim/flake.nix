{
  description = "haskell library from left to right application style";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils/master";

  };

  outputs =
    inputs@{ self, nixpkgs, flake-utils, ... }:
    {
      overlay = import ./overlay.nix;
    }
    //

    flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = import nixpkgs {

          inherit system;
          config = {};
          overlays = [ self.overlay ];

        };

      in
      {

        defaultPackage = pkgs.myvim;

        defaultApp = {
          type = "app";
          program = "${pkgs.myvim}/bin/nvim";
        };

      }
    );

}
