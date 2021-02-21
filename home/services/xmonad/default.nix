{ pkgs, ...}:

let

  myInitExtra = ''

    lxsession &
    nitrogen --restore &
    picom --experimental-backends &

    volumeicon &
    # trayer --edge top --align right --widthtype request --padding 0 --SetDockType true \
    #        --SetPartialStrut true --expand true --transparent true \
    #        --alpha 0 --tint 0x282c34 --height 15 &"

    # ${pkgs.util-linux}/bin/setterm -blank 0 -powersave off -powerdown 0
    # ${pkgs.xorg.xset}/bin/xset s off
    # ${pkgs.xorg.xrandr}/bin/xrandr --output LVDS-1 --mode 1366x768 --rate 30.00

    # ${pkgs.pasystray}/bin/pasystray &
    # ${pkgs.blueman}/bin/blueman-applet &
    # ${pkgs.gnome3.networkmanagerapplet}/bin/nm-applet --sm-disable --indicator &

    ${pkgs.xorg.xkbcomp}/bin/setxkbmap -option altwin:swap_lalt_lwin -option caps:ctrl_modifier
    ${pkgs.xcape}/bin/xcape -e 'Shift_L=Escape;Control_L=Escape'
  '';

in
{
  xresources.properties = {
    "Xft.dpi" = 90;
    "Xft.autohint" = 0;
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
    "Xcursor*theme" = "Vanilla-DMZ-AA";
    "Xcursor*size" = 24;
  };

  xsession = {
    enable = true;

    initExtra = myInitExtra;

    windowManager.xmonad = {
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
  };
}
