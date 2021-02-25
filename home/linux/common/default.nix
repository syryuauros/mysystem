{ config, pkgs , lib , ... }:

{

  imports = [

    ../../common                     # for darwin and linux

    ../../programs/rofi
    ../../programs/firefox

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
  ];

  # fonts.fontconfig.enable = true;

  home.packages = with pkgs; [

    networkmanager_dmenu   # networkmanager on dmenu
    networkmanagerapplet   # networkmanager applet
    xcape                  # keymaps modifier
    xorg.xkbcomp           # keymaps modifier
    xorg.xrandr            # display manager (X Resize and Rotate protocol)
    xdotool
    trayer

    myxmobar
    mynitrogen
    mylockscreen

    killall              # kill processes by name
    bottom               # alternative to htop & ytop
    dmenu                # application launcher
    nix-doc              # nix documentation search tool
    tree                 # display files in a tree view
    xclip                # clipboard support (also for neovim)

    zoom-us
  ] ++ myfonts-collection;

}
