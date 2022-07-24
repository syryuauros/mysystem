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


  nix = {

    package = pkgs.nixFlakes;

    # Enable experimental version of nix with flakes support
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      ${lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes"}
    '';

    binaryCaches = [
      "http://haedosa.xyz:201"
      "http://haedosa.xyz:202"
      "http://haedosa.xyz:203"
      # "http://10.10.100.1"
      # "http://10.10.100.2"
      "https://cache.nixos.org/"
      "https://hydra.iohk.io"
      "https://cachix.cachix.org"
      "https://nix-community.cachix.org"
      # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];

    trustedBinaryCaches = [
      "http://haedosa.xyz:201"
      "http://haedosa.xyz:202"
      "http://haedosa.xyz:203"
      "http://192.168.100.54:201"
      "http://192.168.100.54:202"
      "https://cache.nixos.org/"
      "https://hydra.iohk.io"
      "http://10.100.100.1"
      "http://10.100.100.2"
      "http://10.10.100.1"
      "http://10.10.100.2"
      "http://10.10.100.3"
    ];

    binaryCachePublicKeys = [
      "builder1:W5idzEOcUKokokJV6K/9yEKgAtUcBH3IIZ23yE+XW7k="
      "builder2:R7X06/w5h5SfUO4ZvTkkfIjHHEDhrOFYLoQjYVIrFLM="
      "builder3:ICrJJg0EV8V5n90xghprYM7hEZg+dJ5T06gyaHqZtKU="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "https://nixpkgs-wayland.cachix.org"
    ];

    trustedUsers = [
      "root" "@admin" "@wheel"
    ];

    gc = {
      automatic = false;
      options = "--delete-older-than 90d";
    };

    requireSignedBinaryCaches = false;

    # buildCores = 8;
    # maxJobs = 8;
    # readOnlyStore = true;
    # nixPath = [
    #   "nixpkgs=/etc/${config.environment.etc.nixpkgs.target}"
    #   "home-manager=/etc/${config.environment.etc.home-manager.target}"
    # ];

  };


  imports = [
    # ../users
    ../i18n
    ../xserver
    ../services
    ../hardware
    ../distributed-build
    ../nfs
    ../ipfs
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
