{

  imports = [

    # base home configurations
    ./base.nix

    # cli applications
    ./features/cli

    # gui applications
    ./features/gui

    # nix related tools
    ./features/nix.nix

    # dependent type language
    ./features/agda.nix

    # personal note live server
    ./features/emanote.nix

    # screenshot
    ./features/flameshot.nix

    ./features/gpg-agent.nix
    ./features/kdeconnect.nix
    ./features/networkmanager.nix
    ./features/redshift.nix

    # screen lock
    ./features/screen-locker.nix

    ./features/syncthing.nix
    ./features/udiskie.nix

    # control becomes esc when pressed alone
    ./features/xcape.nix

    # window manager of my choice
    ./features/xmonad.nix

  ];

}
