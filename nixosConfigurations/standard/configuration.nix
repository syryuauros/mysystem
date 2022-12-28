{ inputs, config, lib, pkgs, ... }:
let
  inherit (inputs) agenix home-manager;
in
{

  imports = [

    # base configuration
    ../basic/configuration.nix

    # standard configurations
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

    # secret management
    agenix.nixosModules.age

    # home-manager
    home-manager.nixosModules.home-manager

  ];


}
