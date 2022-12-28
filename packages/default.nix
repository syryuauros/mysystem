inputs: system:
let

  inherit (inputs.self) nixosConfigurations;

  pkgs = import ../pkgs.nix { inherit inputs system; };
  utils = pkgs.callPackage ../lib/utils.nix {};

  inherit (builtins) mapAttrs;
  inherit (utils) get-toplevel get-isoimage;

  nixosSystems =
    (mapAttrs (_ :value: get-toplevel value) nixosConfigurations)
    // { iguazu = get-isoimage nixosConfigurations.iguazu;
         usb = get-isoimage nixosConfigurations.usb;
       };

  scripts = import ../lib/scripts.nix pkgs;

  myfonts = pkgs.callPackage ./myfonts {};

in nixosSystems
// myfonts
//
{
  # inherit myfonts;
  # inherit pkgs;
  # inherit (scripts)
  #   partition-format
  #   create-btrfs-subvolumes
  #   mount-btrfs-subvolumes
    # install-over-ssh
  # ;
}
