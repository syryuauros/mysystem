{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    shellAliases = {
      cat  = "bat";
      du   = "ncdu --color dark -rr -x";
      ls   = "exa";
      ll   = "ls -a";
      ec   = "emacsclient";
      ecc  = "emacsclient -c";
      ".." = "cd ..";
      ping = "prettyping";
    };
  };
}
