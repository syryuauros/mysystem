{ config, lib, pkgs, inputs, ... }:
let

  myfonts = pkgs.callPackage ../../../../packages/myfonts {};

in
{

  home.packages = with pkgs; with myfonts; [
    # myfonts
    noto-sans-kr
    # noto-serif-kr
    # nerdfonts
    symbola
    seoul-hangan
    mynerdfonts
    noto-fonts-cjk
    # noto-fonts
    material-design-icons
    weather-icons
    font-awesome
    emacs-all-the-icons-fonts
  ];

}
