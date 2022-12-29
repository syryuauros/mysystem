{  pkgs, userId, ... }:

{

  home.username = userId;
  home.homeDirectory = "/home/${userId}";
  home.stateVersion = "22.05";

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


    # myemacs  # emacs is installed as emacs
    mymyemacs  # emacs is installed as myemacs
    # doom-emacs
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
    tree                 # display files in a tree view
    xclip                # clipboard support (also for neovim)
    iftop nload         # network traffic monitoring

    screenlayout
    restart-xmonad
    mysetxkbmap
    dmenu-scripts

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

    nvd
    rnix-lsp
    nixfmt
    nix-doc
    nix-tree
    nix-diff
    nix-du
    deadnix
    statix
    any-nix-shell
    nix-query-tree-viewer
    haskellPackages.nix-derivation # Inspecting .drv's

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

  imports = [
    ./programs
    ./services
  ];

  xdg.enable = true;

  xdg.configFile."mimeapps.list".text = ''
    [Default Applications]
    x-scheme-handler/http=brave-browser.desktop
    x-scheme-handler/https=brave-browser.desktop
    x-scheme-handler/ftp=brave-browser.desktop
    x-scheme-handler/chrome=brave-browser.desktop
    text/html=brave-browser.desktop
    application/x-extension-htm=brave-browser.desktop
    application/x-extension-html=brave-browser.desktop
    application/x-extension-shtml=.desktop
    application/xhtml+xml=brave-browser.desktop
    application/x-extension-xhtml=brave-browser.desktop
    application/x-extension-xht=brave-browser.desktop
    application/pdf=org.pwmt.zathura.desktop
    application/pdf=org.pwmt.zathura.desktop
    inode/directory=xfce4-file-manager.desktop
    image/png=sxiv.desktop
    image/jpeg=sxiv.desktop
    text/plain=nvim.desktop
  '';

  mysystem.windowManager.xmonad.enable = true;

  xresources.properties = {
    "Xft.dpi" = 120;
    "Xft.autohint" = 0;
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
    "Xcursor*theme" = "Vanilla-DMZ-AA";
    "Xcursor*size" = 24;
  };

  xsession.enable = true;
  xsession.initExtra = ''
    setxkbmap -option altwin:swap_lalt_lwin -option caps:ctrl_modifier
  '';

}
