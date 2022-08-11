{

  description = "my system configurations using nix";

  inputs = {

    haedosa.url = "github:haedosa/flakes";
    nixpkgs.follows = "haedosa/nixpkgs";

    flake-utils.follows = "haedosa/flake-utils";
    home-manager.follows = "haedosa/home-manager";

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

    nix-doom-emacs.url = "github:jjdosa/nix-doom-emacs";
    myxmonad.url = "github:jjdosa/myxmonad";
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    # nixpkgs-wayland.inputs.nixpkgs.follows = "haedosa/nixpkgs";

  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-utils, nur, ... }:

    let

      lib = nixpkgs.lib;
      inherit (builtins) mapAttrs;

      allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [ # whitelist for firefox
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
          "symbola"
          "nvidia-x11"
          "nvidia-settings"
          "grammarly"
          "dropbox"
          "foxitreader"
        ];

      # This keys for the distributed builds
      root = {
        hashedPassword =
          "$6$T80JsrUCydok0S$5/CAsrhK77RRPP3QlqAFjOgjp9CEo/0LUUXwkmT9Tjmsz08DfY5.FkLp3SU3EhlLesH2aq7FGVBBEc07s3R7u/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxtKP75Zobhn/Jioh9Wp1poDoePTm0suv3vufcRCdP0 root@x1"
        ];
      };

      hosts = {

        urubamba = {
          ip = "10.10.0.2";
          configuration = ./nixos/x1;
          home = ./home/x1;
          haedosa0ips = [ "10.100.0.2/32" ];
          hds0ips = [ "10.10.0.2/32" ];
          wg-key = ./secrets/wg-urubamba.age;
          private-key = ./secrets/sshkey.age;
        };

        lima = {
          ip = "10.10.0.21";
          configuration = ./nixos/x1;
          home = ./home/x1;
          haedosa0ips = [ "10.100.0.21/32" ];
          hds0ips = [ "10.10.0.21/32" ];
          wg-key = ./secrets/wg-lima.age;
          private-key = ./secrets/sshkey.age;
        };

        bogota = {
          ip = "10.10.0.22";
          configuration = ./nixos/legion5;
          home = ./home/legion5;
          haedosa0ips = [ "10.100.0.22/32" ];
          hds0ips = [ "10.10.0.22/32" ];
          wg-key = ./secrets/wg-bogota.age;
          private-key = ./secrets/sshkey.age;
        };

        lapaz = {
          ip = "10.10.0.23";
          configuration = ./nixos/x1;
          home = ./home/x1;
          haedosa0ips = [ "10.100.0.23/32" ];
          hds0ips = [ "10.10.0.23/32" ];
          wg-key = ./secrets/wg-lapaz.age;
          private-key = ./secrets/sshkey.age;
        };

      };

      users = {

        # inherit root;

        jj = {
          isNormalUser = true;
          uid = 1000;
          home = "/home/jj";
          extraGroups =
            [ "wheel" "networkmanager" "audio" "video" "hds" "ipfs" ];
          hashedPassword =
            "$6$3nKguLgJMB$leFSKrvWiUAXiay8MJ8i66.ZzufIhkrrbxzv625DV28xSYGBCLp62pyIp4U3s8miHcOdJZpWLgDMEoWljPtT0.";
          openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+XEhhqkpyVtUSu+t2JT3j5QxHUGBwCOiOwyc/4Ukpk8F2XP+ac5i9QuFd+yKXeoQcmgke6y+h7HjVBMDYD5OJRq6N4ep9dfU6svGccVNScbh+dOB+WtzrZco7euddOhtjT4pbSoyhImg5AJxA0SgvHnoTTq4nvMYAbCG9xSWz353FV1nrJPLo0bpEOSqdeb3HTgDntcMv9KaNGHe6hzGIPBQvW/y2FQ3hiHtDS+WIBQzPrQnRRslrCr7hcBwniYfKBdgjENK2yLIgDSoTwUXYFTMZgrjBejCo33+bR2Jrk66isEOR7oThHsI7vnxjSlUKmQ4o+B4e1lsILIyW0GPz0s/vrdTfZdqt+eZ38NJhqJD7mDruhuBf1NNE/rNWazu36afSQnRXhv9XgHo1cF1NMtC10grOrA5fUylGRHS8tS2RZHJ9OXgxBcV0bdIbqOu7jFRTzvm36dcMyJrALrz4ZEg/BJ7IOgtd1cTpcvxcQzDZSd+mSPHaY82urSH7QCc= jj@x1"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXifjBn6gkBCKkpJJAbB1pJC1zSUljf8SFnPqvB6vIR jj"
          ];
        };

      };

      system = "x86_64-linux";
      pkgsConfig = {
        inherit system;
        config = { inherit allowUnfreePredicate; };
        overlays = [ self.overlay ];
      };

      pkgs = import nixpkgs pkgsConfig;

      mkNixOSConfiguration = name: host:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [

            ({ pkgs, ... }: {

              nixpkgs = pkgsConfig;

              environment.etc.nixpkgs.source = inputs.nixpkgs;
              nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];

              users.mutableUsers = false;
              users.extraUsers = users;

              networking = {
                hostName = name;
                networkmanager.enable = true;
              };

              nix.registry = {
                self.flake = inputs.self;
                nixpkgs = {
                  from = {
                    id = "nixpkgs";
                    type = "indirect";
                  };
                  flake = inputs.nixpkgs;
                };
              };

              imports = with host; [
                configuration
                (import ./nixos/wireguard wg-key haedosa0ips hds0ips)
                inputs.agenix.nixosModules.age
                ./modules
                home-manager.nixosModules.home-manager
                {
                  # nixpkgs = pkgsConfig;
                  home-manager.users = (mapAttrs (username: user: {
                    imports = with inputs; [
                      nix-doom-emacs.hmModule
                      inputs.myxmonad.hmModule
                      host.home
                    ];

                    home.file.".nixpkgs".source = inputs.nixpkgs;
                    systemd.user.sessionVariables."NIX_PATH" = lib.mkForce
                      "nixpkgs=$HOME/.nixpkgs\${NIX_PATH:+:}$NIX_PATH";
                    # xdg.configFile."nixpkgs/config.nix".source = ./nix/config.nix;

                    # Re-expose self and nixpkgs as flakes.
                    xdg.configFile."nix/registry.json".text = builtins.toJSON {
                      version = 2;
                      flakes = let
                        toInput = input:
                          {
                            type = "path";
                            path = input.outPath;
                          } // (lib.filterAttrs (n: _:
                            n == "lastModified" || n == "rev" || n == "revCount"
                            || n == "narHash") input);
                      in [
                        {
                          from = {
                            id = "self";
                            type = "indirect";
                          };
                          to = toInput inputs.self;
                        }
                        {
                          from = {
                            id = "nixpkgs";
                            type = "indirect";
                          };
                          to = toInput inputs.nixpkgs;
                        }
                      ];
                    };
                  }) users);
                }
              ];
            })
          ];
        };

    in rec {

      overlay = nixpkgs.lib.composeManyExtensions (with inputs; [
        nur.overlay
        nix-doom-emacs.overlay
        agenix.overlay
        deploy-rs.overlay
        # nixpkgs-wayland.overlay
        (import ./packages/myemacs/overlay.nix)
        (import ./packages/myvim/overlay.nix)
        (import ./packages/mytmux/overlay.nix)
        (import ./packages/myfonts/overlay.nix)
        (import ./packages/mylockscreen/overlay.nix)
        (import ./packages/mywallpapers-1366/overlay.nix)
        (import ./packages/mynitrogen/overlay.nix)
        # (import ./packages/myflow/overlay.nix)
        # (import ./packages/myplot/overlay.nix)
        (import ./packages/myhaskell/overlay.nix)
        (import ./packages/mypython/overlay.nix)
        (import ./packages/myjupyter/overlay.nix)
        (import ./packages/myjupyter/jupyter-overlay.nix {
          inherit jupyter_contrib_core jupyter_nbextensions_configurator;
        })
        (import ./overlay.nix { inherit inputs mkNixOSConfiguration hosts; })
      ]);

      nixosConfigurations = mapAttrs mkNixOSConfiguration hosts;

      deploy = {
        magicRollback = true;
        autoRollback = true;

        sshUser = "jj";
        user = "root";
        sshOpts = [ "-p" "22" ];

        nodes = mapAttrs (name: host:
          let nixosConfig = mkNixOSConfiguration name host;
          in {
            hostname = host.ip;
            profiles.system.path =
              inputs.deploy-rs.lib.${system}.activate.nixos nixosConfig;
          }) hosts;
      };

      checks =
        mapAttrs (_: lib: lib.deployChecks self.deploy) inputs.deploy-rs.lib;

    } // flake-utils.lib.eachDefaultSystem (system:
      let

        nixosPackages =
          (mapAttrs (name: host: host.config.system.build.toplevel)
            self.nixosConfigurations);

      in rec {
        devShell = import ./develop.nix { inherit pkgs; };

        # defaultPackage = pkgs.deploy;
        packages = {
          # deploy = pkgs.deploy;
          default = pkgs.symlinkJoin {
            name = "all";
            paths = lib.attrValues nixosPackages;
          };
        } // nixosPackages;

        defaultApp = apps.deploy;
        apps = {
          # add other apps here
        } // pkgs.nixOSApps;
      }

    );
}
