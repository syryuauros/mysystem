{ pkgs, ... }:
{

  home.packages = with pkgs; [
    nomacs
    imagemagick
    gimp
    inkscape
    graphviz
    gphoto2
    sxiv
    zgrviewer
  ];

}
