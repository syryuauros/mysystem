{ config, pkgs, lib, ... }:

{

  programs.fish = {
    enable = true;
    plugins = [ ];
    # promptInit = ''
    #   eval (direnv hook fish)
    ####^ this add ~/.nix-profile/bin in front of $PATH in the nix-shell,
    ####  which shadows pathes that are supposed to be exposed.
    #   ${any-nix-shell} fish --info-right | source
    # '';
    promptInit = ''
      starship init fish | source
      any-nix-shell fish --info-right | source
    '';
    shellAliases = {
      # cat  = "bat";
      # du   = "ncdu --color dark -rr -x";
      ls   = "exa";
      ll   = "ls -a";
      ec   = "emacsclient";
      ecc  = "emacsclient -c";
      ".." = "cd ..";
      home = "git --git-dir=$HOME/.home --work-tree=$HOME";
      home-clone = "git clone --separate-git-dir=$HOME/.home git@gitlab.com:wavetojj/myhome.git";
    };
    # shellInit = fishConfig;
  };

}
