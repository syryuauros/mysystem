{ config, pkgs, lib, ... }:

{

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNixDirenvIntegration = true;
  };

}
