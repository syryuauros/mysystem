({ config, lib, pkgs, ... }: {

  imports = [
    ./nix.nix
  ];

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "22.05";
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    pciutils
    htop
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.forwardX11 = true;
  services.openssh.permitRootLogin = "yes";

})
