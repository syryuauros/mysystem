{

  description = "my system configurations using nix";

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
    nur.url = "github:nix-community/NUR/master";

    myemacs.url           = "git+ssh://git@gitlab.com/wavetojj/myemacs3.git";
    myvim.url             = "git+ssh://git@gitlab.com/wavetojj/myvim2.git";
    myfonts.url           = "git+ssh://git@gitlab.com/wavetojj/myfonts.git";
    mylockscreen.url      = "git+ssh://git@gitlab.com/wavetojj/mylockscreen.git";
    mywallpapers-1366.url = "git+ssh://git@gitlab.com/wavetojj/mywallpapers-1366.git";
    myxmobar.url          = "git+ssh://git@gitlab.com/wavetojj/myxmobar.git";
    mynitrogen.url        = "git+ssh://git@gitlab.com/wavetojj/mynitrogen.git";

    myhaskell.url         = "git+ssh://git@gitlab.com/wavetojj/myhaskell2.git";
    mypython.url          = "git+ssh://git@gitlab.com/wavetojj/mypython2.git";
    myjupyter.url         = "git+ssh://git@gitlab.com/wavetojj/myjupyter2.git";

    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs =
    inputs@{ self, nixpkgs, darwin, home-manager, flake-compat, flake-utils, nur
           , myemacs, myvim, myfonts, mylockscreen, mywallpapers-1366
           , myxmobar, mynitrogen, nixos-hardware
           , myhaskell, mypython, myjupyter, ... }:

    let

      nixpkgsConfig = with inputs; {

        config = {
          allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg)
            [ # whitelist for firefox
              "firefox-beta-bin"
              "firefox-beta-bin-unwrapped"
              "languagetool"
              "lastpass-password-manager"
              "broadcom-sta"
              "cudatoolkit"
            ];
        };

        overlays = self.overlays;
      };


      mkDarwinModules = { user, hostname, home, machine }: [
        machine
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          users.users.${user}.home = "/Users/${user}";
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
          home-manager.users.${user} = home;
          networking.hostName = hostname;
        }
      ];

    in {

      overlays = [
        nur.overlay
        myemacs.overlay
        myvim.overlay
        myfonts.overlay
        mylockscreen.overlay
        mywallpapers-1366.overlay
        myxmobar.overlay
        mynitrogen.overlay

        myhaskell.overlay
        mypython.overlay
        myjupyter.overlay

        (import ./overlay.nix {})
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
            machine  = ./machines/x230;
            home     = ./home/x230;
          };
          # } ++ [ nixos-hardware.nixosModules.lenovo-thinkpad-x230 ] ;
          ##       ^ this seem to make wifi not work
        };

        mp = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = mkNixosModules {
            user     = "jj";
            hostname = "mp";
            machine  = ./machines/mp;
            home     = ./home/mp;
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
