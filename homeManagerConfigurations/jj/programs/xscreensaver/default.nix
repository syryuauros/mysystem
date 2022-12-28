{ pkgs, ... }:

{

  home.packages = [ pkgs.xscreensaver ];

  home.file.".xscreensaver".source = ./xscreensaver;

}
