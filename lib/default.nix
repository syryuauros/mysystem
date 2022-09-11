inputs: system: pkgs:
let
  inherit (inputs) self home-manager nixpkgs agenix deploy-rs;
  inherit (self) outputs;
  inherit (pkgs.lib) elemAt splitString;
  inherit (nixpkgs.lib) nixosSystem;
  inherit (home-manager.lib) homeManagerConfiguration;
in
{

  mkUser =
    { userId
    , userName
    , userEmail
    , extraGroups ? []
    , hashedPassword
    , keys ? []
    , extraHomeModules ? []
    }:
    let
      extraSpecialArgs = {
        inherit inputs outputs userId userName userEmail; };
      homeModules = [
          inputs.myxmonad.hmModule
          ../home
        ] ++ extraHomeModules;
    in {

      # For 'home-manager build/switch --flake' command
      homeConfiguration = homeManagerConfiguration {
          inherit pkgs extraSpecialArgs;
          modules = homeModules;
        };

      # To set 'home-manager.users = ' option in the nixos configuration
      homeModule = {
          nixpkgs.pkgs = pkgs;
          home-manager = {
              users.${userId} = {
                imports = homeModules;
              };
              inherit extraSpecialArgs;
            };
        };

      # To set 'user.users = ' option in the nixos configuration
      nixosModule = {
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
      , deploy-ip ? elemAt (splitString "/" wg-ip) 0
      , modules
      }:
      nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {
          inherit inputs outputs wg-ip;
          wg-key = ../secrets/wg-${hostName}.age;
        };
        modules = [
          ({ pkgs, ... }: {
            networking.hostName = hostName;
            imports = modules ++ [
                ../nixos/default.nix
                ../nixos/wireguard.nix
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

  getToplevel = nixos-system: nixos-system.config.system.build.toplevel;
}
