{ config, lib, pkgs, ... }:

{
  services = {

    gnome3.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
    };

    xserver = {
      enable = true;
      layout = "us";

      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
          naturalScrolling = true;
        };
        mouse = {
          disableWhileTyping = true;
          naturalScrolling = true;
        };
      };

      displayManager.defaultSession = "none+xmonad";

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmonad
        ];
      };

      xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin";
    };
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  systemd.services.upower.enable = true;
}
