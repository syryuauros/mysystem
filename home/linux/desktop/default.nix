{ config, pkgs , lib , ... }:

{

  imports = [
    ../common
  ];

  xresources.properties = {
    "Xft.dpi" = 160;
    "Xft.autohint" = 0;
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
    "Xcursor*theme" = "Vanilla-DMZ-AA";
    "Xcursor*size" = 80;
  };

  xsession.enable = true;
  xsession.initExtra = ''

    lxsession &
    setxkbmap -option caps:ctrl_modifier &
    emacs --title emacsOnSP --daemon=emacsOnSP &

  '';

  home.packages = with pkgs; [
    zoom-us
  ];

  home.file = {

    ".config/xmobar/xmobarrc".source = ./xmobar/xmobarrc;
    ".config/xmobar/xpm".source = ./xmobar/xpm;

  };

}
