{ config, pkgs , lib , ... }:

{

  #------------------------------------------------------------------------------
  #
  #  Programs with heavy customizations
  #
  #------------------------------------------------------------------------------

  imports = [
    ../programs/alacritty
    ../programs/fish
    # ./programs/ssh  # I don't know how to manage the keys
    # ../programs/others
  ] ++ lib.filter lib.pathExists [
    ./private.nix
  ];


  #------------------------------------------------------------------------------
  #
  #  Programs
  #
  #------------------------------------------------------------------------------

  programs.bat.enable = true;

  programs.broot = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableNixDirenvIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.gpg.enable = true;

  programs.htop = {
    enable = true;
    sortDescending = true;
    sortKey = "PERCENT_CPU";
  };

  programs.jq.enable = true;


  #------------------------------------------------------------------------------
  #
  #  Packages
  #
  #------------------------------------------------------------------------------

  home.packages = with pkgs; [

    curl
    wget
    syncthing

    fzf
    ripgrep
    fd
    gnused

    git
    coreutils
    mcron
    gnupg

    neofetch       # information fetcher

    bat
    exa            # better ls
    tree
    broot          # tree explorer

    youtube-dl

    rnix-lsp

    imagemagick

    myEmacs
    myHunspell

  ];


  # You can update Home Manager without changing this value. See the Home Manager release notes for
  # a list of state version changes in each release.
  home.stateVersion = "21.03";

}
