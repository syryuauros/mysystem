{ inputs, ... }:
let
  inherit (inputs) agenix home-manager;
in
{

  imports = [
    agenix.nixosModules.age
    home-manager.nixosModules.home-manager

    ../basic/configuration.nix

    ./nix.nix
    ./firewall.nix
    ./i18n.nix
    ./loginLimits.nix
    ./printing.nix
    ./upower.nix
    ./etc.nix
    ./sound.nix
    ./light.nix
    ./fonts.nix
    ./bluetooth.nix
    ./dbus.nix
    ./geoclue2.nix
    ./clipmenu.nix
    ./lidSwitch.nix
    ./uinput.nix

  ];


}
