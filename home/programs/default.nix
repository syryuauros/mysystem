{ config, pkgs , lib , ... }:

{

  imports = [
    ./alacritty
    ./kitty
    ./ssh
    ./git
    ./rofi
    ./firefox
    ./qutebrowser
    ./xscreensaver
  ];

  programs.home-manager.enable = true;
  programs.jq.enable = true;
  programs.bat.enable = true;
  programs.zoxide.enable = true;
  programs.pandoc.enable = true;
  programs.mpv.enable = true;
  programs.gpg.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      set -o vi
      ${pkgs.neofetch}/bin/neofetch
    '';
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };

  programs.fish.enable = true;

  programs.broot = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.htop = {
    enable = true;
    settings = {
      sortDescending = true;
      sortKey = "PERCENT_CPU";
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      incremental-search = true;
    };

    # extraConfig = ''
    #   map j scroll up
    #   map k scroll down
    # '';
  };

  programs.brave = {
    enable = true;
    extensions = [
      { id = "gfbliohnnapiefjpjlpjnehglfpaknnc"; } # surfingkeys
      { id = "kbfnbcaeplbcioakkpcpgfkobkghlhen"; } # grammarly
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # darkreader
    ];
  };

}
