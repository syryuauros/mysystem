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
      # url = "github:kclejeune/nix-darwin/brew-bundle";
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{ self, nixpkgs, darwin, home-manager, mach-nix, flake-utils, ... }:
    let

      overlays = [ ];


      # Configuration for `nixpkgs` mostly used in personal configs.
      nixpkgsConfig = with inputs; {
        config = { allowUnfree = true; };
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



      mkDarwinConfig = { hostname
                       , system       ? "x86_64-darwin"
                       , baseModules  ?
                           [
                             home-manager.darwinModules.home-manager
                             ./machines/darwin
                           ]
                       , extraModules ? [ ]
                       }:
      {
        "${hostname}" = darwin.lib.darwinSystem
        {
          # inherit        system;
          modules     =  baseModules
                      ++ extraModules
                      ++ [{ nixpkgs.overlays = overlays; }];
          specialArgs = { inherit inputs nixpkgs; };
        };
      };


      mkNixosConfig = { hostname
                      , system ? "x86_64-linux"
                      , baseModules ?
                          [
                            home-manager.nixosModules.home-manager
                            ./machines/nixos
                          ]
                      , extraModules ? [ ] }:
      {
        "${hostname}" = nixpkgs.lib.nixosSystem
        {
          inherit        system;
          modules     =  baseModules
                      ++ extraModules
                      ++ [{ nixpkgs.overlays = overlays; }];
          specialArgs = { inherit inputs nixpkgs; };
        };
      };


      mkHomeManagerConfig = { hostname
                            , system ? "x86_64-linux"
                            , username
                            , extraModules ? [ ]
                            }:
      {
        "${hostname}" = home-manager.lib.homeManagerConfiguration rec
        {
            inherit            system
                               username;
            homeDirectory    = if system == "x86_64-linux"
                                  then "/home/${username}"
                                  else "/Users/${username}";
            configuration    = {
              nixpkgs.overlays = overlays;
              imports          =  [
                                    ./home
                                  ]

                               ++ extraModules;
            };
            extraSpecialArgs = { inherit inputs nixpkgs; };
        };
      };

    in {

      darwinConfigurations =

        mkDarwinConfig
        {
          hostname     = "mbp15";
          extraModules = [
                           # ./modules/profiles/personal.nix
                         ];
        } //

        mkDarwinConfig
        {
          hostname     = "mpMacOS";
          extraModules = [
                           # ./modules/profiles/work.nix
                         ];
        };


      nixosConfigurations =

        mkNixosConfig
        {
          hostname     = "x230";
          extraModules = [
                           # ./machines/nixos/phil
                           # ./modules/profiles/personal.nix
                         ];
        } //

        mkNixosConfig
        {
          hostname     = "mpNixOS";
          extraModules = [
                           # ./machines/nixos/phil
                           # ./modules/profiles/personal.nix
                         ];
        };


      # Build and activate with
      # `nix build .#server.activationPackage; ./result/activate`
      # courtesy of @malob - https://github.com/malob/nixpkgs/
      homeManagerConfigurations =

        mkHomeManagerConfig
        {
          hostname     = "mbp15";
          username     = "jj";
          extraModules = [
                           # ./modules/profiles/home-manager/personal.nix
                         ];
        } //

        mkHomeManagerConfig
        {
          hostname     = "x230";
          username     = "jj";
          extraModules = [
                           # ./modules/profiles/home-manager/personal.nix
                         ];
        } //

        mkHomeManagerConfig
        {
          hostname     = "mpMacOS";
          username     = "jj";
          extraModules = [
                           # ./modules/profiles/home-manager/personal.nix
                         ];
        } //

        mkHomeManagerConfig
        {
          hostname     = "mpLinuxOS";
          username     = "jj";
          extraModules = [
                           # ./modules/profiles/home-manager/personal.nix
                         ];
        } //

        mkHomeManagerConfig
        {
          hostname     = "mx9366";
          username     = "jj";
          extraModules = [
                           # ./modules/profiles/home-manager/personal.nix
                         ];
        };

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
