inputs:
let

  inherit (inputs) deploy-rs;
  inherit (inputs.self) nixosConfigurations homeManagerConfigurations;

  activate-nixos = system: deploy-rs.lib.${system}.activate.nixos;
  activate-home = system: deploy-rs.lib.${system}.activate.home-manager;
  activate-custom = system: deploy-rs.lib.${system}.activate.custom;

in
{

  magicRollback = false;
  autoRollback = false;

  user = "root";
  sshUser = "jj";
  sshOpts = [ "-o StrictHostKeyChecking=no" ];
  fastConnection = true;

  nodes = {

    lima = {
      hostname = "10.10.0.21";
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
