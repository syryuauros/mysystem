{ config, pkgs , lib , ... }:

{

  imports = [

    # ./emacs
    ./gpg-agent
    ./networkmanager
    # ./picom
    ./screenlocker       # needs mylockscreen
    ./udiskie
    ./xcape
     # ../../syncthing
    ./redshift
    # ./uim-korean
    ./email
  ];

  services.flameshot.enable = true;

  services.screen-locker = {
    enable = true;
    inactiveInterval = 1; # min
    lockCmd = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 5 pixel";
  };
}
