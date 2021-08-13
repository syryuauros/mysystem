{ config, pkgs , lib , ... }:

{

  imports = [
    ../common
  ];

  xresources.properties = {
    "Xft.dpi" = 100;
    "Xft.autohint" = 0;
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
    "Xcursor*theme" = "Vanilla-DMZ-AA";
    "Xcursor*size" = 160;
  };

  xsession.enable = true;
  xsession.initExtra = ''
    setxkbmap -option altwin:swap_lalt_lwin -option caps:ctrl_modifier
  '';

  home.file = {
    ".config/xmobar/xmobarrc".source = ../../services/xmonad/xmobarrc-desktop;
  };

}
