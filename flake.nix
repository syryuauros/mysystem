{
  description = "my system configurations using nix";

  nixConfig = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils/master";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    myemacs.url   = "git+ssh://git@gitlab.com/wavetojj/myemacs3.git";
    myvim.url     = "git+ssh://git@gitlab.com/wavetojj/myvim2.git";
    myhaskell.url = "git+ssh://git@gitlab.com/wavetojj/myhaskell2.git";
    myfonts.url   = "git+ssh://git@gitlab.com/wavetojj/myfonts.git";

  };

  outputs =
    inputs@{ self, nixpkgs, darwin, home-manager, flake-compat, flake-utils
           , myemacs, myvim, myhaskell, myfonts, ... }:

    let

      nixpkgsConfig = with inputs; {
        # config = { allowUnfree = true; };
        overlays = self.overlays;
      };


      mkDarwinModules = { user, hostname, home, machine }: [
        machine
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
          users.users.${user}.home = "/Users/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = home;

          networking.computerName = user + "-" + hostname;
          networking.hostName = hostname;
          networking.knownNetworkServices = [
            "Wi-Fi"
            "USB 10/100/1000 LAN"
          ];
        }
      ];


      mkNixosModules = { user, hostname, home, machine }: [
        machine
        home-manager.nixosModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
          users.users.${user}.home = "/home/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = home;

          networking.computerName = user + "-" + hostname;
          networking.hostName = hostname;
          networking.knownNetworkServices = [
            "Wi-Fi"
            "USB 10/100/1000 LAN"
          ];
        }
      ];

    in {

      overlays = [
        myemacs.overlay
        myvim.overlay
        myhaskell.overlay
        myfonts.overlay
        (import ./home/packages {})
      ];

      overlay = nixpkgs.lib.composeManyExtensions self.overlays;


      #--------------------------------------------------------------------------
      #
      #  Darwin Configurations
      #
      #  How to run:
      #   1. Build darwin-rebuild for this flake first
      #     > nix build .#darwinConfigurations.mbp15.system
      #   2. Then use ./result/sw/bin/darwin-rebuild to switch
      #     > ./result/sw/bin/darwin-rebuild switch --flake .#mbp15
      #
      #  Or change mbp15 to one of other darwin configurations
      #
      #--------------------------------------------------------------------------

      darwinConfigurations = {

        mbp15 = darwin.lib.darwinSystem {
          modules = mkDarwinModules {
            user     = "jj";
            hostname = "mbp15";
            machine  = ./machines/darwin;
            home     = ./home/darwin;
          };

        };

      };


      nixosConfigurations = {

        x230 = nixpkgs.lib.nixosSystem {
          modules = mkDarwinModules {
            user     = "jj";
            hostname = "mbp15";
            machine  = ./machines/linux;
            home     = ./home/linux;
          };
        };

      };


      #--------------------------------------------------------------------------
      #
      #  Home Configurations
      #
      #  To build, for mac,
      #  > nix build .#homeConfigurations.darwin.activationPackage
      #  or, for linux,
      #  > nix build .#homeConfigurations.linux.activationPackage
      #  then run
      #  > ./result/activate
      #
      #--------------------------------------------------------------------------

      homeConfigurations = {

        darwin = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-darwin";
          homeDirectory = "/Users/jj";
          username = "jj";
          configuration = {
            imports = [ ./home/darwin ];
            nixpkgs = nixpkgsConfig;
          };
        };

        linux = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/jj";
          username = "jj";
          configuration = {
            imports = [ ./home/linux ];
            nixpkgs = nixpkgsConfig;
          };
        };

      };


    } //

    #--------------------------------------------------------------------------
    #
    #  devShell fo this flake
    #
    #  How to run:
    #  > nix develop
    #
    #--------------------------------------------------------------------------
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixFlakes
          ];
        };
      });
}
