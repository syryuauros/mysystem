{
  description = "My jupyter with python and haskell";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils/master";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };

    # jupyterWith = { url = "github:tweag/jupyterWith"; flake = false; };
    # jupyterWith = { url = "git+file:///home/jj/jupyterWith"; flake = false; };
    jupyter_contrib_core = { url = "github:Jupyter-contrib/jupyter_contrib_core"; flake = false; };
    jupyter_nbextensions_configurator = { url = "github:Jupyter-contrib/jupyter_nbextensions_configurator"; flake = false; };

    mypython.url  = "git+ssh://git@gitlab.com/jjdosa/mypython.git";
    myhaskell.url = "git+ssh://git@gitlab.com/jjdosa/myhaskell.git";

  };

  outputs =
    inputs@{ self, nixpkgs, flake-compat, flake-utils
           , jupyter_contrib_core, jupyter_nbextensions_configurator
           , myhaskell, mypython, ... }:
    {

      overlays = [
        myhaskell.overlay
        mypython.overlay
        (import ./jupyter-overlay.nix {
          inherit
            jupyter_contrib_core
            jupyter_nbextensions_configurator; })
        (import ./overlay.nix)
      ];

      overlay = nixpkgs.lib.composeManyExtensions self.overlays;

    }
    //

    flake-utils.lib.eachDefaultSystem (system:

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

        defaultPackage = pkgs.myjupyter;

        defaultApp = {
          type = "app";
          program = "${pkgs.myjupyter}/bin/jupyter-lab";
        };

      }
    );

}
