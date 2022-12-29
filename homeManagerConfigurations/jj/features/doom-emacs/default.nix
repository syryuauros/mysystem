{ inputs, ... }:

{

  imports = [
    inputs.nix-doom-emacs.hmModule
  ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = inputs.doom-private;
  };

}
