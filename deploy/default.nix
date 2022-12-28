inputs:
let

  inherit (inputs) deploy-rs;
  inherit (inputs.self) nixosConfigurations homeManagerConfigurations;


  pkgsFor = system: import ../pkgs.nix { inherit inputs system; };


  remote-install = system: nixos:
    let
      pkgs = pkgsFor system;
      path = (deploy-rs.lib.${system}.activate.nixos nixos);
      snippets = import ../lib/snippets.nix pkgs;
      script = pkgs.writeShellScriptBin "remote-install" ''
                 ${snippets.partition-format { forced = "false"; disk = "/dev/nvme0n1"; }}
                 ${snippets.create-btrfs-subvolumes { }}
                 ${snippets.mount-btrfs-subvolumes { }}
              '';
    in deploy-rs.lib.${system}.activate.custom script "./bin/remote-install";

  activate-nixos = system: nixos: deploy-rs.lib.${system}.activate.nixos nixos;
  activate-home = system: home: deploy-rs.lib."x86_64-linux".activate.home-manager home;

in
{

  magicRollback = false;
  autoRollback = false;

  sshUser = "jj";
  sshOpts = [ "-o StrictHostKeyChecking=no"
              "-o UserKnownHostsFile=/dev/null" ];
  user = "root";
  fastConnection = true;

  nodes = {

    lima-install = {
      hostname = "192.168.50.101";
      sshUser = "jj";
      user = "root";
      profiles.system.path = remote-install "x86_64-linux" nixosConfigurations.lima;
    };

    lima = {
      hostname = "10.10.0.21";
      profiles.system.path = activate-nixos "x86_64-linux" nixosConfigurations.lima;
      profiles."jj" = {
        user = "jj";
        path = activate-home "x86_64-linux" homeManagerConfigurations."jj@lima";
      };
    };

  };

}
