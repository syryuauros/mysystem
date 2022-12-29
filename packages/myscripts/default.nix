{ pkgs }:
{

  screenlayout = pkgs.callPackage ./screenlayout {};
  restart-xmonad = pkgs.callPackage ./restart-xmonad {};
  mysetxkbmap = pkgs.callPackage ./mysetxkbmap {};
  dmenu-scripts = pkgs.callPackage ./dmenu-scripts {};
  myinstall = pkgs.callPackage ./myinstall {};

}
