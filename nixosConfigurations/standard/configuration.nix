{ inputs, config, lib, pkgs, ... }: {

  imports = [

    # base configuration
    ../basic/configuration.nix

    # standard configurations for all
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

  ];


}
