{ inputs, config, lib, pkgs, ... }:
let

  kmonad = inputs.kmonad.packages.${pkgs.system}.default;

  hhkb-usb = pkgs.substitute {
    src = ./hhkb.kbd;
    replacements = [ "--replace" "@hhkb@" "usb-PFU_Limited_HHKB-Hybrid-event-kbd" ];
  };

in {

  home.packages = [
    kmonad
  ];

  xsession.enable = true;
  xsession.initExtra = ''
    ${kmonad}/bin/kmonad ${hhkb-usb} &
    xset r rate 350 70
  '';

}
