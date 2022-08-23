{ inputs, config, lib, pkgs, ... }: {

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  environment = {

    systemPackages = with pkgs; [

      neovim
      coreutils
      curl
      wget
      git

    ];

    # etc = {
    #   home-manager.source = "${inputs.home-manager}";
    #   nixpkgs.source = "${inputs.nixpkgs}";
    #   darwin.source = "${inputs.darwin}";
    # };

    # list of acceptable shells in /etc/shells
    shells = with pkgs; [ bashInteractive ];

  };



  imports = [
    # ./users
    ./nix.nix
    ./i18n
    ./xserver
    ./services
    ./hardware
    ./distributed-build
    ./nfs
    # ./ipfs
  ];


  # mymodules.sway.enable = true;

  fonts.fontconfig.enable = true;

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  security.sudo.wheelNeedsPassword = false;

  # services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "ignore";

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "262144";
    }
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 8081 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  system.stateVersion = "22.05";

}
