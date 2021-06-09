# This home configuration file is common for all accounts on a GNU/Linux machine
{ config, pkgs , lib , ... }:

{

  imports = [

    ../../common                     # for darwin and linux

    ../../programs/rofi
    ../../programs/firefox
    ../../programs/qutebrowser
    ../../programs/zathura
    ../../programs/xscreensaver

    ../../services/emacs
    ../../services/gpg-agent
    ../../services/networkmanager
    ../../services/picom
    ../../services/screenlocker       # needs mylockscreen
    ../../services/random-background  # needs mywallpapers
    ../../services/udiskie
    ../../services/flameshot
    ../../services/xcape
    ../../services/xmonad
    ../../services/syncthing
    ../../services/keyboard
    ../../services/redshift
    ../../services/uim-korean
  ];


  home.packages = with pkgs; [

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

    myxmobar
    mynitrogen
    mylockscreen

    killall              # kill processes by name
    bottom               # alternative to htop & ytop
    dmenu                # application launcher
    nix-doc              # nix documentation search tool
    tree                 # display files in a tree view
    xclip                # clipboard support (also for neovim)

    extra-monitor
    restart-xmonad

    kcolorchooser
    nomacs
    zoom-us
    google-chrome
    gnome3.nautilus
    libreoffice
    vlc

    dracula-qutebrowser
    anydesk

  ] ++ myfonts-collection;


  xdg.configFile."mimeapps.list".text = ''
    [Default Applications]
    text/html=org.qutebrowser.qutebrowser.desktop
    x-scheme-handler/http=org.qutebrowser.qutebrowser.desktop
    x-scheme-handler/https=org.qutebrowser.qutebrowser.desktop
    x-scheme-handler/about=org.qutebrowser.qutebrowser.desktop
    x-scheme-handler/unknown=org.qutebrowser.qutebrowser.desktop
    application/pdf=org.pwmt.zathura.desktop
  '';

  xsession.initExtra = ''
    # disable the middle button of Lenovo TrackPoint Keyboard II
    xinput set-button-map "Lenovo TrackPoint Keyboard II Mouse" 1 0 3
  '';


  home.file = {
    ".config/xpm".source = ./xpm;
  };

}
