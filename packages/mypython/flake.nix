{
  description = "My python with batteries";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils/master";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };

  };

  outputs =
    inputs@{ self, nixpkgs, flake-compat, flake-utils, ... }:
    {
      overlays = [ (import ./overlay.nix) ];
      overlay = nixpkgs.lib.composeManyExtensions self.overlays;

    } // flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg)
              [ "cudatoolkit" ];
          };
          overlays = self.overlays;
        };

      in
      {

        defaultPackage = pkgs.mypython;

        packages = {
          common    = pkgs.mypython-common;
          full      = pkgs.mypython-full;
          full-cuda = pkgs.mypython-full-cuda;
        };

        defaultApp = {
          type = "app";
          program = "${pkgs.mypython}/bin/python3";
        };

      }
    );

}
