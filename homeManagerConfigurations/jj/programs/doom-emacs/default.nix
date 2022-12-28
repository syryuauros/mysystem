{ inputs, config, pkgs, lib, ... }:

{

  imports = [
    inputs.nix-doom-emacs.hmModule
  ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = inputs.doom-private;
  };

}
