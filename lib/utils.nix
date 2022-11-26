{ pkgs, ... }:

{

  getToplevel = nixos-system: nixos-system.config.system.build.toplevel;
  getIsoImage = nixos-system: nixos-system.config.system.build.isoImage;

}
