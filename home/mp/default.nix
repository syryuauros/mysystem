{ config, pkgs , lib , ... }:

{

  imports = [
    ../linux
  ];

  xresources.properties = {
    "Xft.dpi" = 150;
    "Xft.autohint" = 0;
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
    "Xcursor*theme" = "Vanilla-DMZ-AA";
    "Xcursor*size" = 24;
  };

  xsession.enable = true;
  xsession.initExtra = ''

    lxsession &
    nitrogen --restore &

    ${pkgs.xorg.xkbcomp}/bin/setxkbmap -option caps:ctrl_modifier

  '';

  home.file = {

    ".config/xmobar/xmobarrc".source = ./xmobar/xmobarrc;
    ".config/xmobar/xpm".source = ./xmobar/xpm;

  };

}
