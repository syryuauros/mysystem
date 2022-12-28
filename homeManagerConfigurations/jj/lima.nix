{ config, lib, pkgs, ... }:

{

  imports = [
    ./common.nix
    ./features/cli
    ./features/gui
    ./features/xmonad
  ];

}
