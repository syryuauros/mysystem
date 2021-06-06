{ config, pkgs, ... }:
{
  imports = [
    ../../common
    ../../linux/common
    ./hardware-configuration.nix
    ./web-services.nix
  ];


  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking = {
    hostName = "x230";
    networkmanager = {
      enable   = true;
      packages = [
        pkgs.networkmanager
        pkgs.networkmanager_openvpn ];
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s25.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
  };

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
