{ config, pkgs, ... }:
{
  imports = [
    ../../common
    ../../linux/common
    ./hardware-configuration.nix
    ./web-services.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  networking = {
    hostName = "l14";
    networkmanager = {
      enable   = true;
      packages = [
        pkgs.networkmanager
        pkgs.networkmanager_openvpn ];
    };
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.xkbOptions = "caps:ctrl_modifier";
  # services.xserver.xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # # This value determines the NixOS release from which the default
  # # settings for stateful data, like file locations and database versions
  # # on your system were taken. It‘s perfectly fine and recommended to leave
  # # this value at the release version of the first install of this system.
  # # Before changing this value read the documentation for this option
  # # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "20.03"; # Did you read the comment?

}
