{

  description = "my system configurations using nix";

  inputs = {

    haedosa.url = "github:haedosa/flakes/2022-09-13";
    nixpkgs.follows = "haedosa/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

    doom-private.url = "github:jjdosa/doom-private";
    doom-private.flake = false;
    nix-doom-emacs = {
      url = "github:jjdosa/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.doom-private.follows = "doom-private";
    };
    myxmonad.url = "github:jjdosa/myxmonad";

    peerix = {
      url = "github:cid-chan/peerix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-utils, nur, ... }:
    let

      inherit (nixpkgs.lib) attrValues makeOverridable mapAttrs mapAttrs';

      system = "x86_64-linux";
      pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = attrValues self.overlays;
        };
      mylib = import ./lib inputs system pkgs;

      inherit (mylib) mkUser mkNixosSystem getToplevel usb-with-packages deploy-to-remote;

      jj = makeOverridable mkUser
        {
          userId = "jj";
          userName = "JJ Kim";
          userEmail = "jj@haeodsa.xyz";
          extraGroups = [ "wheel" "networkmanager" "audio" "video" "hds" "ipfs" ];
          hashedPassword = "$6$3nKguLgJMB$leFSKrvWiUAXiay8MJ8i66.ZzufIhkrrbxzv625DV28xSYGBCLp62pyIp4U3s8miHcOdJZpWLgDMEoWljPtT0.";
          keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXifjBn6gkBCKkpJJAbB1pJC1zSUljf8SFnPqvB6vIR jj"
          ];
        };

    in rec {

      overlays = import ./overlays { inherit inputs system; };

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
            modules =
              [ jj.nixosModule
                jj.homeModule
                { services.xserver.videoDrivers = [ "nvidia" "intel" ]; }
              ];
          };

          lapaz = mkNixosSystem {
            hostName = "lapaz";
            wg-ip = "10.10.0.23/32";
            modules = [ jj.nixosModule
                        jj.homeModule ];
          };

          antofagasta =
            let jj' = jj.override {
                  homeModules = [{
                    xsession.initExtra = ''
                      sl-antofagasta.sh
                    '';}
                    ];
                  };
            in mkNixosSystem {
                  hostName = "antofagasta";
                  wg-ip = "10.10.0.24/32";
                  modules = [ jj.nixosModule jj'.homeModule];
                  # deploy-ip = "192.168.68.69";
                };

        };

      homeConfigurations = {
        jj = jj.homeConfiguration;
      };

      deploy = {
        magicRollback = true;
        autoRollback = true;
        fastConnection = true;

        sshUser = "jj";
        user = "root";
        sshOpts = [ "-p" "22" ];

        nodes = mapAttrs (_: nixos-system: {
            hostname = nixos-system.deploy-ip;
            profiles.system.path = inputs.deploy-rs.lib.${system}.activate.nixos nixos-system;
          }) nixosConfigurations;
      };

      devShells.${system} = {
        default = pkgs.callPackage ./shell.nix {};
      };

      apps.${system} = mapAttrs (name: config: {
          type = "app";
          program = "${packages.${system}."deploy-${name}"}/bin/deploy-${name}";
        }) nixosConfigurations;

      packages.${system} =
        let
          nixosPackages = mapAttrs (_: config: getToplevel config) nixosConfigurations;
          homePackages = mapAttrs (_: config: config.activationPackage) homeConfigurations;
          deployScripts = mapAttrs' (hostName: config: {
              name = "deploy-${hostName}";
              value = deploy-to-remote {
                  remote = config.deploy-ip;
                  hostName = hostName;
                  nixos-toplevel = getToplevel config;
                };
            }) nixosConfigurations;
          packages = nixosPackages // homePackages // deployScripts;
        in packages // { usb = usb-with-packages (attrValues packages); };

    };

}
