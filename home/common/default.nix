{ config, pkgs , lib , ... }:

{

  programs.home-manager.enable = true;
  xdg.enable = true;

  programs.bash.enable = true;

  imports = [
    ../programs/alacritty
    ../programs/kitty
    ../programs/fish
    ../programs/bash
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
    ../programs/rofi
    ../programs/firefox
    ../programs/qutebrowser
    ../programs/zathura
    ../programs/xscreensaver

    ../services/emacs
    ../services/gpg-agent
    ../services/networkmanager
    ../services/picom
    ../services/screenlocker       # needs mylockscreen
    ../services/random-background  # needs mywallpapers
    ../services/udiskie
    ../services/flameshot
    ../services/xcape
    ../services/xmonad
    # ../../services/syncthing
    ../services/keyboard
    ../services/redshift
    ../services/uim-korean
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
    graphviz
    pass
    cmatrix
    tokei
    sqlite

    # myemacs  # emacs is installed as emacs
    mymyemacs  # emacs is installed as myemacs
    doom-emacs
    myvim
    mytmux
    mytex

    gphoto2
    ffmpeg
    v4l-utils

    networkmanager_dmenu   # networkmanager on dmenu
    networkmanagerapplet   # networkmanager applet
    xcape                  # keymaps modifier
    xorg.xkbcomp           # keymaps modifier
    xorg.xrandr            # display manager (X Resize and Rotate protocol)
    arandr
    xdotool
    trayer
    pciutils

    acpilight     # xbacklight drop-in replacement; adjust display brightness
    redshift      # adjust display light temperature
    pavucontrol   # control audio in/out

    xmobar
    mynitrogen
    mylockscreen

    killall              # kill processes by name
    bottom               # alternative to htop & ytop
    dmenu                # application launcher
    nix-doc              # nix documentation search tool
    tree                 # display files in a tree view
    xclip                # clipboard support (also for neovim)

    screenlayout
    restart-xmonad
    mysetxkbmap
    dmenu-scripts

    kcolorchooser
    nomacs
    zoom-us
    google-chrome
    brave
    gnome3.nautilus
    libreoffice
    vlc

    dracula-qutebrowser
    anydesk
    # virtualbox
    slack
    # nur.repos.ilya-fedin.kotatogram-desktop
    kotatogram-desktop
    pdfarranger

    wireguard-tools
    wally-cli
    magic-wormhole
    xorg.xev

    agenix
    deploy-rs.deploy-rs
    gimp
    sweethome3d.application
    gscan2pdf

    (agda.withPackages (ps : with ps; [ standard-library ]))


  ] ++ myfonts-collection;

  home.sessionVariables = {
    EDITOR = "emacsclient -c";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    # PATH = "$PATH:${builtins.getEnv "HOME"}/.emacs.d/bin:${builtins.getEnv "HOME"}/.radicle/bin";
  };

  home.shellAliases = {
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

  xdg.configFile."mimeapps.list".text = ''
    [Default Applications]
    x-scheme-handler/http=firefox.desktop
    x-scheme-handler/https=firefox.desktop
    x-scheme-handler/ftp=firefox.desktop
    x-scheme-handler/chrome=firefox.desktop
    text/html=firefox.desktop
    application/x-extension-htm=firefox.desktop
    application/x-extension-html=firefox.desktop
    application/x-extension-shtml=firefox.desktop
    application/xhtml+xml=firefox.desktop
    application/x-extension-xhtml=firefox.desktop
    application/x-extension-xht=firefox.desktop
    application/pdf=org.pwmt.zathura.desktop
    application/pdf=org.pwmt.zathura.desktop
  '';

    # text/html=org.qutebrowser.qutebrowser.desktop
    # x-scheme-handler/http=org.qutebrowser.qutebrowser.desktop
    # x-scheme-handler/https=org.qutebrowser.qutebrowser.desktop
    # x-scheme-handler/about=org.qutebrowser.qutebrowser.desktop
    # x-scheme-handler/unknown=org.qutebrowser.qutebrowser.desktop

    # text/html=brave-browser.desktop
    # x-scheme-handler/http=brave-browser.desktop
    # x-scheme-handler/https=brave-browser.desktop
    # x-scheme-handler/about=brave-browser.desktop
    # x-scheme-handler/unknown=brave-browser.desktop

  xsession.initExtra = ''
    # disable the middle button of Lenovo TrackPoint Keyboard II
    xinput set-button-map "Lenovo TrackPoint Keyboard II Mouse" 1 0 3
  '';


  home.file = {
    ".config/xpm".source = ../xpm;
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
  home.stateVersion = "22.05";

}
