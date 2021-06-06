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

    # make trackpad and trackpoint faster
    xinput --set-prop "SynPS/2 Synaptics TouchPad" 322 1
    xinput --set-prop "TPPS/2 IBM TrackPoint" 322 1

    # ${pkgs.xorg.xkbcomp}/bin/setxkbmap -option altwin:swap_lalt_lwin -option caps:ctrl_modifier
    ${pkgs.xorg.xkbcomp}/bin/setxkbmap -option caps:ctrl_modifier

  '';


  home.packages = with pkgs; [
    myhaskell-full
    mypython-full
    myjupyter-full
  ];


  home.file = {
    ".config/xmobar/xmobarrc".source = ./xmobar/xmobarrc;
  };

}
