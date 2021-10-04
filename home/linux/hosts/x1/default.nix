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


    # make trackpad and trackpoint faster
    xinput set-prop "SynPS/2 Synaptics TouchPad" 322 1
    xinput set-prop "TPPS/2 Elan TrackPoint" 322 1

    # disable the trackpad
    xinput set-prop "ELAN0672:00 04F3:3187 Touchpad" "Device Enabled" 0

    # disable the middle button click of the trackpoint
    xinput set-button-map "TPPS/2 Elan TrackPoint" 1 0 3

    setxkbmap -option altwin:swap_lalt_lwin -option caps:ctrl_modifier

    x1-two-qhd.sh
    nitrogen-random

  '';


  home.packages = with pkgs; [
    myhaskell-full
    # mypython-full
    # myjupyter-full
  ];


  home.file = {
    ".config/xmobar/xmobarrc".source = ../../../services/xmonad/xmobarrc-laptop;
  };

}
