{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Seoul";

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "@admin" "@wheel" ];
  };

  networking = {
    hostName = "summoner";
    networkmanager.enable = true;
  };

  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.root.initialHashedPassword = "$6$E2y.0yWw9FSxPBz$dLTtVEBbar8vD40nheK3i1hocRMzx3kaaRJbUIZWOSQwVNktTIG7xpNXnrvxWw6zM9KWAHWtzNEKSAMADLTun0";
  users.users = {
    jj = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/jj";
      extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
      hashedPassword = "$6$3nKguLgJMB$leFSKrvWiUAXiay8MJ8i66.ZzufIhkrrbxzv625DV28xSYGBCLp62pyIp4U3s8miHcOdJZpWLgDMEoWljPtT0.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXifjBn6gkBCKkpJJAbB1pJC1zSUljf8SFnPqvB6vIR jj"
      ];
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wget
    brave
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "22.05";

}
