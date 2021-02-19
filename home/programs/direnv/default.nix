{ config, pkgs, lib, ... }:

{

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableNixDirenvIntegration = true;
  };

}
