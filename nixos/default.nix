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

  programs.light.enable = true;
  sound.mediaKeys.enable = true;

  # xmonad takes care of this
  # services.actkbd = {
  #   enable = true;
  #   bindings = [
  #     { keys = [ 224 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -A 5"; }
  #     { keys = [ 225 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -U 5"; }
  #   ];
  # };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 69 4011 80 8080 8081 52647 ];
  networking.firewall.allowedUDPPorts =
    [
      69
      4011  # for pixiecore
      8080
      52647 # for pixiecore
    ];

  networking.firewall.enable = false;


  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.domain = true;
  services.avahi.publish.userServices = true;
  services.avahi.publish.workstation = true;
  services.avahi.nssmdns = true;


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  system.stateVersion = "22.05";

}
