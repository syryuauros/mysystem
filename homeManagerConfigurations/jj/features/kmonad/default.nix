{ inputs, config, lib, pkgs, ... }:
let

  kmonad = inputs.kmonad.packages.${pkgs.system}.default;

in {

  home.packages = [
    kmonad
  ];

  xsession.enable = true;
  xsession.initExtra = ''
    ${kmonad}/bin/kmonad ${./hjkl-arrows.kbd} &
  '';

}
