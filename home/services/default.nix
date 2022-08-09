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

}
