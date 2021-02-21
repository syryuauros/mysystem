{ pkgs, ...}:

{

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = hp: [
      # hp.dbus
      # hp.monad-logger
      hp.xmonad-contrib
      hp.xmonad-extras
    ];
    config = ./xmonad.hs;
  };

}
