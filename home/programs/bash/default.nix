{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    initExtra = ''
      set -o vi
    '';
  };
}
