inputs:
let

  inherit (inputs) deploy-rs;
  inherit (inputs.self) nixosConfigurations homeManagerConfigurations;


  pkgsFor = system: import ../pkgs.nix { inherit inputs system; };


  # TODO: not finished
  remote-install = system: nixos:
    let
      pkgs = pkgsFor system;
      mylib = import ../lib pkgs;
      inherit (mylib) snippets;
      script = pkgs.writeShellScriptBin "remote-install" ''
                 ${snippets.mount-btrfs-subvolumes { }}

                 ${activate-nixos nixos}/activate
              '';
    in activate-custom script "./bin/remote-install";

  activate-nixos = system: deploy-rs.lib.${system}.activate.nixos;
  activate-home = system: deploy-rs.lib.${system}.activate.home-manager;
  activate-custom = system: deploy-rs.lib.${system}.activate.custom;

in
{

  magicRollback = true;
  autoRollback = true;

  user = "root";
  sshUser = "jj";
  sshOpts = [ "-o StrictHostKeyChecking=no"
              "-o UserKnownHostsFile=/dev/null" ];
  fastConnection = true;

  nodes = {

    lima-install = { # TODO: not finished
      hostname = "192.168.68.75";
      profiles.system.path = remote-install "x86_64-linux" nixosConfigurations.lima;
    };

    lima = {
      hostname = "192.168.68.75";
      # hostname = "10.10.0.21";
      profiles.system.path = activate-nixos "x86_64-linux" nixosConfigurations.lima;
      profiles."jj" = {
        user = "jj";
        path = activate-home "x86_64-linux" homeManagerConfigurations."jj@lima";
      };
    };

    urubamba = {
      hostname = "10.10.0.2";
      profiles.system.path = activate-nixos "x86_64-linux" nixosConfigurations.urubamba;
      profiles."jj" = {
        user = "jj";
        path = activate-home "x86_64-linux" homeManagerConfigurations."jj@urubamba";
      };
    };

    lapaz = {
      hostname = "10.10.0.23";
      profiles.system.path = activate-nixos "x86_64-linux" nixosConfigurations.lapaz;
      profiles."jj" = {
        user = "jj";
        path = activate-home "x86_64-linux" homeManagerConfigurations."jj@lapaz";
      };
    };

    bogota = {
      hostname = "10.10.0.22";
      profiles.system.path = activate-nixos "x86_64-linux" nixosConfigurations.bogota;
      profiles."jj" = {
        user = "jj";
        path = activate-home "x86_64-linux" homeManagerConfigurations."jj@bogota";
      };
    };

  };

}
