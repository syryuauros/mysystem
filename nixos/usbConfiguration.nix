({ config, lib, pkgs, ... }: {


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


  nix = {

    package = pkgs.nixVersions.stable;

    # Enable experimental version of nix with flakes support
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      ${lib.optionalString (config.nix.package == pkgs.nixVersions.stable)
      "experimental-features = nix-command flakes"}
      binary-caches-parallel-connections = 3
      connect-timeout = 3
    '';

    settings = {

      substituters = [
        "https://cache.nixos.org/"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      trusted-users = [
        "jj" "root" "@admin" "@wheel"
      ];

      require-sigs = false;

    };

    gc = {
      automatic = false;
      options = "--delete-older-than 90d";
    };

  };


})
