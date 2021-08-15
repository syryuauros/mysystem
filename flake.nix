{

  description = "my system configurations using nix";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils/master";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    home-manager = { url = "github:nix-community/home-manager/master"; inputs.nixpkgs.follows = "nixpkgs"; };
    darwin = { url = "github:LnL7/nix-darwin/master"; inputs.nixpkgs.follows = "nixpkgs"; };
    nur.url = "github:nix-community/NUR/master";
    chemacs2 = { url = "github:plexus/chemacs2"; flake = false; };
    nix-doom-emacs.url = "github:wavetojj/nix-doom-emacs";
    jupyter_contrib_core = { url = "github:Jupyter-contrib/jupyter_contrib_core"; flake = false; };
    jupyter_nbextensions_configurator = { url = "github:Jupyter-contrib/jupyter_nbextensions_configurator"; flake = false; };
    nixos-hardware.url = "github:nixos/nixos-hardware";

  };

  outputs =
    inputs@{ self, nixpkgs, darwin, home-manager, flake-compat, flake-utils, nur
           , chemacs2, nix-doom-emacs
           , jupyter_contrib_core, jupyter_nbextensions_configurator
           , ... }:

    let

      lib = nixpkgs.lib;

      nixpkgsConfig = hostname: with inputs; {

        config = {
          allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg)
            [ # whitelist for firefox
              "firefox-beta-bin"
              "firefox-beta-bin-unwrapped"
              "languagetool"
              "lastpass-password-manager"
              "broadcom-sta"
              "cudatoolkit"
              "zoom"
              "google-chrome"
              "anydesk"
              "slack"
              "Oracle_VM_VirtualBox_Extension_Pack"
            ];
          inherit hostname;
        };

        overlays = self.overlays;
      };


      mkDarwinModules = { user, hostname, home, nixos }: [
        nixos
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig hostname;
          users.users.${user}.home = "/Users/${user}";
          home-manager.users.${user} = {
            imports = [ nix-doom-emacs.hmModule
                        home ];
          };

          networking.computerName = user + "-" + hostname;
          networking.hostName = hostname;
          networking.knownNetworkServices = [
            "Wi-Fi"
            "USB 10/100/1000 LAN"
          ];
        }
      ];


      mkNixosModules = { user, hostname, home, nixos }: [
        nixos
        home-manager.nixosModules.home-manager
        {
          nixpkgs = nixpkgsConfig hostname;
          home-manager.users.${user} = {
            imports = [ nix-doom-emacs.hmModule
                        home ];
          };
          networking.hostName = hostname;
        }
      ];

    in rec {

      overlays = [
        nur.overlay
        nix-doom-emacs.overlay
        (import ./packages/myemacs/overlay.nix)
        (import ./packages/myvim/overlay.nix)
        (import ./packages/myfonts/overlay.nix)
        (import ./packages/mylockscreen/overlay.nix)
        (import ./packages/mywallpapers-1366/overlay.nix)
        (import ./packages/mynitrogen/overlay.nix)
        (import ./packages/myflow/overlay.nix)
        (import ./packages/myplot/overlay.nix)
        (import ./packages/myhaskell/overlay.nix)
        (import ./packages/mypython/overlay.nix)
        (import ./packages/myjupyter/overlay.nix)
        (import ./packages/myjupyter/jupyter-overlay.nix {
          inherit
            jupyter_contrib_core
            jupyter_nbextensions_configurator; })
        (import ./overlay.nix inputs)
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
            nixos    = ./nixos/darwin/hosts/mbp15;
            home     = ./home/darwin/hosts/mbp15;
          };

        };

      };


      #--------------------------------------------------------------------------
      #
      #  NixOS Configurations
      #
      #  How to run:
      #     > nixos-rebuild build --flake .#x230
      #
      #  Or change mbp15 to one of other nixos configurations
      #
      #--------------------------------------------------------------------------

      nixosConfigurations = {

        x230 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosModules {
            user     = "jj";
            hostname = "x230";
            nixos    = ./nixos/linux/hosts/hosts/x230;
            home     = ./home/linux/hosts/hosts/x230;
          };
          # } ++ [ nixos-hardware.nixosModules.lenovo-thinkpad-x230 ] ;
          ##       ^ this seem to make wifi not work
        };

        l14 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosModules {
            user     = "jj";
            hostname = "l14";
            nixos    = ./nixos/linux/hosts/l14;
            home     = ./home/linux/hosts/l14;
          };
        };

        t14 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosModules {
            user     = "jj";
            hostname = "t14";
            nixos    = ./nixos/linux/hosts/t14;
            home     = ./home/linux/hosts/t14;
          };
        };

        x1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosModules {
            user     = "jj";
            hostname = "x1";
            nixos    = ./nixos/linux/hosts/x1;
            home     = ./home/linux/hosts/x1;
          };
        };

        mp = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosModules {
            user     = "jj";
            hostname = "mp";
            nixos    = ./nixos/linux/hosts/mp;
            home     = ./home/linux/hosts/mp;
          };
        };

        mx9366 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosModules {
            user     = "jj";
            hostname = "mx9366";
            nixos    = ./nixos/linux/hosts/mx9366;
            home     = ./home/linux/hosts/mx9366;
          };
        };

        mini5i = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosModules {
            user     = "jj";
            hostname = "mini5i";
            nixos    = ./nixos/linux/hosts/mini5i;
            home     = ./home/linux/hosts/mini5i;
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

        mbp15 = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-darwin";
          homeDirectory = "/Users/jj";
          username = "jj";
          configuration = {
            imports = [ ./home/darwin/hosts/mbp15 ];
            nixpkgs = nixpkgsConfig "mbp15";
          };
        };

        mp = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/jj";
          username = "jj";
          configuration = {
            imports = [ ./home/linux/hosts/mp ];
            nixpkgs = nixpkgsConfig "mp";
          };
        };

        x230 = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/jj";
          username = "jj";
          configuration = {
            imports = [ ./home/linux/hosts/x230 ];
            nixpkgs = nixpkgsConfig "x230";
          };
        };

        l14 = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/jj";
          username = "jj";
          configuration = {
            imports = [ ./home/linux/hosts/l14 ];
            nixpkgs = nixpkgsConfig "l14";
          };
        };

        t14 = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/jj";
          username = "jj";
          configuration = {
            imports = [ ./home/linux/hosts/t14 ];
            nixpkgs = nixpkgsConfig "t14";
          };
        };

        x1 = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/jj";
          username = "jj";
          configuration = {
            imports = [ ./home/linux/hosts/x1 ];
            nixpkgs = nixpkgsConfig "x1";
          };
        };

        mx9366 = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/jj";
          username = "jj";
          configuration = {
            imports = [ ./home/linux/hosts/mx9366 ];
            nixpkgs = nixpkgsConfig "mx9366";
          };
        };

        mini5i = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/jj";
          username = "jj";
          configuration = {
            imports = [ ./home/linux/hosts/mini5i ];
            nixpkgs = nixpkgsConfig "mini5i";
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
