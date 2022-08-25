{ config, pkgs , lib , ... }:

{

  imports = [
    ./programs
    ./services
  ];

  home.packages = with pkgs; [
    file
    unzip
    ncdu
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


    sqlite
    nixfmt

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
    i3lock-fancy-rapid

    xmobar
    mynitrogen
    mylockscreen

    killall              # kill processes by name
    bottom               # alternative to htop & ytop
    dmenu                # application launcher
    nix-doc              # nix documentation search tool
    tree                 # display files in a tree view
    xclip                # clipboard support (also for neovim)
    iftop                # network traffic monitoring

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
    solaar                # Linux device manager for the Logitech Unifying Receiver

    # pdf viewers
    foxitreader
    evince
    apvlv
    mupdf
    qpdfview
    okular


    wireguard-tools
    wally-cli
    magic-wormhole
    xorg.xev

    agenix
    deploy-rs.deploy-rs
    gimp
    sweethome3d.application
    gscan2pdf
    sxiv

    bfg-repo-cleaner

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
    o = "xdg-open";
  };


  home.keyboard = {
    layout = "us";
    # variant = "workman,";
  };

  xdg.enable = true;

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
    inode/directory=xfce4-file-manager.desktop
    image/png=sxiv.desktop
    image/jpeg=sxiv.desktop
    text/plain=nvim.desktop
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

  # xsession.initExtra = ''
  #   # disable the middle button of Lenovo TrackPoint Keyboard II
  #   xinput set-button-map "Lenovo TrackPoint Keyboard II Mouse" 1 0 3
  # '';

  mysystem.windowManager.xmonad.enable = true;

  home.stateVersion = "22.05";

}
