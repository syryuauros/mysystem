{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      # ls   = "exa";
      du   = "ncdu --color dark";
      la   = "ls -a";
      ll   = "ls -l";
      lla  = "ls -al";
      ec   = "emacsclient";
      ecc  = "emacsclient -c";
      ping = "prettyping";
      ".." = "cd ..";
      p = "pushd";
      d = "dirs -v";
    };
    initExtra = ''
      set -o vi
    '';
  };
}
