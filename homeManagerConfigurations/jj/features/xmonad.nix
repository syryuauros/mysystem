{ inputs, pkgs, ... }:

{

  imports = [ inputs.myxmonad.hmModule ];

  home.packages = with pkgs; [
    xmobar
  ];

  mysystem.windowManager.xmonad.enable = true;

}
