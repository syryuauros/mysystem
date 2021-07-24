{
  description = "Emacs tailored to my liking";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils/master";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    emacs-overlay.url = "github:nix-community/emacs-overlay";

  };

  outputs =
    inputs@{ self, nixpkgs, flake-compat, flake-utils, emacs-overlay, ... }:
    {
      overlays = [ emacs-overlay.overlay
                   (import ./overlay.nix inputs) ];
      overlay = nixpkgs.lib.composeManyExtensions self.overlays;

    } // flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = import nixpkgs {
          inherit system;
          config = {};
          overlays = [ self.overlay ];
        };
      in
      {
        defaultPackage = pkgs.myemacs;
        defaultApp = {
          type = "app";
          program = "${pkgs.myemacs}/bin/emacs";
        };
        apps = {
          myemacs = {
            type = "app";
            program = "${pkgs.mymyemacs}/bin/myemacs";
          };
        };
      }
    );

}
