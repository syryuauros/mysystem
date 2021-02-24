{ config, pkgs , lib , ... }:

{

  imports = [
    ../common
  ];


  xresources.properties = {
    "Xft.dpi" = 90;
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

    ${pkgs .xorg.xkbcomp}/bin/setxkbmap -option altwin:swap_lalt_lwin -option caps:ctrl_modifier

  '';

  home.packages = with pkgs; [
    myhaskell-xmonad
  ];


  home.file = {

    ".config/xmobar/xmobarrc".source = ./xmobar/xmobarrc;
    ".config/xmobar/xpm".source = ./xmobar/xpm;

  };

}
