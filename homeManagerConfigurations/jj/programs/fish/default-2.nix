{ config, pkgs, lib, ... }:

let

  fzfConfig = ''
    set -x FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n
    set -x SKIM_DEFAULT_COMMAND "rg --files || fd || find ."
  '';

  themeConfig = ''
    set -g theme_display_date no
    set -g theme_nerd_fonts yes
    set -g theme_display_git_master_branch no
    set -g theme_nerd_fonts yes
    set -g theme_newline_cursor yes
    set -g theme_color_scheme solarized
  '';

  # nixConfig = ''
  #   if test -e ~/.nix-profile/etc/profile.d/nix.sh
  #     fenv source ~/.nix-profile/etc/profile.d/nix.sh
  #   end
  # '';

  customPlugins = pkgs.callPackage ./plugins.nix {};

  fenv = {
    name = "foreign-env";
    src = pkgs.fishPlugins.foreign-env.src;
  };

  fishConfig = ''
    bind \t accept-autosuggestion
    set fish_greeting
  '' + fzfConfig + themeConfig;

in
{
  programs.fish = {
    enable = true;
    plugins = [ customPlugins.theme fenv ];
    # promptInit = ''
    #   eval (direnv hook fish)
    ####^ this add ~/.nix-profile/bin in front of $PATH in the nix-shell,
    ####  which shadows pathes that are supposed to be exposed.
    #   ${any-nix-shell} fish --info-right | source
    # '';
    promptInit = ''
      any-nix-shell fish --info-right | source
    '';
    shellAliases = {
      cat  = "bat";
      du   = "ncdu --color dark -rr -x";
      ls   = "exa";
      ll   = "ls -a";
      ec   = "emacsclient -c";
      ".." = "cd ..";
      ping = "prettyping";
    };
    shellInit = fishConfig;
  };

  xdg.configFile."fish/functions/fish_prompt.fish".text = customPlugins.prompt;
}
