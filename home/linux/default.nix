{ config, pkgs , lib , ... }:

{

  imports = [
    ../common
    ../programs/rofi
    ../programs/firefox

    ../services/emacs
    ../services/gpg-agent
    ../services/networkmanager
    ../services/picom
    ../services/screenlocker       # needs mylockscreen
    ../services/random-background  # needs mywallpapers
    ../services/udiskie

    ./xwindow/xmonad
  ];

  home.packages = with pkgs; [
    myhaskell-xmonad
  ] ++ myfonts-collection;
}
