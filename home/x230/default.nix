{ config, pkgs , lib , ... }:

{

  imports = [
    ../linux
  ];


  home.file = {

    ".config/xmobar/xmobarrc".source = ./xmobar/xmobarrc;
    ".config/xmobar/xpm".source = ./xmobar/xpm;

  };

}
