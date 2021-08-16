{ config, pkgs, ... }:
{
  imports = [
    ../../../common
    ../../../linux/common
    ./hardware-configuration.nix
    ./web-services.nix
    (import ../../wireguard "10.100.0.4/24")
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  networking = {
    hostName = "l14";
    networkmanager = {
      enable   = true;
      packages = [ pkgs.networkmanager ];
    };
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
  # services.xserver.xkbOptions = "caps:ctrl_modifier";
  services.xserver.xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin";

}
