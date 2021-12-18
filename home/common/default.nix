{ config, pkgs , lib , ... }:

{

  programs.home-manager.enable = true;
  xdg.enable = true;

  programs.bash.enable = true;

  imports = [
    ../programs/alacritty
    ../programs/kitty
    ../programs/fish
    ../programs/zsh
    ../programs/starship
    ../programs/fzf
    ../programs/broot
    ../programs/direnv
    ../programs/htop
    ../programs/bat
    ../programs/gpg
    ../programs/jq
    ../programs/ssh
    ../programs/git
    ../programs/zathura
    ../programs/mpv
    # ../programs/doom-emacs
    ../services/email
  ] ++
  lib.filter lib.pathExists [
    ./private.nix
  ];


  home.packages = with pkgs; [
    file
    fd
    unzip
    ncdu
    du-dust
    exa
    ripgrep
    any-nix-shell
    prettyping
    diff-so-fancy
    gnused
    coreutils
    neofetch
    youtube-dl
    syncthing
    rnix-lsp
    imagemagick
    inkscape
    pass
    cmatrix

    # myemacs  # emacs is installed as emacs
    mymyemacs  # emacs is installed as myemacs
    doom-emacs
    myvim
    mytmux
    mytex

    gphoto2
    ffmpeg
    v4l-utils
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    # PATH = "$PATH:${builtins.getEnv "HOME"}/.emacs.d/bin:${builtins.getEnv "HOME"}/.radicle/bin";
  };

  # I wanted two instances of emacs using this chemacs2: one for myemacs and the
  # other for doom-emacs. But I realized that I don't need chemacs2 because with
  # Nix I can install doom-emacs and myemacs as separate packages. Due to the
  # way myemacs is configured, I needed to change the executable names for
  # myemacs such that emacs -> myemacs and emacsclient -> myemacsclient.
  # If I want to use chemacs2 then I have to re-configure myemacs such that
  # it reads a folder like .emacs.d for configurations.
  # home.file = {
  #   ".emacs.d".source = pkgs.mychemacs2;
  #   ".emacs-profiles.el".source = "${pkgs.mychemacs2}/emacs-profiles.el";
  # };

  # You can update Home Manager without changing this value. See the Home Manager release notes for
  # a list of state version changes in each release.
  home.stateVersion = "21.03";

}
