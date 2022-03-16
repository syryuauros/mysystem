{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      cat  = "bat";
      du   = "ncdu --color dark -rr -x";
      # ls   = "exa";
      ll   = "ls -a";
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
