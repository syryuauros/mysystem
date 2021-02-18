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

    myemacs.url = "git+ssh://git@gitlab.com/wavetojj/myemacs3.git";
    myvim.url   = "git+ssh://git@gitlab.com/wavetojj/myvim2.git";

  };

  outputs =
    inputs@{ self, nixpkgs, darwin, home-manager, flake-compat, flake-utils
           , myemacs, myvim, ... }:

    let

      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
        };
        overlays = [ myemacs.overlay
                     myvim.overlay
                   ] ++ self.overlays;
      };

      external = with inputs; {
      };


      # Modules shared by most `nix-darwin` personal configurations.
      darwinCommonModules = { user }: [
        ./machines/darwin
        # Include extra `nix-darwin`
        # self.darwinModules.homebrew
        # self.darwinModules.programs.nix-index
        # self.darwinModules.security.pam
        # Main `nix-darwin` config
        # `home-manager` module
        # home-manager.darwinModules.home-manager
        # {
        #   nixpkgs = nixpkgsConfig;
        #   # Hack to support legacy worklows that use `<nixpkgs>` etc.
        #   nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
        #   # `home-manager` config
        #   users.users.${user}.home = "/Users/${user}";
        #   home-manager.useGlobalPkgs = true;
        #   home-manager.users.${user} = homeManagerCommonConfig;
        # }
      ];


    in {

      overlays = with inputs; [
        (import ./home/packages external)
      ];

      overlay = nixpkgs.lib.composeExtensions self.overlays;


      #--------------------------------------------------------------------------
      #
      #  Darwin Configurations
      #
      #  How to run:
      #   1. Build darwin-rebuild for flake first
      #     > nix build .#darwinConfigurations.mbp15.system
      #   2. Then use ./result/sw/bin/darwin-rebuild to switch
      #     > ./result/sw/bin/darwin-rebuild switch --flake .#mbp15
      #
      #  Or change mbp15 to one of other darwin configurations
      #
      #--------------------------------------------------------------------------

      darwinConfigurations = {

        # Mininal configuration to bootstrap systems
        bootstrap = darwin.lib.darwinSystem {
          modules = [ ./machines/darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
        };

        mbp15 = darwin.lib.darwinSystem {
          modules = darwinCommonModules { user = "jj"; } ++ [
            {
              networking.computerName = "JJ’s 💻";
              networking.hostName = "mbp15";
              networking.knownNetworkServices = [
                "Wi-Fi"
                "USB 10/100/1000 LAN"
              ];
            }
          ];

        };

      };


      #--------------------------------------------------------------------------
      #
      #  Home Configurations
      #
      #  How to run:
      #  > nix build .#homeConfigurations.mbp15-jj.activationPackage
      #  > ./result/activate
      #
      #  Or change mbp15-jj to one of other home configurations
      #
      #--------------------------------------------------------------------------

      homeConfigurations = {

        mbp15-jj = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-darwin";
          homeDirectory = "/home/jj";
          username = "jj";
          configuration = {
            imports = [
              ./home/mbp15
            ];
            nixpkgs = nixpkgsConfig;
          };
        };

      };



    #   nixosConfigurations =

    #     mkNixosConfig
    #     {
    #       hostname     = "x230";
    #       extraModules = [
    #                        # ./machines/nixos/phil
    #                        # ./modules/profiles/personal.nix
    #                      ];
    #     } //

    #     mkNixosConfig
    #     {
    #       hostname     = "mpNixOS";
    #       extraModules = [
    #                        # ./machines/nixos/phil
    #                        # ./modules/profiles/personal.nix
    #                      ];
    #     };


    #   # Build and activate with
    #   # `nix build .#server.activationPackage; ./result/activate`
    #   # courtesy of @malob - https://github.com/malob/nixpkgs/
    #   homeManagerConfigurations =

    #     mkHomeManagerConfig
    #     {
    #       homename     = "mbp15";
    #       username     = "jj";
    #       extraModules = [
    #                        # ./modules/profiles/home-manager/personal.nix
    #                      ];
    #     } //

    #     mkHomeManagerConfig
    #     {
    #       homename     = "x230";
    #       username     = "jj";
    #       extraModules = [
    #                        # ./modules/profiles/home-manager/personal.nix
    #                      ];
    #     } //

    #     mkHomeManagerConfig
    #     {
    #       homename     = "mpMacOS";
    #       username     = "jj";
    #       extraModules = [
    #                        # ./modules/profiles/home-manager/personal.nix
    #                      ];
    #     } //

    #     mkHomeManagerConfig
    #     {
    #       homename     = "mpLinuxOS";
    #       username     = "jj";
    #       extraModules = [
    #                        # ./modules/profiles/home-manager/personal.nix
    #                      ];
    #     } //

    #     mkHomeManagerConfig
    #     {
    #       homename     = "mx9366";
    #       username     = "jj";
    #       extraModules = [
    #                        # ./modules/profiles/home-manager/personal.nix
    #                      ];
    #     };

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
