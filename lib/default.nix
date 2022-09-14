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
    , homeModules ? []
    , nixosModules ? []
    }:
    let
      extraSpecialArgs = {
        inherit inputs outputs userId userName userEmail; };
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

  usb-with-packages = packages: (nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ({ modulesPath, ...}: {
          imports = [
            # (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
            (modulesPath + "/installer/cd-dvd/installation-cd-graphical-gnome.nix")
          ];
        })
        ({ config, lib, pkgs, ... }: {

          system.stateVersion = "22.05";

          environment.systemPackages = with pkgs; [
            vim
            curl
            wget
            pciutils
            htop
          ] ++ packages;

          services.avahi.enable = true;
          services.avahi.publish.enable = true;
          services.avahi.publish.addresses = true;
          services.avahi.publish.domain = true;
          services.avahi.publish.userServices = true;
          services.avahi.publish.workstation = true;
          services.avahi.nssmdns = true;

        })
      ];
    }).config.system.build.isoImage;

  getToplevel = nixos-system: nixos-system.config.system.build.toplevel;

  deploy-to-remote =
    { hostName ? "to-remote"
    , nixos-toplevel
    , remote
    }:
    let profile = "/nix/var/nix/profiles/system";
    in pkgs.writeShellScriptBin "deploy-${hostName}" ''
      nix copy ${nixos-toplevel} \
        --to ssh://${remote} \
        --no-check-sigs \
        --experimental-features nix-command
      ssh ${remote} sudo nix-env --profile ${profile} --set ${nixos-toplevel}
      ssh ${remote} sudo ${profile}/bin/switch-to-configuration switch
    '';

  install-from-usb =
    { mountPoint ? "/mnt"
    , nixos-toplevel
    }:
    let profile = "${mountPoint}/nix/var/nix/profiles/system";
    in pkgs.writeShellScriptBin "deploy-sh" ''
      nix copy ${nixos-toplevel} \
        --from / \
        --to ${mountPoint} \
        --no-check-sigs \
        --experimental-features nix-command
      nix-env --store ${mountPoint} \
              --profile ${profile}  \
              --set ${nixos-toplevel}
      ${profile}/bin/switch-to-configuration switch
      mkdir -m 0755 -p ${mountPoint}/etc
      touch "${mountPoint}/etc/NIXOS"
      ln -sfn /proc/mounts ${mountPoint}/etc/mtab
      NIXOS_INSTALL_BOOTLOADER=1 nixos-enter --root "${mountPoint}" -- /run/current-system/bin/switch-to-configuration boot
    '';

  deploy-ssh-from-to = host: path: store:
    let profile = "/nix/var/nix/profiles/system";
    in pkgs.writeShellScriptBin "deploy-sh" ''
      host="${host}"
      store="${store}"
      nix copy $store --from ssh://$host --to ${path}
      nix-env --profile ${profile} --set $store
      ${profile}/bin/switch-to-configuration switch
    '';

}
