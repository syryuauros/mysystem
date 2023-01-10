{ inputs, config, lib, pkgs, ... }:
let

  kmonad = inputs.kmonad.packages.${pkgs.system}.default;


  kmonad-hhkb-usb = pkgs.writeShellScriptBin "kmonad-hhkb-usb"
    (let
      hhkb-usb = pkgs.substitute {
        src = ./hhkb.kbd;
        replacements = [ "--replace" "@device@" "/dev/input/by-id/usb-PFU_Limited_HHKB-Hybrid-event-kbd"
                         "--replace" "@name@" "HHKB-USB"
                       ];
      };
    in "${kmonad}/bin/kmonad ${hhkb-usb}");

  kmonad-hhkb-blt = pkgs.writeShellScriptBin "kmonad-hhkb-blt"
    (let
      hhkb-white = pkgs.substitute {
        src = ./hhkb.kbd;
        replacements = [ "--replace" "@device@" "/dev/input/event22"
                         "--replace" "@name@" "HHKB-Bluetoot"
                       ];
      };
    in "${kmonad}/bin/kmonad ${hhkb-white}");

in {

  home.packages = [
    kmonad
    kmonad-hhkb-usb
    kmonad-hhkb-blt
  ];

  xsession.enable = true;
  xsession.initExtra = ''
    kmonad-hhkb-usb &
    kmonad-hhkb-blt &
    xset r rate 350 70
  '';

}
