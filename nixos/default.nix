{ inputs, config, lib, pkgs, ... }: {

  system.stateVersion = "22.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # fileSystems."/hds/store" = {
  #   device = "10.10.100.4:/hds/store";
  #   fsType = "nfs";
  #   options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
  # };

  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [
      neovim
      coreutils
      curl
      wget
      git
    ];

  environment.etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${inputs.nixpkgs}";
    };

  imports = [
    ./nix.nix
    ./services
    # ./ipfs
    ./peerix.nix
    ./wireguard.nix
  ];

  fonts.fontconfig.enable = true;

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  security.sudo.wheelNeedsPassword = false;

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];

  sound.enable = true;
  sound.mediaKeys.enable = true;

  hardware.bluetooth.enable = true;
  hardware.acpilight.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.keyboard.zsa.enable = true;

  programs.light.enable = true;
  programs.kdeconnect.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 69 4011 80 8080 8081 52647 ];
  networking.firewall.allowedUDPPorts =
    [
      69
      4011  # for pixiecore
      8080
      52647 # for pixiecore
    ];


  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "kime";
    inputMethod.kime.config = {
      engine = {
        hangul.layout = "sebeolsik-3-91";
        global_hotkeys = {
          S-Space = {
            behavior.Toggle = ["Hangul" "Latin"];
            result = "Consume";
          };
          Alt_R = {
            behavior.Toggle = ["Hangul" "Latin"];
            result = "Consume";
          };
        };
      };
    };
  };

}
