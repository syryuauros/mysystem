{

  description = "betterlockscreen with my wallpapers";

  inputs = {
    nixpkgs.url           = "github:nixos/nixpkgs/nixos-unstable";
    stable.url            = "github:nixos/nixpkgs/nixos-20.09";
    flake-utils.url       = "github:numtide/flake-utils";
    mywallpapers-1366.url = "git+ssh://git@gitlab.com/jjdosa/mywallpapers-1366.git";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, mywallpapers-1366, ... }: {

    overlay = import ./overlay.nix;

  } //
  flake-utils.lib.eachDefaultSystem (system:

    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ mywallpapers-1366.overlay
                     self.overlay ];
      };
    in {

      defaultPackage = pkgs.mynitrogen;

    }

  );

}
