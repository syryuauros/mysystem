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

    # myEnv2 = {
    #   url = "git+ssh://git@gitlab.com/wavetojj/myenv2.git";
    #   flake = false;
    # };
  };

  outputs =
    inputs@{ self, nixpkgs, darwin, home-manager, mach-nix, flake-utils, ... }:
    let


      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
        };
        overlays = self.overlays ++ [
          (
            final: prev:
            let
              system = prev.stdenv.system;
              nixpkgs-stable = if system == "x86_64-darwin" then nixpkgs-stable-darwin else nixos-stable;
            in {
              master = nixpkgs-master.legacyPackages.${system};
              stable = nixpkgs-stable.legacyPackages.${system};
            }
          )
        ];
      };


      # mkDarwinConfig = { hostname
      #                  , system       ? "x86_64-darwin"
      #                  , baseModules  ?
      #                      [
      #                        home-manager.darwinModules.home-manager
      #                        ./machines/darwin
      #                      ]
      #                  , extraModules ? [ ]
      #                  }:
      # {
      #   "${hostname}" = darwin.lib.darwinSystem
      #   {
      #     # inherit        system;
      #     modules     =  baseModules
      #                 ++ extraModules
      #                 ++ [{ nixpkgs.overlays = overlays; }];
      #     specialArgs = { inherit inputs nixpkgs; };
      #   };
      # };


      # mkNixosConfig = { hostname
      #                 , system ? "x86_64-linux"
      #                 , baseModules ?
      #                     [
      #                       home-manager.nixosModules.home-manager
      #                       ./machines/nixos
      #                     ]
      #                 , extraModules ? [ ] }:
      # {
      #   "${hostname}" = nixpkgs.lib.nixosSystem
      #   {
      #     inherit        system;
      #     modules     =  baseModules
      #                 ++ extraModules
      #                 ++ [{ nixpkgs.overlays = overlays; }];
      #     specialArgs = { inherit inputs nixpkgs; };
      #   };
      # };


      # mkHomeManagerConfig = { homename
      #                       , system ? "x86_64-linux"
      #                       , username
      #                       , extraModules ? [ ]
      #                       }:
      # {
      #   "${homename}" = home-manager.lib.homeManagerConfiguration rec
      #   {
      #       inherit            system
      #                          username;
      #       homeDirectory    = if system == "x86_64-linux"
      #                             then "/home/${username}"
      #                             else "/Users/${username}";
      #       configuration    = {
      #         nixpkgs.overlays = overlays;
      #         imports          =  [
      #                               ./home
      #                             ]

      #                          ++ extraModules;
      #       };
      #       extraSpecialArgs = { inherit inputs nixpkgs; };
      #   };
      # };


      # Modules shared by most `nix-darwin` personal configurations.
      darwinCommonModules = { user }: [
        # Include extra `nix-darwin`
        # self.darwinModules.homebrew
        # self.darwinModules.programs.nix-index
        # self.darwinModules.security.pam
        # Main `nix-darwin` config
        ./machines/darwin
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
        (import ./home/packages)
        # (
        #   final: prev: {

        #     inherit (prev.callPackage ./home/packages {})
        #       myEmacs
        #       myHunspell
        #       myVim
        #       # haskellForXmonad
        #       myHaskell
        #     ;
        #   }
        # )

        # To my undersding this is supposed to work as above.
        # But I've got infinite recursion
        # ( final: prev: (prev.callPackage ./home/package {}) )
        # ( final: prev: (import ./home/package { inherit prev; }) )
      ];


      #--------------------------------------------------------------------------
      #
      #  Darwin Configurations
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
      #
      #  Or change mbp15-jj to one of other names
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

    # add a devShell to this flake
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixFlakes
            rnix-lsp
            (python.withPackages
              (ps: with ps; [ black pylint typer colorama shellingham ]))
          ];
        };
      });
}
