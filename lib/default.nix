inputs: system: pkgs:
let
  inherit (inputs) self home-manager nixpkgs agenix deploy-rs;
  inherit (self) outputs;
  inherit (pkgs.lib) elemAt splitString;
  inherit (nixpkgs.lib) nixosSystem;
  inherit (home-manager.lib) homeManagerConfiguration;

  utils = import ./utils.nix pkgs;
  scripts = import ./scripts.nix pkgs;

in
{

  mkUser =
    { userId
    , userName
    , userEmail
    , extraGroups ? []
    , hashedPassword
    , keys ? []
    , homeModules ? []
    , nixosModules ? []
    }:
    let
      extraSpecialArgs = {
        inherit inputs outputs userId userName userEmail;
      };
      homeModules' = [
        inputs.myxmonad.hmModule
        ../home
      ] ++ homeModules;
    in {

      # For 'home-manager build/switch --flake' command
      homeConfiguration = homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = homeModules';
      };

      # To set 'home-manager.users = ' option in the nixos configuration
      homeModule = {
        nixpkgs.pkgs = pkgs;
        home-manager = {
            users.${userId} = {
              imports = homeModules';
            };
            inherit extraSpecialArgs;
          };
      };

      # To set 'user.users = ' option in the nixos configuration
      nixosModule = {
        imports = nixosModules;
        users.users.${userId} = {
          isNormalUser = true;
          home = "/home/${userId}";
          inherit extraGroups hashedPassword;
          openssh.authorizedKeys.keys = keys;
        };
      };
    };


  mkNixosSystem =
    { hostName
    , wg-ip
    , wg-ip-hds1
    , deploy-ip ? elemAt (splitString "/" wg-ip) 0
    , modules
    }:
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        inherit inputs outputs wg-ip wg-ip-hds1;
        wg-key = ../secrets/wg-${hostName}.age;
      };
      modules = [
        ({ pkgs, ... }: {
          networking.hostName = hostName;
          imports = modules ++ [
              ../nixos/default.nix
              ../nixos/hardware-configuration.nix
              agenix.nixosModules.age
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                };
              }
            ];
        })
      ];
    } // { inherit deploy-ip; };

  mkBootableUsbSystem = { hostName , modules, hasNvidia ? false }:
    nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {
        inherit inputs outputs;
      };
      modules = modules ++ [
        ({ modulesPath, ...}: {
          networking.hostName = hostName;
          imports = [
            # (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
            (modulesPath + "/installer/cd-dvd/installation-cd-graphical-gnome.nix")
          ];
        })
        (import ../nixos/usbConfiguration.nix)
        ({ config, pkgs, lib, ... }:
          if hasNvidia then {
            services.xserver.videoDrivers = [ "nvidia" ];
          } else {})
      ];
    };

  inherit utils scripts;

}
