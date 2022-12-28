{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    initExtra = ''
      set -o vi
      ${pkgs.neofetch}/bin/neofetch
    '';
  };
}
