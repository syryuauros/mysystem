{ config, pkgs , lib , ... }:

{

  imports = [
    ../../common
  ];


  xresources.properties = {
    "Xft.dpi" = 120;
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

    setxkbmap -option caps:ctrl_modifier

  '';


  home.packages = with pkgs; [
    myhaskell-full
    mypython-full
    myjupyter-full
  ];


  home.file = {
    ".config/xmobar/xmobarrc".source = ../../../services/xmonad/xmobarrc-laptop;
  };

}
