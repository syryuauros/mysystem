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
    "Xcursor*size" = 50;
  };

  xsession.enable = true;
  xsession.initExtra = ''

    lxsession &
    nitrogen --restore &

    setxkbmap -option caps:ctrl_modifier &
    trayer --edge top --align right --widthtype request --padding 1 \
           --SetDockType true --SetPartialStrut true --expand true --transparent true \
           --alpha 0 --tint 0x282c34  --height 22 &

  '';

  home.file = {

    ".config/xmobar/xmobarrc".source = ./xmobar/xmobarrc;
    ".config/xmobar/xpm".source = ./xmobar/xpm;

  };

}
