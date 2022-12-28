{ config, lib, pkgs, ... }:

{

  imports = [
    ./alacritty
    ./kitty
    ./firefox
    ./qutebrowser
    ./rofi
    ./zathura.nix
    ./brave.nix
    ./xdg.nix
    ./fonts.nix
  ];

  programs.mpv.enable = true;

  home.packages = with pkgs; [
  ];


  xsession.enable = true;
  xsession.initExtra = ''
    setxkbmap -option altwin:swap_lalt_lwin -option caps:ctrl_modifier
  '';

  # xresources.properties = {
  #   "Xft.dpi" = 120;
  #   "Xft.autohint" = 0;
  #   "Xft.hintstyle" = "hintfull";
  #   "Xft.hinting" = 1;
  #   "Xft.antialias" = 1;
  #   "Xft.rgba" = "rgb";
  #   "Xcursor*theme" = "Vanilla-DMZ-AA";
  #   "Xcursor*size" = 24;
  # };
}
