{ config, pkgs, ... }:
{
  imports = [
    ../../../common
    ../../../linux/common
    ../../virtualisation
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # services.xserver.xkbOptions = "caps:ctrl_modifier";
  # This stared not working as of 2021-07-15
  # services.xserver.xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin";

}
