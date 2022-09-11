{

  description = "my system configurations using nix";

  inputs = {

    haedosa.url = "github:haedosa/flakes";
    # nixpkgs.follows = "haedosa/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.follows = "haedosa/flake-utils";

    # home-manager.follows = "haedosa/home-manager";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    jupyter_contrib_core = {
      url = "github:Jupyter-contrib/jupyter_contrib_core";
      flake = false;
    };
    jupyter_nbextensions_configurator = {
      url = "github:Jupyter-contrib/jupyter_nbextensions_configurator";
      flake = false;
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    agenix.url = "github:ryantm/agenix";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs.url = "github:jjdosa/nix-doom-emacs";
    myxmonad.url = "github:jjdosa/myxmonad";

  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-utils, nur, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ self.overlay ];
        };
      mylib = import ./lib inputs system pkgs;
      inherit (builtins) mapAttrs;
      inherit (pkgs.lib) makeOverridable;
      inherit (mylib) mkUser mkNixosSystem getToplevel;

      jj = makeOverridable mkUser {
          userId = "jj";
          userName = "JJ Kim";
          userEmail = "jj@haeodsa.xyz";
          extraGroups = [ "wheel" "networkmanager" "audio" "video" "hds" "ipfs" ];
          hashedPassword = "$6$3nKguLgJMB$leFSKrvWiUAXiay8MJ8i66.ZzufIhkrrbxzv625DV28xSYGBCLp62pyIp4U3s8miHcOdJZpWLgDMEoWljPtT0.";
          keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXifjBn6gkBCKkpJJAbB1pJC1zSUljf8SFnPqvB6vIR jj"
          ];
          extraHomeModules = [];
        };

    in rec {

      overlay = nixpkgs.lib.composeManyExtensions (with inputs; [
        nur.overlay
        nix-doom-emacs.overlay
        agenix.overlay
        deploy-rs.overlay
        (import ./packages/myemacs/overlay.nix)
        (import ./packages/myvim/overlay.nix)
        (import ./packages/mytmux/overlay.nix)
        (import ./packages/myfonts/overlay.nix)
        (import ./packages/mylockscreen/overlay.nix)
        (import ./packages/mywallpapers-1366/overlay.nix)
        (import ./packages/mynitrogen/overlay.nix)
        # (import ./packages/myflow/overlay.nix)
        # (import ./packages/myplot/overlay.nix)
        (import ./packages/myhaskell/overlay.nix)
        (import ./packages/mypython/overlay.nix)
        (import ./packages/myjupyter/overlay.nix)
        (import ./packages/myjupyter/jupyter-overlay.nix {
          inherit jupyter_contrib_core jupyter_nbextensions_configurator;
        })
        (import ./overlay.nix inputs)
      ]);

      nixosConfigurations = {

          urubamba = mkNixosSystem {
            hostName = "urubamba";
            wg-ip = "10.10.0.2/32";
            modules = [ jj.nixosModule
                        jj.homeModule ];
          };

          lima = mkNixosSystem {
            hostName = "lima";
            wg-ip = "10.10.0.21/32";
            modules = [ jj.nixosModule
                        jj.homeModule ];
          };

          bogota = mkNixosSystem {
            hostName = "bogota";
            wg-ip = "10.10.0.22/32";
            modules = [ jj.nixosModule
                        jj.homeModule ];
          };

          lapaz = mkNixosSystem {
            hostName = "lapaz";
            wg-ip = "10.10.0.23/32";
            modules = [ jj.nixosModule
                        jj.homeModule ];
          };

          antofagasta = mkNixosSystem
            { hostName = "antofagasta";
              wg-ip = "10.10.0.24/32";
              modules = [ jj.nixosModule
                          jj.homeModule ];
            };
        };

      homeConfigurations = {
        jj = jj.homeConfiguration;
      };

      deploy = {
        magicRollback = true;
        autoRollback = true;

        sshUser = "jj";
        user = "root";
        sshOpts = [ "-p" "22" ];

        nodes = mapAttrs (_: nixos-system:
          {
            hostname = nixos-system.deploy-ip;
            profiles.system.path = inputs.deploy-rs.lib.${system}.activate.nixos nixos-system;
          }) nixosConfigurations;
      };

      devShells.${system} = {
        default = pkgs.callPackage ./shell.nix {};
      };

      packages.${system} = let
          nixosPackages = mapAttrs (_: config: getToplevel config) nixosConfigurations;
          homePackages = mapAttrs (_: config: config.activationPackage) homeConfigurations;
        in nixosPackages // homePackages;

    };

}
