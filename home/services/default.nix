{ config, pkgs , lib , ... }:

{

  imports = [

    # ./picom
     # ../../syncthing
    ./email
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 604800; #== 7 days in seconds
    enableSshSupport = true;
  };

  services.emacs = {
    enable = true;
    package = pkgs.doom-emacs;
    client.enable = true;
  };

  services.flameshot.enable = true;

  services.screen-locker = {
    enable = true;
    inactiveInterval = 1; # min
    lockCmd = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 5 pixel";
  };

  services.redshift = {

    enable = true;
    dawnTime = "6:00-7:45";
    duskTime = "18:35-20:15";
    temperature.day = 5500;
    temperature.night = 4500;

    settings.redshift.brightness-day = "1.0";
    settings.redshift.brightness-night = "1.0";
    # latitude = "0.0000";
    # longitude = "0.0000";
    provider = "geoclue2";

  };

  services.network-manager-applet.enable = true;

  services.xcape = {
    enable = true;
    timeout = 500;  # ms
    mapExpression = {
      # Shift_L   = "Escape";
      Caps_Lock = "Escape";
      Control_L = "Escape";
    };
  };

  services.udiskie = {
    enable = true;
    tray = "always";
  };

  services.syncthing = {
    enable = true;
  };
}
