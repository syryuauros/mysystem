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
    interactiveShellInit = ''
      starship init fish | source
      any-nix-shell fish --info-right | source
      fish_vi_key_bindings
    '';
    # shellInit = fishConfig;
  };

}
