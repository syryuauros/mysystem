{ config, lib, pkgs, ... }:

{

  services = {

    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    xserver = {
      enable = true;

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

      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
      # displayManager.lightdm.enable = true;

      # FIXME: not working
      # Following https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/6
      #
      # I added this line below in the myxmonad home-manager module
      # xsession.scriptPath = ".hm-xsession";
      #
      # and uncommented this line, but it does not work.
      # desktopManager.session = [
      #   {
      #     name = "xmonad";
      #     start = ''eval exec $HOME/.xmonad-xsession'';
      #   }
      # ];

    };
  };


  services.xserver.layout = "us";
  # services.xserver.xkbVariant = ",dvorak";
  # xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin"; # set separatedly for each machine


  systemd.services.upower.enable = true;
}
