{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [

    file
    unzip
    ncdu
    prettyping
    diff-so-fancy
    gnused
    coreutils
    neofetch
    youtube-dl
    syncthing
    pass
    cmatrix
    sqlite

    # rust programs
    fd
    exa
    ripgrep
    tokei
    hyperfine
    procs
    du-dust
    tealdeer
    bandwhich
    grex
    delta

    tree-sitter
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
    i3lock-fancy-rapid

    xmobar
    killall              # kill processes by name
    bottom               # alternative to htop & ytop
    dmenu                # application launcher
    tree                 # display files in a tree view
    xclip                # clipboard support (also for neovim)
    iftop nload         # network traffic monitoring

    kcolorchooser
    nomacs
    zoom-us
    google-chrome
    brave
    gnome.nautilus
    libreoffice
    vlc
    obs-studio
    imagemagick
    inkscape
    graphviz

    anydesk
    # virtualbox
    slack
    # nur.repos.ilya-fedin.kotatogram-desktop
    kotatogram-desktop
    pdfarranger
    solaar                # Linux device manager for the Logitech Unifying Receiver

    # pdf viewers
    foxitreader
    evince
    apvlv
    mupdf
    qpdfview
    okular

    magic-wormhole
    xorg.xev
  ];

}
